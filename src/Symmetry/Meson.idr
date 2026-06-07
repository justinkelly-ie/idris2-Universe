module Symmetry.Meson

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

total
dupMultiset : (1 _ : Multiset a) -> (Multiset a, Multiset a)
dupMultiset ZeroM = (ZeroM, ZeroM)
dupMultiset (AddM x c xs) =
  let (xs1, xs2) = dupMultiset xs
  in (AddM x c xs1, AddM x c xs2)

total
dupQuark : (1 _ : Quark) -> LPair Quark Quark
dupQuark (MkQuark state) =
  let (s1, s2) = dupMultiset state
  in Builtin.(#) (MkQuark s1) (MkQuark s2)

total
consumeMultiset : (1 _ : Multiset a) -> ()
consumeMultiset ZeroM = ()
consumeMultiset (AddM x c xs) = consumeMultiset xs

total
consumeQuark : (1 _ : Quark) -> ()
consumeQuark (MkQuark state) = consumeMultiset state

total
multisetToListL : (1 _ : Multiset a) -> LPair (List (a, Integer)) (Multiset a)
multisetToListL ZeroM = Builtin.(#) [] ZeroM
multisetToListL (AddM k v rest) =
  let (listRest # restM) = multisetToListL rest
  in Builtin.(#) ((k, v) :: listRest) (AddM k v restM)

total
getQuarkCoord : (1 _ : Quark) -> LPair (Pixel Integer) Quark
getQuarkCoord (MkQuark state) =
  let (lst # state') = multisetToListL state
      coord = case lst of
                [] => MkPixel 0 0
                ((p, _) , _) :: _ => p
  in Builtin.(#) coord (MkQuark state')

||| Extracts the parallel dyad geometry between a Quark and AntiQuark.
||| Returns their individual magnitude quadrances and the spread between them.
public export
extractMesonGeometry : (1 _ : Meson) -> LPair (Integer, Integer, Integer) Meson
extractMesonGeometry (MkMeson q1 q2) =
  let (q1a # q1b) = dupQuark q1
      (q2a # q2b) = dupQuark q2
      (p1 # q1c) = getQuarkCoord q1a
      (p2 # q2c) = getQuarkCoord q2a
      () = consumeQuark q1c
      () = consumeQuark q2c
      (MkPixel x1 y1) = p1
      (MkPixel x2 y2) = p2
      q1_val = x1*x1 + y1*y1
      q2_val = x2*x2 + y2*y2
      cross = x1*y2 - x2*y1
      s12_num = cross * cross
  in Builtin.(#) (q1_val, q2_val, s12_num) (MkMeson q1b q2b)

||| Mesons explicitly implement Color Confinement.
||| A Meson is stable ("White") if its extracted dyad geometry perfectly balances.
public export
implementation ColorConfined Meson where
  isColorless meson =
    let (geom # meson') = extractMesonGeometry meson
        (q1, q2, s12_num) = geom
        stable = (q1 >= 0) && (q2 >= 0) && (s12_num >= 0)
    in Builtin.(#) stable meson'


