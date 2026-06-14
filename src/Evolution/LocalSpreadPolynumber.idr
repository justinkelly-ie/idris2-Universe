module Evolution.LocalSpreadPolynumber

import Math.Multiset
import Math.IntPolynumber
import Math.Chromogeometry
import Simplex.Core
import Simplex.Twist
import Evolution.State
import Evolution.Transform
import Evolution.Gate
import System.CosmicPartition
import Math.BoxInt


||| List-based helper for generateLocalSpreadPoly.
public export
generateLocalSpreadPolyList : Metric
                           -> List ((Geometry, Geometry), Integer)
                           -> Geometry
                           -> IntPolynumber
generateLocalSpreadPolyList metric edges currentGeom =
  let _ = metric  -- Blue used unconditionally below; metric arg retained for API compatibility
      -- 1. Extract only the local triads that originate or touch currentGeom
      localTriads = [ (p1, p2, p3, m1 * m2)
                    | ((p1, p2), m1) <- edges
                    , ((p2', p3), m2) <- edges
                    , p2 == p2'
                    , p1 == currentGeom || p2 == currentGeom || p3 == currentGeom
                    ]

      -- 2. Compute localised rational spread fractions (Blue unconditional)
      localFractions = map (\(p1, p2, p3, mult) =>
                         let (num, den) = spreadNL Blue p1 p2 p3
                             (MkUr numVal) = boxToInt num
                             (MkUr denVal) = boxToInt den
                         in (numVal * mult, denVal)
                       ) localTriads

      -- 3. Consolidate into a GCD-reduced total local twist integer
      (finalNum, finalDen) = foldl addRationalLocal (0, 1) localFractions
      localTwistVal        = if finalDen == 0 then 0 else finalNum `div` finalDen

      -- 4. Select the Adaptive Cycle gate for this local phase and return
      --    its canonical symbolic Spread Polynomial Expression, evaluated as
      --    the amplitude propagator.
      gateN = degree (selectGate (fromInteger (abs localTwistVal `mod` 137)))
      symbolicExpr = makeSpreadPolyExpr gateN
  in evalSpreadPolyExpr symbolicExpr


||| Converts the chromogeometric curvature of a local coordinate point
||| into an Adaptive Cycle spread polynomial operator.
public export
generateLocalSpreadPoly : Metric
                       -> Substrate
                       -> Geometry
                       -> IntPolynumber
generateLocalSpreadPoly metric substrate currentGeom =
  generateLocalSpreadPolyList metric (multisetToList substrate) currentGeom


||| List-based helper for deformSubstrate.
public export
deformSubstrateList : List ((Geometry, Geometry), Integer)
                    -> List ((Geometry, Amplitude), Integer)
                    -> List ((Geometry, Geometry), Integer)
deformSubstrateList edges states =
  let -- Helper to extract the mass-energy count at a given coordinate
      getEnergy : Geometry -> Integer
      getEnergy geom =
        case filter (\((g, _), _) => g == geom) states of
          ((_, c) :: _) => c
          []            => 0
          
      -- Deform each edge multiplicity proportionally to source/target energy
      deformedEdges = map (\((src, tgt), count) =>
                             let energySrc = getEnergy src
                                 energyTgt = getEnergy tgt
                             in ((src, tgt), count + energySrc + energyTgt)
                          ) edges
  in deformedEdges


||| Dynamically deforms the causal Substrate graph in response to the active 
||| mass-energy density in the State Vector. 
public export
deformSubstrate : Substrate -> Vexel -> Substrate
deformSubstrate substrate stateVector =
  fromList (deformSubstrateList (multisetToList substrate) (multisetToList stateVector))


||| List-based step of the universe generation.
public export
stepUniverseList : Nat
                 -> Metric
                 -> List ((Geometry, Geometry), Integer)
                 -> List ((Geometry, Amplitude), Integer)
                 -> (List ((Geometry, Geometry), Integer), List ((Geometry, Amplitude), Integer))
stepUniverseList capacityLimit metric subList stateList =
  let evolvedStates = map (\((geom, amp), stateCount) => 
                            let localPropagator = generateLocalSpreadPolyList metric subList geom
                                fusedAmplitude  = scaleMultiset (fromInteger stateCount) (mulIntPoly amp localPropagator)
                            in ((geom, fusedAmplitude), stateCount))
                          stateList
      
      processedItems = concatMap (\((geom, amp), stateCount) =>
                                   let (latentSpace, visibleSpace) = partitionLogic darkEnergyStates geom amp
                                       stabilizedVisible = evaluateResonance capacityLimit (natToInteger (degree ResonanceGate)) geom visibleSpace
                                   in multisetToList (addMultiset latentSpace stabilizedVisible))
                                 evolvedStates
                                  
      nextFieldList = processedItems
      deformedSubList = deformSubstrateList subList evolvedStates
  in (deformedSubList, nextFieldList)


||| Drives a complete generational evolution step where time-propagation is 
||| entirely localized and driven by the restored SpreadPolynumber bridge.
public export
stepUniverseLocalized : Nat
                     -> Metric
                     -> Substrate
                     -> Vexel
                     -> (Substrate, Vexel)
stepUniverseLocalized capacityLimit metric currentSubstrate stateVector =
  let (nextSub, nextField) = stepUniverseList capacityLimit metric (multisetToList currentSubstrate) (multisetToList stateVector)
  in (fromList nextSub, fromList nextField)
