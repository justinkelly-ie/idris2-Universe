module Evolution.SpreadPolynumber

import Math.Multiset
import Math.IntPolynumber
import Math.Chromogeometry
import Simplex.Core
import Simplex.Twist
import Evolution.State
import Evolution.Transform
import Evolution.Gate


||| Converts the chromogeometric curvature of a local coordinate point
||| into an Adaptive Cycle spread polynomial operator.
|||
||| Computes the local rational spread twist across substrate triads that
||| touch `currentGeom`, selects the Adaptive Cycle gate whose degree
||| best characterises that local phase, and returns the canonical S_n(s)
||| spread polynomial for that gate as the amplitude propagator.
|||
||| Blue is passed unconditionally to spreadNL: the abs reduction applied
||| to localTwistVal discards the sign of the spread numerator, and the
||| Three-Fold Quadrea Invariant (A_b = -A_r = -A_g) guarantees all three
||| metrics yield identical abs-reduced twist integers.
public export
generateLocalSpreadPoly : Metric
                       -> Substrate
                       -> Pixel Integer -- The local voxel point being evaluated
                       -> IntPolynumber
generateLocalSpreadPoly metric substrate currentGeom =
  let edges = multisetToList substrate
      _ = metric  -- Blue used unconditionally below; metric arg retained for API compatibility

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
                         in (num * mult, den)
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


||| Dynamically deforms the causal Substrate graph in response to the active 
||| mass-energy density in the State Vector. 
|||
||| Spacetime curvature (causal edge density) co-evolves with matter: edges 
||| connecting high-energy coordinates are structurally reinforced (their 
||| multiplicities increase), letting the universe speak for itself.
public export
deformSubstrate : Substrate -> SparseMaxel -> Substrate
deformSubstrate substrate stateVector =
  let edges  = multisetToList substrate
      states = multisetToList stateVector
      
      -- Helper to extract the mass-energy count at a given coordinate
      getEnergy : Pixel Integer -> Integer
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
  in fromList deformedEdges


||| Drives a complete generational evolution step where time-propagation is 
||| entirely localized and driven by the restored SpreadPolynumber bridge.
|||
||| The causal Substrate graph co-evolves dynamically with the active 
||| mass-energy in the state vector (deformSubstrate).
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
                                 
      nextField = fromList processedItems
      
      -- 3. Dynamically co-evolve the Substrate graph with the active field energy
      deformedSub = deformSubstrate currentSubstrate nextField
  in (deformedSub, nextField)
