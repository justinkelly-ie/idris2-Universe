module Compound.Feynmanium

import Simplex.Core
import Symmetry.Electron
import Compound.Element
import Evolution.Gate

import Math.Multiset
import Math.IntPolynumber
import Math.SpreadPolynumber

%default total

||| Feynmanium (Z=137) — The Absolute Stability Limit
|||
||| Feynmanium represents the absolute boundary of stable element structures
||| on the 137-Grid. Beyond Z=137, the n=13 resonance gate breaks coordinates
||| down into decoherent states, leading to immediate radioactive decay.
public export
record FeynmaniumAtom where
  constructor MkFeynmanium
  ||| The nucleus: 137 baryonic units (Z=137)
  1 nucleus   : Multiset (Pixel Integer, IntPolynumber)
  ||| The electron cloud: 137 electrons on the MatterGate
  1 electrons : Multiset (Pixel Integer, IntPolynumber)

||| Constructs a Feynmanium atom at a given coordinate.
public export
feynmanium : Pixel Integer -> FeynmaniumAtom
feynmanium geom =
  let nucleusState  = elementalState 137 geom
      electronCloud = fromList [((geom, spreadPoly 3), 137)]
  in MkFeynmanium nucleusState electronCloud

||| The total structural lag of a Feynmanium atom.
public export
feynmaniumLag : Pixel Integer -> Integer
feynmaniumLag geom =
  let fy = feynmanium geom
  in multiplicityAll fy.nucleus + multiplicityAll fy.electrons
