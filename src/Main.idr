module Main

import Simplex.Core
import Simplex.SigmaLinear
import Physics.SigmaBridge
import Math.Chromogeometry
import Math.Multiset

main : IO ()
main = do
  putStrLn "--- Initializing Sigma-Linear Architecture Test ---"
  
  -- Create a basic geometry point and amplitude
  let geom = MkPixel 0 0
  let amp = emptyAmplitude
  
  -- Create a SparseMaxel with count 5
  let initialMaxel = AddM (geom, amp) 5 ZeroM
  
  putStrLn "1. Raw non-linear SparseMaxel constructed (Count = 5)."
  
  -- Melt into Dynamic Universe
  let dynamicU = sigmaMeltMaxel initialMaxel
  putStrLn "2. Melted into Dynamic Universe DPair."
  
  -- Evolve 1 step (which structurally forces the linear engine to increment count)
  let nextU = runDynamicEpoch dynamicU
  putStrLn "3. Executed runDynamicEpoch (Linear Execution mapped to Math Spec)."
  
  -- Freeze back to legacy SparseMaxel
  let frozenMaxel = sigmaFreezeMaxel nextU
  putStrLn "4. Frozen back to legacy SparseMaxel."
  
  putStrLn "--- Testing Topological Boundary Operator ---"
  
  -- Create two distinct geometry nodes (Vertices)
  let nodeA = MkPixel 0 0
  let nodeB = MkPixel 1 1
  
  -- Create a Substrate (Edge) from nodeA to nodeB
  let edge = (nodeA, nodeB)
  
  -- Legacy Substrate (Multiset of edges)
  let legacySubstrate = AddM edge 10 ZeroM
  putStrLn "1. Legacy Substrate constructed: 10 directed edges from A to B."
  
  -- Melt into Dynamic Substrate
  let dynamicChain = sigmaMeltChain legacySubstrate
  
  -- Execute Topological Boundary Operator (O(1) Linear shredding)
  let dynamicBoundary = runBoundary dynamicChain
  putStrLn "2. Executed runBoundary (Linear Shredding mapped to Topo Spec)."
  
  -- Freeze back to Legacy SparseMaxel (Vertices)
  let frozenBoundary = sigmaFreezeGeometryMaxel dynamicBoundary
  
  let boundaryCounts = multisetToList frozenBoundary
  case boundaryCounts of
    (((nB, _), 10) :: ((nA, _), -10) :: _) => 
      putStrLn "\nSUCCESS: Boundary topological constraints enforced! B=+10, A=-10."
    _ => putStrLn "\nFAILURE: Boundary topology didn't reduce correctly."
