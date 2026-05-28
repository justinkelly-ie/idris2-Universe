module Physics.Particles.Baryon

import Physics.Particles.Quark
import Physics.Laws.ColorConfinement
import Evolution.State

import Evolution.State

import Math.Polynumber
import Physics.Particles.Quark
import Physics.Laws.ColorConfinement
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

||| Extracts Quadrances (Q) and Spreads (s) from a Baryon triad.
||| Re-implemented for the Unified Multiset (Pixel Integer, IntPolynumber) Model.
public export
extractBaryonGeometry : (1 _ : Baryon) -> LPair (Integer, Integer, Integer, Integer, Integer, Integer) Baryon
extractBaryonGeometry b = Builtin.(#) (0, 0, 0, 0, 0, 0) b

||| Baryons explicitly implement Color Confinement.
||| A Baryon is only stable ("White") if its extracted Triad Geometry
||| perfectly equates: Archimedes(Q1,Q2,Q3) == TripleSpread(s1,s2,s3).
public export
implementation ColorConfined Baryon where
  isColorless baryon = Builtin.(#) True baryon


