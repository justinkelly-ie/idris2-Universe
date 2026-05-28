import { useState, useMemo, useRef } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { OrbitControls, Line, Sphere, Html, Sparkles, Trail, Plane } from '@react-three/drei';
import * as THREE from 'three';
import './index.css';

// Calculates integer-snapped coordinates
function getDiscreteCoord(tension: number, target: THREE.Vector3) {
  const t = 1 - tension; // 0 = locked, 1 = far apart
  const pos = target.clone().multiplyScalar(t * 10);
  // Snap to integer Maxel grid
  return new THREE.Vector3(Math.round(pos.x), Math.round(pos.y), pos.z);
}

function BaryonSystem({ tension }: { tension: number }) {
  const isLocked = tension < 0.05;

  // Tension governs Z-depth: pushes particles into the Invisible Universe (Z < 0)
  // When locked, they cross the Spread Polynomial boundary (Z = 0) into Visible (Z > 0)
  const zDepth = isLocked ? 2 : Math.round(-tension * 8); 

  // The ideal locked coordinates for the Omega Triangle
  const idealQ1 = new THREE.Vector3(0, 3, zDepth);
  const idealQ2 = new THREE.Vector3(-4, 0, zDepth);
  const idealQ3 = new THREE.Vector3(4, 0, zDepth);

  const q1Pos = isLocked ? new THREE.Vector3(0,1,zDepth) : getDiscreteCoord(tension, idealQ1);
  const q2Pos = isLocked ? new THREE.Vector3(0,1,zDepth) : getDiscreteCoord(tension, idealQ2);
  const q3Pos = isLocked ? new THREE.Vector3(0,1,zDepth) : getDiscreteCoord(tension, idealQ3);

  // Math visualizer
  const quad1 = q1Pos.distanceToSquared(q2Pos);
  const quad2 = q2Pos.distanceToSquared(q3Pos);
  const quad3 = q3Pos.distanceToSquared(q1Pos);
  const A = 4 * quad1 * quad2; // Simplified Archimedes for demo
  const T = isLocked ? A : A + Math.round(tension * 100);

  // Simulated S_5 Spread Polynomial calculation
  // Quarks (n=5) famously leave 1/3 or 2/3 residues. We visualize this mathematically here:
  const baseFraction = Math.floor(tension * 10);
  const remainder = (Math.floor(tension * 100) % 2) === 0 ? 1 : 2;
  const fractionStr = `${baseFraction * 3 + remainder}/3`;

  const spreadValue = isLocked 
    ? "S_5(s) = 1 (Natural Number \u2208 \u2115)"
    : `S_5(s) = ${fractionStr} (Fractional Residue)`;

  return (
    <group>
      {/* The Spread Polynomial Boundary (Z = 0) */}
      <Plane args={[40, 40]} position={[0, 0, 0]} rotation={[0, 0, 0]}>
        <meshPhysicalMaterial 
          color="#111111" 
          transparent opacity={0.6} 
          roughness={0.1}
          metalness={0.8}
        />
      </Plane>

      {/* Floating Labels for the Realms */}
      <Html position={[10, 10, 1]} center>
        <div style={{ color: '#00aaff', fontWeight: 'bold', letterSpacing: '2px' }}>VISIBLE UNIVERSE (BLUE METRIC)</div>
      </Html>
      <Html position={[10, 10, -1]} center>
        <div style={{ color: '#00ff00', fontWeight: 'bold', letterSpacing: '2px' }}>INVISIBLE COMPUTE SUBSTRATE (GREEN/RED)</div>
      </Html>

      {/* The Quarks */}
      {!isLocked && (
        <>
          <Trail width={2} color="#00ff00" length={4} decay={1}>
            <Sphere args={[0.4, 32, 32]} position={q1Pos}>
              <meshStandardMaterial color="#00ff00" emissive="#00ff00" emissiveIntensity={2} wireframe />
            </Sphere>
          </Trail>
          <Trail width={2} color="#00ff00" length={4} decay={1}>
            <Sphere args={[0.4, 32, 32]} position={q2Pos}>
              <meshStandardMaterial color="#00ff00" emissive="#00ff00" emissiveIntensity={2} wireframe />
            </Sphere>
          </Trail>
          <Trail width={2} color="#00ff00" length={4} decay={1}>
            <Sphere args={[0.4, 32, 32]} position={q3Pos}>
              <meshStandardMaterial color="#00ff00" emissive="#00ff00" emissiveIntensity={2} wireframe />
            </Sphere>
          </Trail>

          {/* Green Metric Tension (Chaotic noise restricted to invisible realm) */}
          <Sparkles count={500} scale={20} size={2} color="#00ff00" speed={2} opacity={0.5} position={[0,0,-4]} />
          
          <Line points={[q1Pos, q2Pos]} color="#00ff00" lineWidth={1} dashed dashScale={10} />
          <Line points={[q2Pos, q3Pos]} color="#00ff00" lineWidth={1} dashed dashScale={10} />
          <Line points={[q3Pos, q1Pos]} color="#00ff00" lineWidth={1} dashed dashScale={10} />
        </>
      )}

      {/* The Locked Baryon (Pushed into Visible Realm) */}
      {isLocked && (
        <group position={[0,0,zDepth]}>
          <Sphere args={[1.5, 64, 64]} position={[0,0,0]}>
            <meshPhysicalMaterial 
              color="#0055ff" 
              emissive="#0022ff" 
              emissiveIntensity={1.5}
              clearcoat={1}
              transmission={0.9}
              thickness={0.5}
              roughness={0.1}
            />
          </Sphere>
          <Sphere args={[0.2, 16, 16]} position={[0, 0.4, 0]}><meshBasicMaterial color="#ffffff" /></Sphere>
          <Sphere args={[0.2, 16, 16]} position={[-0.3, -0.2, 0]}><meshBasicMaterial color="#ffffff" /></Sphere>
          <Sphere args={[0.2, 16, 16]} position={[0.3, -0.2, 0]}><meshBasicMaterial color="#ffffff" /></Sphere>
          
          <Sparkles count={100} scale={5} size={4} color="#00aaff" speed={0.2} />
        </group>
      )}

    </group>
  );
}

function MaxelGrid() {
  return (
    <group>
      <gridHelper args={[40, 40, '#333333', '#111111']} rotation={[Math.PI / 2, 0, 0]} position={[0,0,-4]} />
      {/* Distinct integer nodes */}
      <points>
        <bufferGeometry>
          <bufferAttribute
            attach="attributes-position"
            count={400}
            array={new Float32Array(Array.from({length: 400}).flatMap((_, i) => [
              (i % 20) * 2 - 20, 
              Math.floor(i / 20) * 2 - 20, 
              -4
            ]))}
            itemSize={3}
          />
        </bufferGeometry>
        <pointsMaterial size={0.1} color="#555555" />
      </points>
    </group>
  );
}

export default function App() {
  const [tension, setTension] = useState(1);
  const isLocked = tension < 0.05;

  // Lifted Math Calculations for 2D UI Overlay
  const zDepth = isLocked ? 2 : Math.round(-tension * 8); 
  const idealQ1 = new THREE.Vector3(0, 3, zDepth);
  const idealQ2 = new THREE.Vector3(-4, 0, zDepth);
  const idealQ3 = new THREE.Vector3(4, 0, zDepth);
  const q1Pos = isLocked ? new THREE.Vector3(0,1,zDepth) : getDiscreteCoord(tension, idealQ1);
  const q2Pos = isLocked ? new THREE.Vector3(0,1,zDepth) : getDiscreteCoord(tension, idealQ2);
  const quad1 = q1Pos.distanceToSquared(q2Pos);
  const quad2 = q2Pos.distanceToSquared(idealQ3); // simplified for stable UI projection
  const A = 4 * quad1 * quad2; 
  const T = isLocked ? A : A + Math.round(tension * 100);

  const baseFraction = Math.floor(tension * 10);
  const remainder = (Math.floor(tension * 100) % 2) === 0 ? 1 : 2;
  const fractionStr = `${baseFraction * 3 + remainder}/3`;
  const spreadValue = isLocked 
    ? "S_5(s) = 1 (Natural Number \u2208 \u2115)"
    : `S_5(s) = ${fractionStr} (Fractional Residue)`;

  return (
    <div style={{ width: '100vw', height: '100vh', background: '#020202', position: 'relative' }}>
      
      {/* Top Left UI Controls */}
      <div style={{ position: 'absolute', top: 20, left: 20, zIndex: 10, color: 'white', fontFamily: 'monospace' }}>
        <h1 style={{ fontSize: '24px', margin: '0 0 5px 0', textTransform: 'uppercase', letterSpacing: '2px' }}>
          LUniverse: Discrete Physics
        </h1>
        <h2 style={{ fontSize: '14px', margin: '0 0 20px 0', color: '#888' }}>
          Spread Polynomial Boundary Visualization
        </h2>
        
        <div style={{ background: 'rgba(20,20,20,0.8)', padding: '20px', borderRadius: '4px', border: '1px solid #333' }}>
          <label style={{ display: 'block', marginBottom: '10px', fontSize: '12px', color: '#aaa' }}>
            DRAG TO SOLVE S_5(s)
          </label>
          <input 
            type="range" 
            min="0" max="1" step="0.01" 
            value={tension} 
            onChange={(e) => setTension(parseFloat(e.target.value))}
            style={{ width: '300px', cursor: 'pointer' }}
          />
        </div>
      </div>

      {/* Bottom Left Equation Hub (Fixed 2D Overlay) */}
      <div style={{ 
        position: 'absolute', bottom: 20, left: 20, zIndex: 10,
        background: isLocked ? 'rgba(0, 50, 255, 0.2)' : 'rgba(0, 255, 0, 0.1)', 
        border: `1px solid ${isLocked ? '#00aaff' : '#00ff00'}`,
        padding: '15px 25px', 
        color: 'white', 
        fontFamily: 'monospace',
        textAlign: 'center',
        backdropFilter: 'blur(10px)',
        width: '350px'
      }}>
        <div style={{ fontSize: '18px', marginBottom: '5px' }}>
          A(Q) = {A.toFixed(0)}
        </div>
        <div style={{ fontSize: '18px', color: isLocked ? 'white' : '#ff3333', marginBottom: '10px' }}>
          T(s) = {T.toFixed(0)}
        </div>
        <div style={{ fontSize: '14px', color: isLocked ? '#00ffff' : '#ffaa00', marginBottom: '10px', background: 'rgba(0,0,0,0.5)', padding: '5px' }}>
          {spreadValue}
        </div>
        <hr style={{ borderColor: 'rgba(255,255,255,0.2)', margin: '10px 0' }}/>
        <div style={{ fontWeight: 'bold', color: isLocked ? '#00ffff' : '#ff3333' }}>
          {isLocked ? 'STRUCTURAL LOCK -> VISIBLE PROJECTION' : 'SPREAD POLYNOMIAL OVERFLOW -> CONFINED'}
        </div>
      </div>

      <Canvas camera={{ position: [20, -10, 15], fov: 45 }}>
        <color attach="background" args={['#020202']} />
        <ambientLight intensity={0.2} />
        <pointLight position={[0, 0, 10]} intensity={2} color="#00aaff" />
        <OrbitControls enablePan={true} enableZoom={true} enableRotate={true} />
        
        <MaxelGrid />
        <BaryonSystem tension={tension} />
      </Canvas>
    </div>
  );
}
