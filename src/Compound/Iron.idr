module Compound.Iron

import Simplex.Core
import Symmetry.Electron
import Compound.Element
import Evolution.Gate

import Math.Multiset
import Math.IntPolynumber
import Math.SpreadPolynumber

%default total

||| Iron (Z=26) — The Stellar Fusion Limit
|||
||| Iron represents the peak of binding energy per nucleon and is the
||| heaviest element producible via core stellar nucleosynthesis.
|||
||| In the LUniverse, Z=26 is an emergent thermodynamic anchor point
||| on the 137-Scale Trajectory before core gravitational collapse.
public export
record IronAtom where
  constructor MkIron
  ||| The nucleus: 26 baryonic units (Z=26)
  1 nucleus   : Multiset (Pixel Integer, IntPolynumber)
  ||| The electron cloud: 26 electrons on the MatterGate
  1 electrons : Multiset (Pixel Integer, IntPolynumber)

||| Constructs an Iron atom at a given coordinate.
public export
iron : Pixel Integer -> IronAtom
iron geom =
  let nucleusState  = elementalState 26 geom
      electronCloud = fromList [((geom, spreadPoly 3), 26)]
  in MkIron nucleusState electronCloud

||| The total structural lag of an Iron atom.
public export
ironLag : Pixel Integer -> Integer
ironLag geom =
  let fe = iron geom
  in multiplicityAll fe.nucleus + multiplicityAll fe.electrons
