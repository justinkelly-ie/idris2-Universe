module Symmetry.Quark

import Math.Multiset
import Math.IntPolynumber
import Math.Pixel
import Data.Linear

%default total

||| A single Quark is an n=5 Fractional Charge state.
||| Notice that a single Quark DOES NOT implement the ColorConfined interface!
||| It mathematically cannot, because A(Q)=T(s) requires three distinct Quadrances
||| and three internal Spreads. A solitary quark is geometrically undefined,
||| natively proving why "Asymptotic Freedom" traps them in composite structures.
public export
record Quark where
  constructor MkQuark
  1 state : Multiset (Pixel Integer, IntPolynumber)

||| Linearly duplicates a Quark.
public export total
dupQuark : (1 _ : Quark) -> LPair Quark Quark
dupQuark (MkQuark state) =
  let (s1, s2) = dupMultiset state
  in Builtin.(#) (MkQuark s1) (MkQuark s2)

||| Linearly consumes a Quark.
public export total
consumeQuark : (1 _ : Quark) -> ()
consumeQuark (MkQuark state) = consumeMultiset state

||| Linearly extracts the first active coordinate of a Quark while reconstructing it.
public export total
getQuarkCoord : (1 _ : Quark) -> LPair (Pixel Integer) Quark
getQuarkCoord (MkQuark state) =
  let (lst # state') = multisetToListL state
      coord = case lst of
                [] => MkPixel 0 0
                ((p, _) , _) :: _ => p
  in Builtin.(#) coord (MkQuark state')

