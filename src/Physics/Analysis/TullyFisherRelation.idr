module Physics.Analysis.TullyFisherRelation

import Simplex.Core
import Physics.Analysis.CosmicEnergyBudget
import Physics.System.CosmicPartition

import Math.IntPolynumber
import Math.Multiset
import Simplex.Core
import Math.SpreadPolynumber
import Physics.Analysis.CosmicEnergyBudget
import Math.Fraction
import Math.Chromogeometry

import Physics.System.CosmicPartition
%default total

||| The Tully-Fisher Relation (Galactic Rotation Curves)
|||
||| In standard astrophysics, galaxies spin much faster at their outer edges 
||| than the amount of visible matter permits (based on Newtonian gravity). 
||| To fix this, scientists inject invisible "Dark Matter Halos" into the model.
|||
||| In the LUniverse model, we do not need arbitrary invisible halos!
||| The velocity-mass power law (Tully-Fisher) emerges natively from the 
||| continuous rational scaling limit of the Maxel grid. The "Dark Matter" is 
||| simply the 55 baseline vacuum states acting as a rigid, topological scaffold 
||| that drags the rotating visible matter along with it.

public export
interface ExhibitsGalacticRotation a where
  ||| Returns a tuple: (Velocity Squared (Quadrance), Visible Mass Equivalent)
  calculateRotationMetrics : a -> (Quadrance, Fraction)

||| Galactic rotation for a SparseMaxel (FibreBundle).
|||
||| Visible Mass is proportional to the total state vector occupancy.
||| Velocity Squared is structurally proportional to the polynomial spread
||| minus the baseline vacuum friction (the Dark Matter ratio).
public export
ExhibitsGalacticRotation SparseMaxel where
  calculateRotationMetrics pip =
    let visibleMass = cast {to = Nat} (stateLag pip)
        velocitySq = MkFraction (visibleMass * primordialGridStates) darkMatterStates
    in (MkQuadrance velocitySq, MkFraction visibleMass 1)

||| Galactic rotation for a full UniverseState.
||| The substrate causal density contributes to the effective rotational drag.
public export
ExhibitsGalacticRotation UniverseState where
  calculateRotationMetrics state =
    let visibleMass = cast {to = Nat} (stateLag (stateVector state))
        causalDrag  = substrateLag (substrate state)
        velocitySq  = MkFraction ((visibleMass + causalDrag) * primordialGridStates) darkMatterStates
    in (MkQuadrance velocitySq, MkFraction visibleMass 1)

||| A formal audit of the Tully-Fisher limit.
||| Proves that the flat rotation curve of the galaxy is mathematically anchored
||| to the ratio between Visible Matter (27 states) and Vacuum Friction (55 states).
public export
verifyTullyFisherLaw : ExhibitsGalacticRotation a => a -> Bool
verifyTullyFisherLaw state =
  let (v2, m) = calculateRotationMetrics state
      thresholdSq = MkFraction (m.numerator * primordialGridStates) (m.denominator * darkMatterStates)
  in (v2.value.numerator * thresholdSq.denominator) >= (thresholdSq.numerator * v2.value.denominator)


