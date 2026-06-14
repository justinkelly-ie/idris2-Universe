module Evolution.SpatialEngine

import Math.ExtendedCosmology
import Math.Chromogeometry
import Math.Pixel
import Evolution.UniverseStream
import Simplex.Core

public export
record Cell where -- To Do use a Multiset
  constructor MkCell
  loc    : Geometry
  stream : UniverseStream

public export
SpatialMatrix : Type
SpatialMatrix = List Cell -- to Do use a mutliset instead of a Cell

||| Updates a coordinate based on a velocity vector scaled by Dark Energy.
public export
shiftCoord : Geometry -> (BoxInt, BoxInt) -> DarkEnergyMetric -> Geometry
shiftCoord (MkPixel x y) (vx, vy) (Expansion scale) =
  -- The higher the Dark Energy expansion scale, the further the matter is pushed!
  let factor = fromInteger (natToInteger scale)
  in MkPixel (x + (vx * factor)) (y + (vy * factor))  -- To Do: use scale directly instead of factor

||| Linearly steps the entire matrix forward in time, routing matter fields 
||| across space based on their localized Dark Energy metric.
public export
stepMatrix : (1 matrix : SpatialMatrix) -> (BoxInt, BoxInt) -> SpatialMatrix
stepMatrix [] _ = []
stepMatrix (MkCell loc (TimeStep de particles next) :: ts) vector =
  let newLoc = shiftCoord loc vector de
      updatedCell = MkCell newLoc next
  in updatedCell :: stepMatrix ts vector
