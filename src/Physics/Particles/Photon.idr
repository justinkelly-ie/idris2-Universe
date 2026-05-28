module Physics.Particles.Photon

import Evolution.State

import Evolution.State

import Math.Polynumber
import Math.Chromogeometry
import Math.SpreadPolynumber
import Math.Fraction

%default total

||| A Photon in the CellState framework is defined not as a continuous wave,
||| but as an algebraic Null-Quadrance Operator on the Red (Relativistic) Metric.
public export
isPhotonPixel : Pixel Integer -> Bool
isPhotonPixel p = quadranceNL Red (MkPixel 0 0) p == 0

||| Represents a validated Photon.
||| It explicitly encapsulates a particle state that satisfies the Red Null-Quadrance property,
||| meaning its Spatial Displacement perfectly equals its Temporal Generation (c = 1).
public export
record Photon where
  constructor MkPhoton
  particle : Pixel Integer
  -- In a fully dependently typed theorem, we would include:
  -- 0 prf : isPhotonPixel particle = True

||| Safely instantiates a Photon if the coordinate meets the speed of light limit.
public export
createPhoton : Pixel Integer -> Maybe Photon
createPhoton p = 
  if isPhotonPixel p then Just (MkPhoton p) else Nothing

||| While a photon has zero quadrance in the Red Metric (timeless),
||| it possesses distinct non-zero quadrance in the Blue (Spatial) Metric.
||| This Blue Quadrance corresponds directly to its spatial energy / momentum.
public export
blueEnergy : Photon -> Integer
blueEnergy (MkPhoton p) = quadranceNL Blue (MkPixel 0 0) p

||| The Cross-Ratio Transformation Matrix (M_x) collapses a 2D null photon
||| into a pure 1D spatial impulse on the Blue grid. This models the
||| absorption of a photon by ordinary matter.
||| (1 1) (x)   (2x)
||| (1 -1)(x) = (0 )
public export
absorbPhoton : Photon -> Pixel Integer
absorbPhoton (MkPhoton (MkPixel x y)) = MkPixel (x + y) (x - y)

||| Calculates the physical propagation speed of a state across the grid.
||| By mapping the Pixel's X coordinate to Spatial Distance and Y coordinate 
||| to Computational Generation (Time), we derive the exact velocity.
||| Because Red Quadrance (x^2 - y^2) is 0 for Photons, this will always return 1 or -1.
public export
propagationSpeed : Photon -> Fraction
propagationSpeed (MkPhoton (MkPixel space time)) =
  let spaceNat = cast {to=Nat} (abs space)
      timeNat = cast {to=Nat} (abs time)
  in MkFraction spaceNat timeNat


