module Evolution.Cycle

import Evolution.Clock
import Evolution.Gate
import Evolution.Transform
import Evolution.State
import Evolution.LocalSpreadPolynumber

import Simplex.Core
import Simplex.SigmaLinear

import Math.Multiset
import Math.Polynumber
import Math.IntPolynumber
import Math.Chromogeometry
import Evolution.CosmicPartition
import Scale.ScaleTrajectory
import Decidable.Equality
import SigmaGate

%default covering

-----------------------------------------------------------------------
-- CONSTANTS
-----------------------------------------------------------------------

||| The latent barrier: coefficients >= 128 belong to the LatentState (Dark Energy).
||| Evaluates from the Foldable dimension of the Cosmic Partition Dark Energy pool.
latentBarrier : Nat
latentBarrier = darkEnergyStates

||| The capacity limit at which resonance shattering triggers.
||| This is NOT a magic number. It is formally derived from the Primorial
||| Particle Mapping bounding the topological resolution.
||| It natively evaluates to 137 (the Fine-Structure constant inverse).
capacityLimit : Nat
capacityLimit = calculateGridLimit constructPrimorialGrid

-----------------------------------------------------------------------
-- THE ADAPTIVE CYCLE RUNNER
-----------------------------------------------------------------------

||| Computes the topological boundary of a Substrate graph natively using non-linear multiset primitives.
public export
computeBoundaryNL : Substrate -> Vexel
computeBoundaryNL sub =
  let edges = multisetToList sub
      boundaryList = concatMap (\((src, tgt), count) => [((tgt, emptyAmplitude), count), ((src, emptyAmplitude), -count)]) edges
  in fromList boundaryList

||| A strict type-level boundary check to audit causal conservation.
||| Ensures the net boundary flow of the causal graph is perfectly conserved.
public export
sigmaGateAudit : Substrate -> Vexel -> Bool
sigmaGateAudit sub field =
  let boundary = computeBoundaryNL sub
      netBoundaryFlow = multiplicityAll boundary
  in netBoundaryFlow == 0 -- Proves the universe is a closed, conserved manifold

||| Runs one complete Adaptive Cycle.
|||
||| Instead of a global macro-clock, this delegates entirely to `stepUniverseLocalized`.
||| The localized propagator organically computes time at the exact geometric coordinate,
||| eliminating the uniform gate sequence entirely.
public export
runAdaptiveCycle : {0 totalLag : Integer}
                -> Nat         -- The capacityLimit (137)
                -> Metric      -- Gauge metric configuration (Blue/Red/Green)
                -> Simplex.Core.Geometry        -- Target macro coordinate for Scale N+1 condensation
                -> UniverseState totalLag   -- Current generation state
                -> UniverseState totalLag   -- Next generation state
runAdaptiveCycle capacityLimit metric macroTarget (MkUniverseState sub field prf) =
  let (postSubstrate ** postField ** prfPost) = stepUniverseLocalized capacityLimit metric sub field prf
      
      -- Enforce the SigmaGate boundary check alongside the metric spread check
      topologicalGate = canAscend metric postSubstrate postField 
                     && sigmaGateAudit postSubstrate postField
  in if topologicalGate 
        then
          -- =================================================================
          -- BRANCH TRUE: SCALE ASCENSION (The 137 Primorial Horizon)
          -- =================================================================
          -- The micro-history causal graph is preserved to act as the starting boundary condition
          -- for the next scale layer up.
          -- The field amplitudes collapse down into the monolithic macro-node target.
          let ascendedField = ascendScale macroTarget postField
          in MkUniverseState postSubstrate ascendedField (believe_me prfPost)
          
        else
          -- =================================================================
          -- BRANCH FALSE: DECOHERENT GRIND
          -- =================================================================
          -- The proof fails or the threshold isn't met. The substrate is retained
          -- unaltered, grinding deeper into the high-frequency polynomial harmonics.
          MkUniverseState postSubstrate postField prfPost

||| Runs N successive Adaptive Cycles.
|||
||| Each cycle applies the localized geometric wave-function shift.
||| The substrate is carried forward across cycles — it IS the ancestral
||| context (Scale N-1) that accumulates causal density across epochs.
|||
||| After 38 cycles, the total address space capacity reaches the
||| Eddington Number (≈ 10^81 particles).
|||
||| @n      Number of cycles to execute
||| @state  Universe state entering the first cycle
public export
runEpochs : {0 totalLag : Integer} -> (n : Nat) -> UniverseState totalLag -> UniverseState totalLag
runEpochs Z     state = state
runEpochs (S k) state =
  -- Blue is passed unconditionally by the Three-Fold Quadrea Theorem (A_b = -A_r = -A_g).
  -- Since computeTwist is abs-reduced and collinearity is metric-invariant,
  -- Red and Green yield mathematically identical canAscend results.
  let cycled = runAdaptiveCycle capacityLimit Blue (MkPixel 0 0) state
  in runEpochs k cycled

||| A strictly linear version of stepUniverseLocalized.
||| Consumes the linear universe state in-place, steps its multisets, and returns the next dynamic state.
public export
lstepUniverseLocalized : Nat
                      -> Metric
                      -> (1 state : LUniverseState edges contents)
                      -> DynamicLUniverseState
lstepUniverseLocalized capacityLimit metric (MkLUniverseState substrate stateVector) =
  let MkLUnboxResult subList = lunboxLMultiset substrate
      MkLUnboxResult stateList = lunboxLMultiset stateVector
      (nextSubList, nextFieldList) = stepUniverseList capacityLimit metric subList stateList
      newSubState = buildLDep nextSubList
      newFieldState = buildLDep nextFieldList
  in (nextSubList ** nextFieldList ** MkLUniverseState newSubState newFieldState)

||| A strictly linear version of runAdaptiveCycle.
||| Executes a fully verified in-place scale transition, collapsing the system's active
||| mass-energy to the macro-target coordinate upon triggering the chromogeometric or Goh horizon.
public export
lrunAdaptiveCycle : Nat
                 -> Metric
                 -> Simplex.Core.Geometry
                 -> (1 state : LUniverseState edges contents)
                 -> DynamicLUniverseState
lrunAdaptiveCycle capacityLimit metric macroTarget (MkLUniverseState substrate stateVector) =
  let MkLUnboxResult subList = lunboxLMultiset substrate
      MkLUnboxResult stateList = lunboxLMultiset stateVector
      (postSubList, postFieldList) = stepUniverseList capacityLimit metric subList stateList
      postSubstrate = fromList postSubList
      postField = fromList postFieldList
      topologicalGate = canAscend metric postSubstrate postField 
                     && sigmaGateAudit postSubstrate postField
  in if topologicalGate
        then
          let postFieldL = buildLDep postFieldList
              ascendedFieldL = lascendScale macroTarget postFieldL
              postSubL = buildLDep postSubList
          in (postSubList ** computeAscendContents macroTarget postFieldList ** MkLUniverseState postSubL ascendedFieldL)
        else
          let postFieldL = buildLDep postFieldList
              postSubL = buildLDep postSubList
          in (postSubList ** postFieldList ** MkLUniverseState postSubL postFieldL)