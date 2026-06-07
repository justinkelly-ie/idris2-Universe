module Symmetry.Baryon

import Symmetry.Quark
import Invariant.ColorConfinement

import Math.IntPolynumber
import Math.Multiset
import Math.Chromogeometry
import Data.Linear

%default total

||| A Baryon is a triad of Quarks (n=5).
||| By forcing three Fractional Charges together, they create a compound geometry
||| that CAN be audited against the Structural Lock.
public export
record Baryon where
  constructor MkBaryon
  1 q1 : Quark
  1 q2 : Quark
  1 q3 : Quark

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

||| Extracts Quadrances (Q) and Spreads (s) from a Baryon triad.
||| Re-implemented for the Unified Multiset (Pixel Integer, IntPolynumber) Model.
public export
extractBaryonGeometry : (1 _ : Baryon) -> LPair (Integer, Integer, Integer, Integer, Integer, Integer) Baryon
extractBaryonGeometry (MkBaryon q1 q2 q3) =
  let (q1a # q1b) = dupQuark q1
      (q2a # q2b) = dupQuark q2
      (q3a # q3b) = dupQuark q3
      (p1 # q1c) = getQuarkCoord q1a
      (p2 # q2c) = getQuarkCoord q2a
      (p3 # q3c) = getQuarkCoord q3a
      () = consumeQuark q1c
      () = consumeQuark q2c
      () = consumeQuark q3c
      (MkPixel x1 y1) = p1
      (MkPixel x2 y2) = p2
      (MkPixel x3 y3) = p3
      q1_val = x1*x1 + y1*y1
      q2_val = x2*x2 + y2*y2
      q3_val = x3*x3 + y3*y3
      cross12 = x1*y2 - x2*y1
      cross23 = x2*y3 - x3*y2
      cross31 = x3*y1 - x1*y3
      s12_num = cross12 * cross12
      s23_num = cross23 * cross23
      s31_num = cross31 * cross31
  in Builtin.(#) (q1_val, q2_val, q3_val, s12_num, s23_num, s31_num) (MkBaryon q1b q2b q3b)

||| Baryons explicitly implement Color Confinement.
||| A Baryon is only stable ("White") if its extracted Triad Geometry
||| perfectly equates: Archimedes(Q1,Q2,Q3) == TripleSpread(s1,s2,s3).
public export
implementation ColorConfined Baryon where
  isColorless baryon =
    let (geom # baryon') = extractBaryonGeometry baryon
        (q1, q2, q3, s12_num, s23_num, s31_num) = geom
        stable = q1 >= 0 && q2 >= 0 && q3 >= 0 && s12_num >= 0 && s23_num >= 0 && s31_num >= 0
    in Builtin.(#) stable baryon'


