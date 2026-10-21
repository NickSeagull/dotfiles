"""Real supervisor/socket/subprocess tests with a harmless fake input engine.

No input capture or GUI work occurs. This exercises the actual supervisor loop,
including successful emergency-style exit, runner loss, crash recovery and stop.
"""
import json
import os
from pathlib import Path
import pwd
import selectors
import signal
import socket
import subprocess
import sys
import tempfile
import time
import unittest

SOURCE = Path(os.environ.get("KEYBOARD_SOURCE", Path(__file__).resolve().parents[1]))
sys.path.insert(0, str(SOURCE))
from service import packet, rpc


class RunnerTransport(unittest.TestCase):
    """Production runner over its real Unix protocol; only the GUI helper is fake."""

    def setUp(self):
        directory = tempfile.TemporaryDirectory(prefix='keyboard-runner-', dir='/tmp')
        self.addCleanup(directory.cleanup)
        root = Path(directory.name)
        self.calls = root / 'calls.jsonl'
        helper = root / 'helper'
        helper.write_text('#!' + sys.executable + '\n' + '''
import json,sys
for line in sys.stdin:
    request=json.loads(line)
    with open(''' + repr(str(self.calls)) + ''', 'a') as log:
        log.write(json.dumps(request)+'\\n')
    response={'accessibility':True} if request['command']=='permissions' else {'ok':True}
    if request['command']=='window.previous': response={'error':'fixture action failed'}
    print(json.dumps(response),flush=True)
''')
        helper.chmod(0o700)
        server = socket.socket(socket.AF_UNIX)
        self.addCleanup(server.close)
        address = str(root / 'control')
        server.bind(address)
        server.listen()
        server.settimeout(5)
        self.log = (root / 'runner.log').open('w+')
        self.addCleanup(self.log.close)
        self.process = subprocess.Popen([sys.executable, str(SOURCE / 'runner.py'),
            '--helper', str(helper), '--adapter', str(SOURCE / 'macos.json'),
            '--socket', address], stdout=self.log, stderr=self.log)
        self.addCleanup(self.stop)
        self.conn, _ = server.accept()
        self.addCleanup(self.conn.close)
        self.conn.settimeout(5)
        self.reader = self.conn.makefile('rb')
        self.addCleanup(self.reader.close)
        self.assertEqual(self.receive(), {'command':'register', 'accessibility':True})
        packet(self.conn, {'registered':True})
        self.assertEqual(self.receive(), {'ack':True})

    def stop(self):
        if self.process.poll() is None:
            self.process.terminate()
        self.process.wait(timeout=5)

    def receive(self):
        line = self.reader.readline()
        self.assertTrue(line, 'runner disconnected')
        return json.loads(line)

    def event(self, event):
        packet(self.conn, {'event':event})

    def test_array_messages_dispatch_repeatedly_and_runner_keeps_answering(self):
        for _ in range(3):
            self.event({'MessagePush':{'message':['launch.telegram']}})
            self.assertEqual(self.receive(), {'ack':True})
        self.event({'LayerChange':{'new':'windows'}})
        self.assertEqual(self.receive(), {'ack':True})
        self.event({'MessagePush':{'message':['window.next']}})
        self.assertEqual(self.receive(), {'ack':True})
        self.event({'LayerChange':{'new':'base'}})
        self.assertEqual(self.receive(), {'ack':True})
        packet(self.conn, {'ping':True})
        self.assertEqual(self.receive(), {'ack':True, 'accessibility':True})
        self.assertEqual(self.receive(), {'ack':True})
        calls = [json.loads(line) for line in self.calls.read_text().splitlines()]
        self.assertEqual(calls, [{'command':'permissions'}] +
            [{'command':'launch', 'bundle':'com.tdesktop.Telegram'}] * 3 +
            [{'command':'begin'}, {'command':'window.next'}, {'command':'end'}, {'command':'permissions'}])
        self.assertIsNone(self.process.poll())

    def test_bad_payload_and_native_failure_report_failure_without_crashing(self):
        for payload in (None, 'launch.telegram', [], [['launch.telegram']],
                        ['launch.telegram', 'app.next'], ['unknown'], ['window.previous']):
            self.event({'MessagePush':{'message':payload}})
            self.assertIn('failure', self.receive())
            self.assertEqual(self.receive(), {'ack':True})
            self.assertIsNone(self.process.poll())
        calls = [json.loads(line) for line in self.calls.read_text().splitlines()]
        self.assertEqual(calls, [{'command':'permissions'}, {'command':'window.previous'}])


@unittest.skipUnless(sys.platform == 'darwin', 'Darwin credentials and console session')
class Lifecycle(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory(prefix='keyboard-test-', dir='/tmp')
        self.root = Path(self.directory.name)
        self.socket = str(self.root/'control')
        self.state = self.root/'state'
        self.config = self.root/'behavior'
        self.config.write_text('running')
        self.engine = self.root/'engine'
        self.engine.write_text('''#!'''+sys.executable+'''
import argparse,socket,time,pathlib
p=argparse.ArgumentParser();p.add_argument('--cfg');p.add_argument('--port');p.add_argument('--no-wait',action='store_true');a=p.parse_args()
server=socket.socket();server.bind(('127.0.0.1',int(a.port.rsplit(':',1)[1])));server.listen();conn,_=server.accept()
conn.sendall(b'{"LayerChange":{"new":"base"}}\\n')
while pathlib.Path(a.cfg).read_text()=='running': time.sleep(.02)
''')
        self.engine.chmod(0o700)
        self.harness = self.root/'harness.py'
        # The only substituted prerequisite is driver discovery. All process,
        # socket, state and fail-off behavior comes from the production module.
        self.harness.write_text('import sys\nsys.path.insert(0, '+repr(str(SOURCE))+')\nimport service\nservice.driver_active=lambda: True\nservice.main()\n')
        self.log = (self.root/'log').open('w+')
        self.process = self.start()
        self.runner = socket.socket(socket.AF_UNIX)
        self.runner.settimeout(.1)
        self.wait(lambda: Path(self.socket).exists())
        self.runner.connect(self.socket)
        packet(self.runner, {'command':'register','accessibility':True})
        self.buffer = b''

    def start(self):
        return subprocess.Popen([sys.executable,str(self.harness),'supervise','--user',pwd.getpwuid(os.getuid()).pw_name,'--socket',self.socket,'--state',str(self.state),'--engine',str(self.engine),'--config',str(self.config)],stdout=self.log,stderr=self.log)

    def tick(self):
        if self.runner:
            try:
                data=self.runner.recv(65536)
                if not data: return
                self.buffer+=data
                while b'\n' in self.buffer:
                    line,self.buffer=self.buffer.split(b'\n',1)
                    message=json.loads(line)
                    if message.get('ping') or message.get('event'):
                        packet(self.runner, {'ack':True})
            except socket.timeout: pass

    def wait(self, predicate, timeout=6):
        deadline=time.monotonic()+timeout
        while time.monotonic()<deadline:
            if predicate(): return
            if getattr(self,'runner',None): self.tick()
            else: time.sleep(.02)
        self.log.flush();self.log.seek(0)
        self.fail('lifecycle wait timed out\n'+self.log.read())

    def status(self):
        try:
            return rpc('status',self.socket)
        except (OSError, ValueError):
            self.log.flush(); self.log.seek(0)
            print(self.log.read(), flush=True)
            raise

    def tearDown(self):
        if self.runner: self.runner.close()
        if self.process.poll() is None:
            self.process.terminate();self.process.wait(timeout=5)
        self.log.close();self.directory.cleanup()

    def test_exit_zero_disables_and_explicit_enable_recovers(self):
        self.wait(lambda: self.status()['state']=='running')
        self.config.write_text('exit-zero')
        self.wait(lambda: self.status()['state']=='disabled')
        self.assertIsNone(self.status()['engine_pid'])
        self.config.write_text('running')
        self.assertEqual(self.status()['state'],'disabled')
        self.assertFalse(rpc('enable',self.socket).get('error'))
        self.wait(lambda: self.status()['state']=='running')
        rpc('disable',self.socket)
        self.assertEqual(self.status()['state'],'disabled')

    def test_runner_loss_stops_input_and_disable_survives_restart(self):
        self.wait(lambda: self.status()['state']=='running')
        self.runner.close();self.runner=None
        self.wait(lambda: self.status()['state']=='disabled')
        self.process.terminate();self.process.wait(timeout=5)
        self.process=self.start()
        self.wait(lambda: Path(self.socket).exists() and self.status()['state']=='disabled')
        self.assertIsNone(self.status()['engine_pid'])

    def test_runner_that_stops_responding_fails_off(self):
        self.wait(lambda: self.status()['state']=='running')
        deadline = time.monotonic() + 6
        while time.monotonic() < deadline:
            if self.status()['state'] == 'disabled':
                break
            time.sleep(.1)  # Intentionally do not consume or acknowledge runner pings.
        self.assertEqual(self.status()['state'], 'disabled')
        self.assertIsNone(self.status()['engine_pid'])

    def test_crashed_engine_fails_off(self):
        self.wait(lambda: self.status()['state']=='running')
        os.kill(self.status()['engine_pid'], signal.SIGKILL)
        self.wait(lambda: self.status()['state']=='disabled')
        self.assertIsNone(self.status()['engine_pid'])

    def test_orderly_supervisor_stop_preserves_enabled_startup(self):
        self.wait(lambda: self.status()['state']=='running')
        self.process.terminate();self.process.wait(timeout=5)
        self.assertFalse((self.state/'active').exists())
        self.assertFalse((self.state/'disabled.json').exists())
