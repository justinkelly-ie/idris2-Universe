module Evolution.Init

import Evolution.Cycle
import Simplex.Core

import Math.Multiset
import Math.Chromogeometry
import Math.IntPolynumber
import Simplex.Core
import Evolution.Cycle

%default total


||| Generates the default initial conditions where Chromogeometry acts as the macro target.
||| It seeds the grid with foundational points (like the Water/H-Bond origin roots)
||| to jumpstart the relational clock loop safely at T=0.
public export
seedChromogeometricVacuum : (capacityLimit : Nat) -> UniverseState
seedChromogeometricVacuum capacityLimit =
  let -- 1. Define the baseline primordial coordinate vertices (The Root Geometry)
      origin = MkPixel 0 0
      basisX = MkPixel 1 0 -- The primordial X-axis Pauli vector
      basisY = MkPixel 0 1 -- The primordial Y-axis Pauli vector
      
      -- 2. Build the initial Substrate (A small seed graph of relationships)
      -- This gives the clock its very first relational links so T can begin to tick
      -- This is our initial 1-Chain!
      initSubstrate = AddM (origin, basisX) 1 (AddM (origin, basisY) 1 ZeroM)
                               
      -- 3. Seed the initial State Vector with unexcited background amplitudes
      -- The emptyIntPoly represents the quiet vacuum before spreadPoly convolution triggers
      vacuumAmp  = emptyIntPoly
      initFields = AddM (origin, vacuumAmp) 1 (AddM (basisX, vacuumAmp) 1 (AddM (basisY, vacuumAmp) 1 ZeroM))
  in MkUniverseState initSubstrate initFields

