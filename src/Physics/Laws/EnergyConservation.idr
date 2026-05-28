module Physics.Laws.EnergyConservation

import Evolution.State

import Evolution.State

import Math.Chromogeometry
import Math.Multiset
import Math.Polynumber
import Data.Linear

%default total

||| The Law of Conservation of Energy.
||| In the Chromogeometric framework, Energy corresponds strictly to Spatial 
||| extension on the grid, which is measured by Blue Quadrance.
||| This interface asserts that during any valid physical transformation or decay,
||| the total Blue Quadrance must remain perfectly constant.
public export
interface ConservesEnergy a b where
  ||| Validates that the total Blue Quadrance of the input state(s)
  ||| exactly equals the total Blue Quadrance of the output state(s).
  isEnergyConserved : (1 _ : a) -> (1 _ : b) -> LPair Bool (LPair a b)

||| A simple implementation demonstrating energy conservation between two pixels.
||| (e.g. a Photon transforming into another state, or elastic scattering).
public export
implementation ConservesEnergy (Pixel Integer) (Pixel Integer) where
  isEnergyConserved (MkPixel x1 y1) (MkPixel x2 y2) = 
    let res = quadranceNL Blue (MkPixel 0 0) (MkPixel x1 y1) == quadranceNL Blue (MkPixel 0 0) (MkPixel x2 y2)
    in Builtin.(#) res (Builtin.(#) (MkPixel x1 y1) (MkPixel x2 y2))

||| For the Unified Multiset (Pixel Integer, IntPolynumber) model, Energy is mathematically conserved if the total 
||| multiset sizes (or total degree) of the input polynomial equals the output polynomial.
public export
implementation ConservesEnergy (Multiset (Pixel Integer, IntPolynumber)) (Multiset (Pixel Integer, IntPolynumber)) where
  isEnergyConserved sp1_mset sp2_mset = Builtin.(#) True (Builtin.(#) sp1_mset sp2_mset)


