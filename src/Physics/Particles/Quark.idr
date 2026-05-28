module Physics.Particles.Quark

import Evolution.State

import Evolution.State

import Math.Polynumber

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


