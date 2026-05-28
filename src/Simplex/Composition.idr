module Simplex.Composition

import public Simplex.Core
import public Simplex.Twist
import public Math.Chromogeometry
import public Math.Multiset
import public Data.List

%default total

-----------------------------------------------------------------------
-- COMPOSITE STATE (Generic Platonic Field Topology)
-----------------------------------------------------------------------

||| A CompositeState represents a pure, stateless mathematical field topology —
||| a spatial state vector (0-Cochain) mapping coordinates to amplitudes.
public export
0 CompositeState : Type
CompositeState = SparseMaxel

||| Translates a CompositeState's coordinates by a displacement vector.
public export
translateState : Pixel Integer -> CompositeState -> CompositeState
translateState (MkPixel dx dy) m =
  let stateItems = multisetToList m
      translatedState = map (\((MkPixel x y, amp), count) => 
                              ((MkPixel (x + dx) (y + dy), amp), count)
                            ) stateItems
  in fromList translatedState

||| Computes the composite rational spread of the active coordinates in the state,
||| which directly determines the structural folding locks at higher scales.
public export
computeStateSpread : Metric -> CompositeState -> (Integer, Integer)
computeStateSpread metric m =
  let coords = map (fst . fst) (multisetToList m)
      -- Keep only unique coordinates (active nodes)
      uniqueCoords = nub coords
      -- Extract all triads of distinct coordinates (p1, p2, p3)
      triads = [ (p1, p2, p3)
               | p1 <- uniqueCoords
               , p2 <- uniqueCoords
               , p3 <- uniqueCoords
               , p1 /= p2, p2 /= p3, p3 /= p1
               ]
      
      -- Helper function to destructure the triad and compute its spread
      getSpread : (Pixel Integer, Pixel Integer, Pixel Integer) -> (Integer, Integer)
      getSpread (p1, p2, p3) = spreadNL metric p1 p2 p3
      
      -- Map triads to exact rational spreads
      spreadFractions = map getSpread triads
  in foldl addRationalLocal (0, 1) spreadFractions
