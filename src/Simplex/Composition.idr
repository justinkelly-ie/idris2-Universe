module Simplex.Composition

import public Simplex.Core
import public Simplex.Twist
import public Math.Chromogeometry
import public Math.Multiset
import public Data.List

%default total

-----------------------------------------------------------------------
-- COMPOSITE STATE (Generic Platonic Field Configuration)
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

||| Computes the composite rational spread of the active coordinates in the state.
|||
||| OPTIMIZATION (Three-Fold Quadrea Invariant):
||| Because A_b = -A_r = -A_g, the absolute value of the spread numerator for any triad
||| is identical across all three metrics. Since the degree is evaluated under the
||| absolute value (e.g. in calculateFoldingStructure), we pass Blue unconditionally.
public export
computeStateSpread : Metric -> CompositeState -> (Integer, Integer)
computeStateSpread metric m =
  let coords = map (fst . fst) (multisetToList m)
      _ = metric -- Ignored by the Three-Fold Invariant
      -- Keep only unique coordinates (active nodes)
      uniqueCoords = nub coords
      -- Extract all triads of distinct coordinates (p1, p2, p3)
      triads = [ (p1, p2, p3)
               | p1 <- uniqueCoords
               , p2 <- uniqueCoords
               , p3 <- uniqueCoords
               , p1 /= p2, p2 /= p3, p3 /= p1
               ]
      
      -- Helper function to destructure the triad and compute its spread (Blue unconditionally)
      getSpread : (Pixel Integer, Pixel Integer, Pixel Integer) -> (Integer, Integer)
      getSpread (p1, p2, p3) = spreadNL Blue p1 p2 p3
      
      -- Map triads to exact rational spreads
      spreadFractions = map getSpread triads
  in foldl addRationalLocal (0, 1) spreadFractions
