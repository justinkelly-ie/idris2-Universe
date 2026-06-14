module Derivation.DarkEnergyExpansion

import Simplex.Core
import Derivation.CosmicEnergyBudget
import System.CosmicPartition

import Math.Chromogeometry
import Math.Multiset
import Simplex.Core
import Derivation.CosmicEnergyBudget

import System.CosmicPartition
import Math.Fraction

%default total

||| Cosmic Expansion & Dark Energy
|||
||| In standard astrophysics, the accelerating expansion of the universe is 
||| attributed to a mysterious force called "Dark Energy" (comprising ~68%).
|||
||| In the deterministic Primorial architecture, Dark Energy corresponds to the
||| exactly 128 states of the unresolvable fractional space (which is 61% of the
||| 210-state pool).
|||
||| 1. Shared Algebra: The 128 Dark Energy states and the 27 Visible Matter states
||| are both bound by the EXACT same underlying universal lock: $A(Q) = T(s)$.
|||
||| 2. Expansive Pressure: Because the 128 Dark Energy states possess highly
||| nested fractional spreads (from $S_5, S_7, S_{11}$) that cannot resolve to
||| integer coordinates on the visible Blue Metric grid, their internal angular 
||| tension ($T$) has nowhere to "ground". 
|||
||| 3. Cosmic Acceleration: This unresolvable mathematical tension exerts a 
||| continuous expansive outward pressure against the 27 visible states. The 
||| universe is not expanding because space is stretching; it is being pushed 
||| apart by the raw combinatorial overflow of the 128 fractional states trying 
||| to violently satisfy the $A(Q)=T(s)$ structural lock!

public export
interface ExertsExpansivePressure a where
  ||| Computes the expansive outward tension applied to the visible grid.
  ||| The more complex the fractional denominators in the state space, 
  ||| the higher the expansive coefficient.
  calculateExpansivePressure : a -> Spread

||| Expansive pressure for a Vexel (FibreBundle).
||| The pressure is proportional to the state vector occupancy scaled by the
||| primorial grid limit — more polynomial terms = more fractional overflow
||| = more expansion.
public export
ExertsExpansivePressure Vexel where
  calculateExpansivePressure pip =
    let occupancy = Prelude.integerToNat (stateLag pip)
    in MkSpread (MkFraction (occupancy * darkEnergyStates) (primordialGridStates * primordialGridStates))

||| Expansive pressure for a full UniverseState.
public export
ExertsExpansivePressure UniverseState where
  calculateExpansivePressure state =
    let occupancy   = Prelude.integerToNat (stateLag (stateVector state))
        causalDepth = substrateLag (substrate state)
    in MkSpread (MkFraction ((occupancy + causalDepth) * darkEnergyStates) (primordialGridStates * primordialGridStates))

||| Maps a spatial dilation function over the Geometry coordinates of a Vexel.
||| Operates directly on BoxInt — Dirac cancellation handles Pos/Neg annihilation
||| natively without projecting to Integer.
public export
dilateSpace : (BoxInt -> BoxInt) -> Vexel -> Vexel
dilateSpace f pip =
  fromList (map (\((MkPixel s t, amp), count) =>
                    ((MkPixel (f s) (f t), amp), count)) (multisetToList pip))

||| Applies the physical outward pressure to the underlying FibreBundle,
||| physically moving the coordinates apart (simulating Cosmic Expansion).
public export
applyDarkEnergyExpansion : Vexel -> Spread -> Vexel
applyDarkEnergyExpansion pip pressure =
  let scale = fractionDivNat pressure.value.numerator (pressure.value.denominator * primordialGridStates) + 1
      scaleFactor : BoxInt = fromInteger (natToInteger scale)
  in dilateSpace (\x => x * scaleFactor) pip


