# Focus-Or-Start: Focus an app if running, launch it if not
# Usage: Focus-Or-Start.ps1 -AppName "notepad"
#
# Windows — checks for running process, brings window to front or starts app

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$AppName
)

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")]
    public static extern bool IsIconic(IntPtr hWnd);
}
"@

$proc = Get-Process -ErrorAction SilentlyContinue |
    Where-Object { $_.ProcessName -like "*$AppName*" -and $_.MainWindowHandle -ne 0 } |
    Select-Object -First 1

if ($proc) {
    $hwnd = $proc.MainWindowHandle
    # Restore if minimized
    if ([WinAPI]::IsIconic($hwnd)) {
        [WinAPI]::ShowWindow($hwnd, 9)  # SW_RESTORE
    }
    [WinAPI]::SetForegroundWindow($hwnd) | Out-Null
} else {
    Start-Process $AppName
}
