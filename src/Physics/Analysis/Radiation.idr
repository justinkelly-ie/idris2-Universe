module Physics.Analysis.Radiation

import Simplex.Core
import Math.Multiset
import Math.IntPolynumber
import Math.Chromogeometry
import Physics.Particles.Photon
import Physics.System.CosmicPartition

%default total

||| Collective Radiation represents a physical state vector (SparseMaxel)
||| composed entirely of delocalized, null-quadrance excitations in the Red metric.
public export
record Radiation where
  constructor MkRadiation
  stateVector : SparseMaxel

||| Checks if a specific Geometry (Pixel Integer) lies on the Minkowski null diagonal.
public export
isNullCoordinate : Geometry -> Bool
isNullCoordinate p = isPhotonPixel p

||| Dynamically audits if the entire collective state vector consists purely
||| of null-quadrance photons (no massive matter knots or locked charges).
public export
isPureRadiation : Radiation -> Bool
isPureRadiation (MkRadiation m) =
  all (\((g, _), _) => isNullCoordinate g) (multisetToList m)

||| Audits the Boole-Möbius resolution remainder of the ensemble.
||| Pure radiation is a "zero-sum" state in the 2D plane — it yields
||| exactly a zero remainder (no topological leftovers or persistent knots).
public export
isZeroRemainder : Radiation -> Bool
isZeroRemainder (MkRadiation m) =
  -- In pure radiation, every polynomial coefficient must resolve
  -- to a zero-sum across the symmetric lattice.
  -- We model this by verifying that the net multiplicity is balanced.
  let totalAmplitude = foldl (\acc, ((_, amp), mult) => acc + (multiplicityAll amp * mult)) 0 (multisetToList m)
  in totalAmplitude == 0

||| Calculates the total informational energy density (Möbius weight)
||| currently stored in the radiation state.
public export
calculateEnergyDensity : Radiation -> Nat
calculateEnergyDensity (MkRadiation m) =
  cast (multiplicityAll m)

||| Audits the Baryogenesis phase transition threshold.
|||
||| If the informational energy density of the radiation state exceeds the 
||| 128-bit vacuum capacity limit of the spectral pool (2^7), a Pigeonhole
||| Conflict is triggered, forcing the 2D sheet to twist (spillover) into
||| 3D baryonic matter.
public export
checkBaryogenesisTrigger : Radiation -> Bool
checkBaryogenesisTrigger r =
  let density = calculateEnergyDensity r
      limit   = darkEnergyStates -- = 128
  in density > limit

||| Casts a generic SparseMaxel to a Radiation state if it satisfies
||| the pure null-quadrance structural constraint.
public export
validateRadiation : SparseMaxel -> Maybe Radiation
validateRadiation sm =
  let r = MkRadiation sm
  in if isPureRadiation r then Just r else Nothing
