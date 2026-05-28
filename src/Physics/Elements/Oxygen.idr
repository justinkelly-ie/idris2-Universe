module Physics.Elements.Oxygen

import Simplex.Core
import Physics.Particles.Electron
import Physics.Elements.Element
import Evolution.Gate

import Simplex.Core
import Physics.Particles.Electron
import Evolution.Gate
import Physics.Elements.Element

import Math.Multiset
import Math.IntPolynumber
import Math.SpreadPolynumber

%default total

||| Oxygen (Z=8) — The Universal Mediator
|||
||| Oxygen occupies a unique structural position in the 128/27 partition:
|||
|||   8 = 2^3            — BackgroundGate cubed
|||   128 / 8 = 16       — Divides dark energy pool exactly
|||   27 mod 8 = 3       — Remainder = MatterGate degree
|||   210 mod 8 = 2 ≠ 0  — Does NOT divide the primorial
|||
||| Oxygen bridges the latent (2^7 = 128) and visible (3^3 = 27) sectors.
||| It partitions dark energy into 16 equal quanta, and its residue in
||| the visible sector IS the MatterGate — the gate that generates structure.
|||
||| This is why Oxygen is the universal electron acceptor driving metabolism:
||| it mediates the transfer from latent energy to visible matter.
|||
||| Valence: Oxygen accepts 2 electrons (valence = BackgroundGate degree).
||| This means it can bond with 2 Hydrogen atoms → H₂O (Water).

||| An Oxygen atom: 8 protons + 8 electrons.
||| The nucleus provides 8 units of baryonic lag.
||| The 8 electrons occupy the n=3 MatterGate orbitals.
public export
record OxygenAtom where
  constructor MkOxygen
  ||| The nucleus: 8 baryonic units (Z=8)
  1 nucleus   : Multiset (Pixel Integer, IntPolynumber)
  ||| The electron cloud: 8 electrons on the MatterGate
  1 electrons : Multiset (Pixel Integer, IntPolynumber)

||| Constructs an Oxygen atom from the pipeline.
public export
oxygen : Pixel Integer -> OxygenAtom
oxygen geom =
  let nucleusState  = elementalState 8 geom
      electronCloud = fromList [((geom, spreadPoly 3), 8)]
  in MkOxygen nucleusState electronCloud

||| The total structural lag of an Oxygen atom.
public export
oxygenLag : Pixel Integer -> Integer
oxygenLag geom =
  let o = oxygen geom
  in multiplicityAll o.nucleus + multiplicityAll o.electrons

||| Oxygen's valence: it needs 2 more electrons to fill its shell.
||| 2 = BackgroundGate degree — this is structural, not coincidental.
public export
oxygenValence : Nat
oxygenValence = degree BackgroundGate

||| The number of dark energy quanta Oxygen can partition.
||| 128 / 8 = 16 — each quantum is one Oxygen-unit of the latent pool.
public export
darkEnergyQuanta : Nat
darkEnergyQuanta = cast (the Integer (div 128 8))


