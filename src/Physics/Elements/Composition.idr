module Physics.Elements.Composition

import Math.Chromogeometry
import Simplex.Core
import Math.SpreadPolynumber
import Physics.Elements.Element
import Simplex.Twist
import Math.IntPolynumber
import Evolution.State
import Physics.Scales.NaturalFolding
import Data.List
import Evolution.Gate
import Math.Multiset

%default total





-----------------------------------------------------------------------
-- 1. BASE CONSTRUCTORS & TRANSLATION
-----------------------------------------------------------------------

||| Instantiates a Platonic Element as a CompositeState at a specific origin point.
public export
fromElement : Element -> Pixel Integer -> CompositeState
fromElement elem origin = translateState origin (Physics.Elements.Element.Element.stateVector elem)

-----------------------------------------------------------------------
-- 2. THE SPREAD-FOLDING CONNECTION
-----------------------------------------------------------------------

||| Determines the folding structure capacity of the molecule based on its
||| rational spread and substrate length.
public export
calculateFoldingStructure : Metric -> CompositeState -> FoldedStructure
calculateFoldingStructure metric state =
  let (num, den) = computeStateSpread metric state
      -- The active nodes are the unique coordinates in the state multiset
      coords = map (fst . fst) (multisetToList state)
      nodeCount = length (nub coords)
      degree = cast (abs num)
  in calculateNaturalFolds nodeCount degree
