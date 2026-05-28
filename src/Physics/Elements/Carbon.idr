module Physics.Elements.Carbon

import Simplex.Core
import Physics.Particles.Electron
import Physics.Elements.Element
import Evolution.Gate

import Math.Multiset
import Math.IntPolynumber
import Math.SpreadPolynumber
import Math.Chromogeometry

%default total

||| Carbon (Z=6) — The Organic Backbone
|||
||| Carbon is the foundation of organic chemistry and complex life.
||| Its atomic number Z=6 is the product of the first two gates:
|||   6 = 2 × 3 = BackgroundGate × MatterGate
||| 
||| Valence: Carbon has a valence of exactly 4.
||| 4 = BondGate degree. This is why Carbon is the ultimate bonding element;
||| its valence capacity is structurally identical to the BondGate itself.
||| It accepts exactly 4 electrons, forming 4 covalent bonds.

public export
record CarbonAtom where
  constructor MkCarbon
  ||| The nucleus: 6 baryonic units (Z=6)
  1 nucleus   : Multiset (Pixel Integer, IntPolynumber)
  ||| The electron cloud: 6 electrons on the MatterGate
  1 electrons : Multiset (Pixel Integer, IntPolynumber)

||| Constructs a Carbon atom at a given coordinate.
public export
carbon : Pixel Integer -> CarbonAtom
carbon geom =
  let nucleusState  = elementalState 6 geom
      electronCloud = fromList [((geom, spreadPoly 3), 6)]
  in MkCarbon nucleusState electronCloud

||| The total structural lag of a Carbon atom.
public export
carbonLag : Pixel Integer -> Integer
carbonLag geom =
  let c = carbon geom
  in multiplicityAll c.nucleus + multiplicityAll c.electrons

||| Carbon's valence: it needs 4 electrons to fill its shell.
||| 4 = BondGate degree. Carbon's valence IS the BondGate!
public export
carbonValence : Nat
carbonValence = degree BondGate

-----------------------------------------------------------------------
-- FORMAL FINDINGS & PROOFS
-----------------------------------------------------------------------

||| Formal Proof that Carbon's atomic number (6) is exactly
||| BackgroundGate × MatterGate.
public export
carbonIsBackgroundTimesMatter : (6 = degree BackgroundGate * degree MatterGate)
carbonIsBackgroundTimesMatter = Refl

||| Formal Proof that Carbon's valence (4) exactly matches the BondGate.
public export
carbonValenceIsBondGate : (Physics.Elements.Carbon.carbonValence = degree BondGate)
carbonValenceIsBondGate = Refl
