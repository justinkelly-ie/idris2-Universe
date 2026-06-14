module Invariant.EnergyConservation

import Simplex.Core
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
implementation ConservesEnergy (Pixel BoxInt) (Pixel BoxInt) where
  isEnergyConserved (MkPixel x1 y1) (MkPixel x2 y2) = 
    let res = quadranceNL Blue (MkPixel 0 0) (MkPixel x1 y1) == quadranceNL Blue (MkPixel 0 0) (MkPixel x2 y2)
    in Builtin.(#) res (Builtin.(#) (MkPixel x1 y1) (MkPixel x2 y2))

total
multiplicityAllL : (1 _ : Multiset Integer a) -> (Integer, Multiset Integer a)
multiplicityAllL ZeroM = (0, ZeroM)
multiplicityAllL (AddM x c xs) =
  let (restVal, restM) = multiplicityAllL xs
  in (abs c + restVal, AddM x c restM)

||| For the Unified Multiset (Pixel BoxInt, IntPolynumber) model (Vexel), Energy is mathematically conserved if the total 
||| multiset sizes (or total degree) of the input polynomial equals the output polynomial.
public export
implementation ConservesEnergy Vexel Vexel where
  isEnergyConserved sp1_mset sp2_mset =
    let (v1, m1) = multiplicityAllL sp1_mset
        (v2, m2) = multiplicityAllL sp2_mset
        res = v1 == v2
    in Builtin.(#) res (Builtin.(#) m1 m2)



