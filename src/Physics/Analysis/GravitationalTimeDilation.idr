module Physics.Analysis.GravitationalTimeDilation

import Simplex.Core
import Physics.Analysis.CosmicEnergyBudget
import Physics.System.CosmicPartition

import Math.SpreadPolynumber
import Math.IntPolynumber
import Math.Multiset
import Simplex.Core
import Physics.Analysis.CosmicEnergyBudget

import Physics.System.CosmicPartition
import Math.Fraction

%default total

||| Gravitational Time Dilation
||| 
||| In standard relativity, time runs slower in stronger gravitational fields.
||| In the LUniverse model, "Time" is merely the computational progression
||| of state resolution. 
|||
||| The S_7 polynomial (Time Dilation Gate) introduces extreme fractional 
||| complexity. As the integer coordinate state passes through S_7, it accumulates 
||| "Leibniz Lag". The more Lag a localized cluster has, the more CPU cycles it 
||| takes the universal background to resolve its position, making its internal 
||| clock tick slower relative to the empty space grid!

public export
interface ExperiencesTimeDilation a where
  ||| Computes the amount of computational lag (Time Dilation) a state suffers.
  ||| Returns the "Z-depth" or computational depth factor.
  calculateLeibnizLag : a -> Fraction

||| Time Dilation for a FibreBundle (SparseMaxel = Multiset (Geometry, Amplitude)).
|||
||| The Leibniz Lag is derived from the total multiplicity (occupancy) of the
||| state vector. Higher occupancy = more internal complexity = slower clock.
public export
ExperiencesTimeDilation SparseMaxel where
  calculateLeibnizLag pip =
    let totalOccupancy = cast {to = Nat} (stateLag pip)
    in MkFraction totalOccupancy primordialGridStates

||| Time Dilation for the complete UniverseState.
|||
||| The Leibniz Lag is the sum of:
|||   - Substrate causal density (how many directed edges in the DAG)
|||   - State vector occupancy (total multiplicity of the SparseMaxel)
|||
||| The substrate density drives the relational clock — denser causal graphs
||| have more edges to traverse per tick, causing the local clock to run slower.
||| This directly implements gravitational time dilation as a geometric effect:
||| massive regions accumulate more causal edges → higher lag → slower time.
public export
ExperiencesTimeDilation UniverseState where
  calculateLeibnizLag state =
    let causalDensity  = substrateLag (substrate state)
        stateOccupancy = cast {to = Nat} (stateLag (stateVector state))
        totalComplexity = causalDensity + stateOccupancy
    in MkFraction totalComplexity primordialGridStates

||| Calculates the Redshift (Z-factor) of emitted light.
||| High Time Dilation pushes the observed wavelength of light beyond the visible 
||| spectrum, hiding it from observers.
|||
||| Works on any type that experiences time dilation.
public export
calculateGravitationalRedshift : ExperiencesTimeDilation a => a -> Fraction
calculateGravitationalRedshift state =
  let lag = calculateLeibnizLag state
  in addFraction (MkFraction 1 1) lag


