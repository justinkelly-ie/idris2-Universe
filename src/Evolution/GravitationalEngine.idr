module Evolution.GravitationalEngine

import Data.Nat
import Math.ExtendedCosmology
import Math.Chromogeometry
import Math.Pixel
import Evolution.UniverseStream
import Evolution.SpatialEngine
import Simplex.Core

||| Measures the mass magnitude of the nested power layers.
||| One = 1, Nest One = 2, etc.
public export
powerToNat : PositivePower -> Nat
powerToNat One      = 1
powerToNat (Nest x) = 1 + powerToNat x

||| Extracts the magnitude of a mass packet, regardless of charge.
public export
getMass : SignedMatter -> Nat
getMass (Matter p)     = powerToNat p
getMass (Antimatter p) = powerToNat p

||| Computes Wildberger's Quadrance between two pixels.
public export
computeQuadrance : Geometry -> Geometry -> Nat
computeQuadrance p1 p2 =
  let quad = quadranceNL Blue p1 p2
      (MkUr val) = boxToInt quad
      qNat = Prelude.integerToNat val
  in if qNat == 0 then 1 else qNat

||| Calculates the directional pull vector between two bodies based on 
||| Wildberger's Quadrance and matter alignments.
public export
calculateGravity : Geometry -> SignedMatter -> Geometry -> SignedMatter -> (BoxInt, BoxInt)
calculateGravity p1 m1 p2 m2 =
  let (MkPixel x1 y1) = p1
      (MkPixel x2 y2) = p2
      w1 = getMass m1
      w2 = getMass m2
      quad = computeQuadrance p1 p2
      
      -- Clean algebraic force: Force is linear to inverse Quadrance!
      forceMag = fromInteger (natToInteger ((w1 * w2) `div` quad))
      
      -- Base directional signs
      dirX = if x2 > x1 then 1 else if x2 < x1 then -1 else 0
      dirY = if y2 > y1 then 1 else if y2 < y1 then -1 else 0
  in
    -- Polarized Interaction Rules:
    -- Like charges attract, opposite charges repel.
    case (m1, m2) of
      (Matter _, Matter _)         => (dirX * forceMag, dirY * forceMag)
      (Antimatter _, Antimatter _) => (dirX * forceMag, dirY * forceMag)
      _                            => (dirX * (-forceMag), dirY * (-forceMag))

||| Resolves mutual gravitational attraction between two active cells.
||| The resulting collision forces update the background Dark Energy metric.
public export
interactCells : (1 cell1 : Cell) -> (1 cell2 : Cell) -> (Cell, Cell)
interactCells (MkCell loc1 (TimeStep de1 p1 next1)) (MkCell loc2 (TimeStep de2 p2 next2)) =
  let
    -- Compute purely rational pull vector via Wildberger Quadrance
    (vx, vy) = calculateGravity loc1 p1 loc2 p2
    
    -- Feed kinetic energy friction directly into the background spatial expansion
    -- BoxInt abs and (+) handle Dirac cancellation natively
    pushMagnitude = abs vx + abs vy
    (MkUr pushVal) = boxToInt pushMagnitude
    pushScale = Prelude.integerToNat pushVal
    expandedDE1 = tropicalMultiply de1 (Expansion pushScale)
    expandedDE2 = tropicalMultiply de2 (Expansion pushScale)
    
    -- Displace positions using our vector logic
    newLoc1 = MkPixel (loc1.src + vx) (loc1.tgt + vy)
    newLoc2 = MkPixel (loc2.src - vx) (loc2.tgt - vy)
  in
    ( MkCell newLoc1 (TimeStep expandedDE1 p1 next1)
    , MkCell newLoc2 (TimeStep expandedDE2 p2 next2)
    )
