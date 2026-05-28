module Evolution.Clock

import Simplex.Core
import Evolution.State

import Evolution.State
import Simplex.Core

import Math.Multiset
import Math.IntPolynumber
import Math.SpreadPolynumber
import Data.List

%default covering

||| Extracts the relational time step directly from the density of causal edges.
||| Folds through the Substrate multiset to determine the absolute Leibniz Lag.
public export
computeCausalLag : Substrate -> Nat
computeCausalLag = substrateLag

||| Merges two Substrate causal graphs (native multiset union).
public export
mergeGraph : Substrate -> Substrate -> Substrate
mergeGraph = mergeSubstrate

||| Advances the system state by performing a raw Substrate merge.
|||
||| The relational clock is driven by the **state vector's own structural
||| density** — how much complexity the SparseMaxel currently carries.
||| This is the key insight: time is not an external parameter or a substrate
||| edge count. It is the internal lag of the state itself.
|||
||| The `unfoldStatePoly` pattern:
|||   1. Check the current density of the state multiset (stateLag)
|||   2. Use that density to select the spread polynomial degree
|||   3. Convolve each amplitude with that spread polynomial
|||
||| This makes the clock self-referential: denser states experience more
||| polynomial stretching, accumulating more lag, which in turn drives
||| the next tick. This is relational time — the clock reads the observer.
public export
stepMaxelTime : Substrate                                    -- Active spacetime graph at T
             -> Substrate                                    -- New structural relations to merge
             -> Multiset (Pixel Integer, IntPolynumber) -- State vector to evolve
             -> Multiset (Pixel Integer, IntPolynumber) -- Evolved state vector at T + delta
stepMaxelTime currentGraph incomingRelations items_mset =
  let -- 1. Merge the new causal relations directly using native multiset union
      updatedGraph = mergeGraph currentGraph incomingRelations
      
      -- 2. Extract relational time from the STATE VECTOR'S own density.
      --    The structural density of the multiset IS the clock.
      --    Denser states → higher spread degree → more polynomial stretching.
      structuralDensity = cast {to = Nat} (multiplicityAll items_mset)
      
      -- 3. Look up the matching Wildberger spread polynomial for this density
      temporalSpread = spreadPoly structuralDensity
      
      evolvePair : ((Pixel Integer, IntPolynumber), Integer) -> ((Pixel Integer, IntPolynumber), Integer)
      evolvePair ((geom, poly), count) =
        let evolvedPoly = mulIntPoly poly temporalSpread
        in ((geom, evolvedPoly), count)
      
      evolvedStates = map evolvePair (multisetToList items_mset)
  in fromList evolvedStates


