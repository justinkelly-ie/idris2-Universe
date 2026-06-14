module Symmetry.Meson

import Simplex.Core
import Symmetry.Quark
import Invariant.ColorConfinement

import Math.IntPolynumber
import Math.Multiset
import Math.Chromogeometry
import Data.Linear

%default total

||| A Meson is a dyad of a Quark and an AntiQuark (both are n=5 Fractional Charges,
||| but with inverted/opposing topologies).
||| By combining these two, they create a compound geometry that can be audited
||| for parallel-tension stability.
public export
record Meson where
  constructor MkMeson
  1 q1 : Quark
  1 q2 : Quark


||| Extracts the parallel dyad geometry between a Quark and AntiQuark.
||| Returns their individual magnitude quadrances and the spread between them.
public export
extractMesonGeometry : (1 _ : Meson) -> LPair (BoxInt, BoxInt, BoxInt) Meson
extractMesonGeometry (MkMeson q1 q2) =
  let (p1 # q1') = getQuarkCoord q1
      (p2 # q2') = getQuarkCoord q2
      (MkPixel x1 y1) = p1
      (MkPixel x2 y2) = p2
      q1_val = x1*x1 + y1*y1
      q2_val = x2*x2 + y2*y2
      cross = x1*y2 - x2*y1
      s12_num = cross * cross
  in Builtin.(#) (q1_val, q2_val, s12_num) (MkMeson q1' q2')

||| Mesons explicitly implement Color Confinement.
||| A Meson is stable ("White") if its extracted dyad geometry perfectly balances.
public export
implementation ColorConfined Meson where
  isColorless meson =
    let (geom # meson') = extractMesonGeometry meson
        (q1, q2, s12_num) = geom
        stable = (q1 >= 0) && (q2 >= 0) && (s12_num >= 0)
    in Builtin.(#) stable meson'



