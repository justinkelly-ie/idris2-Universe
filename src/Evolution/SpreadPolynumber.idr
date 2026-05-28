module Evolution.SpreadPolynumber

import Math.Multiset
import Math.IntPolynumber
import Math.Chromogeometry
import Simplex.Core
import Simplex.Twist
import Evolution.State
import Evolution.Transform
import Evolution.Gate


||| Restored Bridge Function: Converts the direct chromogeometric curvature 
||| of a local coordinate point into an active time-evolution Polynumber operator.
public export
generateLocalSpreadPoly : Metric 
                       -> Substrate 
                       -> Pixel Integer -- The local voxel point being evaluated
                       -> IntPolynumber
generateLocalSpreadPoly metric substrate currentGeom =
  let edges = multisetToList substrate
      
      -- 1. Extract only the local triads that originate or touch our currentGeom
      localTriads = [ (p1, p2, p3, m1 * m2) 
                    | ((p1, p2), m1) <- edges
                    , ((p2', p3), m2) <- edges
                    , p2 == p2'
                    , p1 == currentGeom || p2 == currentGeom || p3 == currentGeom
                    ]
                    
      -- 2. Compute the precise localized rational spread fractions for these neighbor links
      localFractions = map (\(p1, p2, p3, mult) => 
                         let (num, den) = spreadNL metric p1 p2 p3
                         in (num * mult, den)
                       ) localTriads
                       
      -- 3. Consolidate into a memory-safe, GCD-reduced total local twist integer
      (finalNum, finalDen) = foldl addRationalLocal (0, 1) localFractions
      localTwistVal        = if finalDen == 0 then 0 else finalNum `div` finalDen
      
      -- 4. Map the geometric twist directly into unique polynomial exponents!
      -- This replaces generic time lookup with an explicit localized spatial wave term.
      basisPowerA = fromInteger (abs localTwistVal `mod` 13)
      basisPowerB = fromInteger (abs localTwistVal `mod` 137)
      
      -- Seed a custom monomial operator using the exact geometric constraints
  in AddM (cast basisPowerA, cast basisPowerB) 1 ZeroM


||| Drives a complete generational evolution step where time-propagation is 
||| entirely localized and driven by the restored SpreadPolynumber bridge.
public export
stepUniverseLocalized : Integer
                     -> Metric
                     -> Substrate
                     -> SparseMaxel
                     -> (Substrate, SparseMaxel)
stepUniverseLocalized capacityLimit metric currentSubstrate stateVector =
  let -- 1. Evolve fields by generating an individualized SpreadPolynumber per pixel coordinate!
      evolvedStates = map (\((geom, amp), stateCount) => 
                            let localPropagator = generateLocalSpreadPoly metric currentSubstrate geom
                                fusedAmplitude  = scaleMultiset stateCount (mulIntPoly amp localPropagator)
                            in ((geom, fusedAmplitude), stateCount))
                          (multisetToList stateVector)
      
      -- 2. Execute partition and resonance over the uniform coordinate pixels
      processedItems = concatMap (\((geom, amp), stateCount) =>
                                   let (latentSpace, visibleSpace) = partitionLogic 128 geom amp
                                       stabilizedVisible = evaluateResonance capacityLimit 13 geom visibleSpace
                                   in multisetToList (addMultiset latentSpace stabilizedVisible))
                                 evolvedStates
  in (currentSubstrate, fromList processedItems)
