module Physics.Elements.Hydrogen

import Physics.Elements.Element
import Simplex.Core
import Physics.Particles.Electron

import Simplex.Core
import Physics.Particles.Electron
import Physics.Elements.Element

import Math.Multiset
import Math.IntPolynumber
import Math.SpreadPolynumber

%default total

||| Hydrogen (Z=1) — The Simplest Atom
|||
||| Hydrogen is the first stable element on the 137-Grid. It consists of
||| a single proton (1 unit of baryonic lag) bound to a single electron
||| (the simplest non-fractional topological knot on the n=3 MatterGate).
|||
||| Structural properties:
|||   - Z=1: the unit baryon — the multiplicative identity of the elemental scale
|||   - S_1 lag = 1: the minimal spread polynomial
|||   - 1 divides everything: Hydrogen is universally compatible
|||   - The proton-electron bond is the simplest possible BondGate (n=4) pairing

||| A Hydrogen atom: one proton + one electron, linearly held.
||| The proton provides baryonic lag, the electron provides the visible
||| geometry via the n=3 MatterGate.
public export
record HydrogenAtom where
  constructor MkHydrogen
  ||| The proton: unit baryonic state (Z=1)
  1 proton   : Multiset (Pixel Integer, IntPolynumber)
  ||| The electron: simplest stable knot on the MatterGate
  1 electron : Multiset (Pixel Integer, IntPolynumber)

||| Constructs a Hydrogen atom from the pipeline.
||| The proton is Z=1 elemental state, the electron is S_3 (MatterGate).
public export
hydrogen : Pixel Integer -> HydrogenAtom
hydrogen geom =
  let protonState   = elementalState 1 geom
      electronState = fromList [((geom, spreadPoly 3), 1)]
  in MkHydrogen protonState electronState

||| The total structural lag of a Hydrogen atom.
||| Proton lag (1) + electron lag (S_3 multiplicity).
public export
hydrogenLag : Pixel Integer -> Integer
hydrogenLag geom =
  let h = hydrogen geom
  in multiplicityAll h.proton + multiplicityAll h.electron


