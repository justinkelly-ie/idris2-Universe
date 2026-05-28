module Physics.Analysis.DarkMatterFriction

import Simplex.Core
import Physics.Analysis.CosmicEnergyBudget
import Physics.System.CosmicPartition

import Simplex.Core
import Math.Chromogeometry
import Physics.Analysis.CosmicEnergyBudget

import Physics.System.CosmicPartition
import Math.Fraction

%default total

||| The Tully-Fisher Relation & Dark Matter Gravitational Drag
|||
||| In standard astrophysics, the rotational velocity of galaxies implies the
||| presence of significantly more mass than is visibly observable. This invisible
||| mass is termed "Dark Matter" (comprising ~27% of the universe).
|||
||| In the LUniverse model, Dark Matter corresponds to the
||| exactly 55 states of the Maxwell Background Vacuum (which is 26.2% of the
||| 210-state pool).
|||
||| Gravitational Drag: As the 27 visible states (galaxies/stars) move, they
||| must propagate across the discrete 55-state Maxel grid. This grid is not
||| empty; it is a rigid lattice of mathematical tension. Moving through it
||| induces geometric "friction" or drag. This drag mathematically limits the
||| angular momentum of the visible cluster and explains why spiral galaxies
||| do not tear themselves apart.
|||
||| Gravity on a galactic scale is not a pulling force; it is the physical
||| drag of attempting to displace the rigid 55-state vacuum grid!

public export
interface ExertsGravitationalDrag a where
  ||| Computes the inertial resistance applied by the Dark Matter grid tension.
  calculateTensionDrag : a -> Spread

||| A Dark Matter Background modeled as a Substrate (causal graph density).
|||
||| The grid density is derived from the substrate's causal edge count —
||| more edges = denser vacuum scaffold = more gravitational drag.
public export
record DarkMatterGrid where
  constructor MkDarkMatterGrid
  ||| The substrate topology encoding the 55-state vacuum scaffold
  scaffold    : Substrate
  ||| The physical density derived from causal edge count
  gridDensity : Spread

||| Dark Matter structurally anchors the visible universe.
||| The drag is proportional to the scaffold density scaled by the primorial grid.
public export
ExertsGravitationalDrag DarkMatterGrid where
  calculateTensionDrag grid = 
    MkSpread (scaleFraction primordialGridStates grid.gridDensity.value)

||| Direct drag calculation from a Substrate.
||| The causal density of the directed graph IS the gravitational drag.
public export
ExertsGravitationalDrag Substrate where
  calculateTensionDrag sub =
    let density = substrateLag sub
    in MkSpread (MkFraction (density * darkMatterStates) (primordialGridStates * primordialGridStates))


