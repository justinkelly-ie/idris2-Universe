module Evolution.Transform

import Simplex.Core
import Simplex.Twist
import Evolution.State
import Math.Chromogeometry
import Math.Multiset
import Math.IntPolynumber
import Math.SpreadPolynumber
import Data.List
import Data.Vect
import Decidable.Equality

import Math.ExtendedCosmology
import Math.BoxInt
import Evolution.Clock

%default total

-----------------------------------------------------------------------
-- 1. THE PARTITION GATE (Latent / Visible Split)
--

||| Evaluates if a given monomial term coefficient belongs to the Latent band.
isLatentTerm : BoxInt -> ((Nat, Nat), BoxInt) -> Bool
isLatentTerm latentBarrier (_, coef) = coef >= latentBarrier

||| The fundamental partition gate. 
public export
partitionLogic : Nat 
              -> Geometry
              -> IntPolynumber 
              -> (Vexel, Vexel)
partitionLogic latentBarrier geom rawTerms_mset =
  let latentBarrierBox = fromInteger (natToInteger latentBarrier)
      (latentTerms, visibleTerms) = partition (isLatentTerm latentBarrierBox) (multisetToList rawTerms_mset)
      latentPoly  = fromList latentTerms
      visiblePoly = fromList visibleTerms
      latentSpace  = fromList [( (geom, latentPoly), 1 )]
      visibleSpace = fromList [( (geom, visiblePoly), 1 )]
  in (latentSpace, visibleSpace)

-----------------------------------------------------------------------
-- 2. THE RESONANCE GATE (Modulo Shattering)
--

||| Evaluates polynomial shattering on a single monomial term using a specific modulo base.
shatterTerm : BoxInt -> ((Nat, Nat), BoxInt) -> ((Nat, Nat), BoxInt)
shatterTerm moduloBase (powers, coef) = 
  let (MkUr coefVal) = boxToInt coef
      (MkUr modVal) = boxToInt moduloBase
      residue = coefVal `mod` modVal
  in (powers, fromInteger residue)

||| The Resonance Filter.
public export
evaluateResonance : Nat 
                  -> Integer
                  -> Geometry 
                  -> Vexel 
                  -> Vexel
evaluateResonance capacityLimit moduloBase geom visibleSpace@items_mset =
  let totalLag = multiplicityAll visibleSpace
  in if totalLag > natToInteger capacityLimit
        then 
          let allTerms = concatMap (\((_, polyItems_mset), count) => 
                                      map (\(p, c) => (p, c * fromInteger count)) (multisetToList polyItems_mset)) (multisetToList items_mset)
              moduloBaseBox = fromInteger moduloBase
              shatteredTerms = map (shatterTerm moduloBaseBox) allTerms
              residuePoly    = fromList shatteredTerms
          in fromList [( (geom, residuePoly), 1 )]
        else 
          visibleSpace

-----------------------------------------------------------------------
-- 3. THE ASCENSION GATE (Scale N -> N+1)
--

||| Scalar-only ascension check.
||| Use buildAscensionCapacities for the full three-fold proof.
public export
checkAscension : Nat -> Vexel -> Bool
checkAscension capacityLimit stateSpace =
  let totalLag = multiplicityAll stateSpace
  in totalLag == natToInteger capacityLimit

||| Macro Scale Condensation.
public export
ascendScale : Geometry 
           -> Vexel 
           -> Vexel
ascendScale macroGeom items_mset =
  let macroPoly = foldl (\acc, ((_, poly), count) =>
                          addMultiset acc (scaleMultiset (fromInteger count) poly)
                        ) emptyIntPoly (multisetToList items_mset)
  in fromList [( (macroGeom, macroPoly), 1 )]

-----------------------------------------------------------------------
-- 4. THREE-FOLD ASCENSION PROOF
--

||| Computes the degree (maximum alpha power) of an IntPolynumber.
public export
polyDegree : IntPolynumber -> Nat
polyDegree ZeroM = 0
polyDegree (AddM (alpha, beta) _ rest) = max alpha (polyDegree rest)

||| Extracts the aggregate partition polynomial of a Vexel.
public export
extractVexelPoly : Vexel -> IntPolynumber
extractVexelPoly vex =
  foldl (\acc, ((_, poly), count) =>
          addIntPoly acc (scaleMultiset (fromInteger count) poly)
        ) emptyIntPoly (multisetToList vex)

||| Validates the Goh Factorisation algebraic horizon for the state.
public export
gohFactorisationHorizon : Vexel -> Bool
gohFactorisationHorizon vex =
  let p = extractVexelPoly vex
      n = polyDegree p
  in n > 0 && p == memoSpreadPoly n

||| Validates whether a local space-time region has reached the scale-ascension horizon.
|||
||| Implements the Deterministic Algebraic Scale Promotion: the 137 scalar tally threshold
||| is replaced by the Chromogeometric Horizon (Three-Fold Spread Lock) and/or the Goh Factorisation.
||| Ascension is triggered when either:
|||   1. Chromogeometric: sum_i (1 / s_i) >= 2
|||   2. Goh Factorisation: P(s) = prod_{d|n} Psi_d(s)
public export
canAscend : Metric -> Substrate -> Vexel -> Bool
canAscend _ substrate stateSpace =
  chromogeometricHorizon substrate || gohFactorisationHorizon stateSpace

||| An infinite, coinductive stream representing the unending timeline of the universe.
public export
data TimelineStream : Type where
  (::) : (ClockPhase, List BasisComponent) -> Inf TimelineStream -> TimelineStream

%name TimelineStream stream

||| State tracking record for cosmic energy components during transformations.
public export
record CosmicOutput where
  constructor MkCosmicOutput
  transformedComponents : List BasisComponent
  darkEnergyAccumulator  : List BoxInt
  darkMatterAccumulator  : List BoxInt

||| Processes a single spatial slice of basis components against a specific clock gate.
||| Accumulates metric side-effects like Dark Matter and Dark Energy partitions.
public export
processSlice : ClockPhase 
            -> List BasisComponent 
            -> CosmicOutput
processSlice phase [] = MkCosmicOutput [] [] []
processSlice phase (comp :: comps) =
  let
    -- 1. Transform the individual basis component directly via the S₁₃ phase gate
    (nextComp, outputWeight) = processBasisGate phase comp
    
    -- 2. Recursively process the rest of the spatial slice
    (MkCosmicOutput restComps restDE restDM) = processSlice phase comps
    
    -- 3. Read the magnitude of the output weight to classify its energy metric
    (orient, mag) = decomposeBoxInt outputWeight
    magNat        = powerToNat mag
  in
    -- Sort the output weight based on the exact partition codes emitted by the gate
    case magNat of
         128 => MkCosmicOutput (nextComp :: restComps) (outputWeight :: restDE) restDM
         55  => MkCosmicOutput (nextComp :: restComps) restDE (outputWeight :: restDM)
         27  => MkCosmicOutput (nextComp :: restComps) restDE restDM -- Retained as baryonic matter
         _   => MkCosmicOutput (nextComp :: restComps) restDE restDM -- Standard baseline weights

||| Core coinductive transformation engine.
||| Evaluates the current state slice and projects the timeline infinitely forward.
public export
transformTimeline : ClockPhase 
                 -> List BasisComponent 
                 -> TimelineStream
transformTimeline currentPhase currentComponents =
  let
    -- 1. Step the universal phase gate forward along the 13-ring
    nextPhase = tickPhase currentPhase
    
    -- 2. Run the current slice through the Dirichlet basis translations
    output    = processSlice currentPhase currentComponents
    
    -- 3. Extract the updated state components for the next epoch
    nextComponents = transformedComponents output
  in
    -- Coinductively stream the current state into the infinite timeline
    (currentPhase, currentComponents) :: Delay (transformTimeline nextPhase nextComponents)

||| Helper function to extract a finite historical window from the infinite stream.
public export
takeSteps : Nat -> TimelineStream -> List (ClockPhase, List BasisComponent)
takeSteps Z _ = []
takeSteps (S k) ((phase, comps) :: rest) = (phase, comps) :: takeSteps k rest
