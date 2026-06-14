module Evolution.Cosmology

import Math.ExtendedCosmology
import Math.BoxInt
import Evolution.Clock
import Evolution.Transform

||| Tracks the current configuration of the global observable horizon.
public export
record HorizonConfig where
  constructor MkHorizon
  horizonLimit : Nat      -- The maximum coordinate volume allowed before inflation
  inflationSteps : Nat    -- Total number of discrete expansion events triggered

||| Accumulates the total absolute coordinate volume across a slice of basis vectors.
public export
sumCoordinateVolume : List BasisComponent -> Nat
sumCoordinateVolume [] = Z
sumCoordinateVolume (comp :: comps) = 
  (coordinate (vector comp)) + sumCoordinateVolume comps

||| The global cosmological loop. 
||| Observes the coinductive stream step-by-step and dynamically scales the 
||| horizon budget without losing numeric precision or leaking continuous values.
public export
cosmologicalLoop : HorizonConfig 
                -> TimelineStream 
                -> Inf TimelineStream
cosmologicalLoop (MkHorizon limit steps) ((phase, comps) :: rest) =
  let
    -- 1. Calculate the real number-theoretic mass-volume of this cosmic step
    currentVolume = sumCoordinateVolume comps
    
    -- 2. Evaluate if the volume breaches the local horizon limits
    nextConfig = if currentVolume > limit
                    then MkHorizon (limit * 2) (S steps) -- Inflate the boundary footprint
                    else MkHorizon limit steps           -- Maintain current geometric state
  in
    -- Coinductively project the current valid slice and recurse down the infinite stream
    (phase, comps) :: Delay (cosmologicalLoop nextConfig rest)

||| Initializes the entire universe with a standard 137 boundary condition.
||| Couples the transformation engine directly into the cosmic horizon loop.
public export
initializeUniverse : List BasisComponent -> TimelineStream
initializeUniverse initialComps =
  let
    -- Start the timeline at the first S₁₃ phase gate (P1)
    rawStream = transformTimeline P1 initialComps
    
    -- Establish the primordial baseline configuration with a 137 threshold limit
    initialHorizon = MkHorizon 137 0
  in
    cosmologicalLoop initialHorizon rawStream
