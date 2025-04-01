import * as THREE from 'three'
import { useRef, useState } from 'react'
import { Canvas, useFrame } from '@react-three/fiber'


function isDarkTheme() {
  const starlightTheme = localStorage["starlight-theme"];
  if (starlightTheme !== '') {
    return starlightTheme === 'dark'
  }
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
  return prefersDark.matches;
}

function getColor() {
  return isDarkTheme() ? "white" : "black"
}

function Box(props: any) {
  const meshRef = useRef<THREE.Mesh>(null!)
  useFrame((_, delta) => {
    setColor(getColor()
    )
    meshRef.current.rotation.x += (delta * props.rotationMult[0])
    meshRef.current.rotation.y += (delta * props.rotationMult[1])
    meshRef.current.rotation.z += (delta * props.rotationMult[2])
  })
  const [color, setColor] = useState(getColor())
  return (
    <mesh
      {...props}
      ref={meshRef}
      scale={3}>
      <boxGeometry args={[1, 1, 1]} />
      <meshStandardMaterial color={color} />
    </mesh>
  )
}
const Logo = () => {
  return (
    <a className="logo" href="/">
      <Canvas id='logo-canvas'>
        <ambientLight intensity={Math.PI / 2} />
        <spotLight position={[10, 10, 10]} angle={0.15} penumbra={1} decay={0} intensity={Math.PI} />
        <pointLight position={[-10, -10, -10]} decay={0} intensity={Math.PI} />
        <Box rotation={[0, 4, 0]} rotationMult={[1, 1, 0]} />
        <Box rotation={[0, 4, 0]} rotationMult={[0, 1, 1]} />
        <Box rotation={[0, 4, 0]} rotationMult={[1, 0, 1]} />
      </Canvas>
    </a>
  )
}

export default Logo;


