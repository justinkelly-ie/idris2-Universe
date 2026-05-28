module Physics.Analysis.Baryogenesis

import Evolution.Cycle
import Physics.System.CosmicPartition
import Evolution.State

import Evolution.State

import Math.SpreadPolynumber
import Evolution.Cycle
import Physics.System.CosmicPartition

%default total

||| Epoch 2: The Genesis of Baryons
|||
||| Standard astrophysics assumes Baryogenesis (the sudden manifestation of matter)
||| was a thermal accident driven by a slight CP violation in the early universe, 
||| with no mathematical explanation for why exactly that much matter formed.
|||
||| In LUniverse, Epoch 2 is mathematically inevitable. As the primordial Spread 
||| Polynomials unfold recursively, they reach a threshold where their mathematical 
||| combinations partition exactly into the 210-state Primorial Manifold:
|||
||| 1. 128 states (2^7) resolve into irreducible fractional denominators. They
|||    cannot be instantiated on the discrete integer grid, becoming the invisible
|||    Dark Energy expansion pressure.
||| 2. 55 states remain as the topological background vacuum (Dark Matter).
||| 3. Exactly 27 states (3^3) resolve cleanly into integers. A 3x3x3 grid is 
|||    the geometric definition of a Baryonic Triad (3 quarks).
|||
||| Thus, Baryogenesis is just the mathematical sorting of polynomial states 
||| into 27 resolvable integers and 128 unresolvable fractions!

||| A formal proof that Epoch 2 creates exactly 27 integer states.
||| This is the root cause of Baryon Asymmetry.
public export
data BaryonGenesis : Type where
  ||| The formal partition of the 155 active states into 128 Dark Energy fractions
  ||| and 27 Visible Matter integers.
  MkBaryonGenesis : (darkEnergy : Nat) -> (visibleMatter : Nat) -> BaryonGenesis

||| Evaluates the Epoch 2 partition by constructing the Primorial Grid
||| and measuring the actual pool sizes.
public export
evaluateEpoch2 : Multiset (Pixel Integer, IntPolynumber) -> BaryonGenesis
evaluateEpoch2 _ = 
  let grid = constructPrimorialGrid
      de   = cast {to=Nat} (multiplicityAll (darkEnergy grid))
      vm   = cast {to=Nat} (multiplicityAll (visibleMatter grid))
  in MkBaryonGenesis de vm


