module Simplex.Core

import public Math.Multiset
import public Math.IntPolynumber
import public Math.Chromogeometry
import public Math.Pixel
import Data.List

%default total

-----------------------------------------------------------------------
-- THE TWO FUNDAMENTAL PRIMITIVES
--
-- Every concept in this engine is built from two nested structures:
--
--   Geometry  = Pixel Integer   (a 2-component chromogeometric coordinate)
--   Amplitude = IntPolynumber     (a polynomial of integer coefficients)
--
-----------------------------------------------------------------------

-----------------------------------------------------------------------
-- 1. GEOMETRY (The Elementary Spatial Unit)
-----------------------------------------------------------------------

||| A chromogeometric coordinate cell — the elementary spatial unit.
|||
public export
0 Geometry : Type
Geometry = Pixel Integer

-----------------------------------------------------------------------
-- 2. AMPLITUDE (The Quantum State Value)
-----------------------------------------------------------------------

||| The polynomial amplitude at a geometric coordinate.
|||
public export
0 Amplitude : Type
Amplitude = IntPolynumber

public export
emptyAmplitude : Amplitude
emptyAmplitude = ZeroM

-----------------------------------------------------------------------
-- 3. SUBSTRATE (The Causal Graph — pure Multiset of directed edges)
--
-- The Substrate is now a pure Multiset (Geometry, Geometry) — each entry
-- is a directed causal edge from parent to child. No wrapper record,
-- no intermediate List — just the same Multiset engine used everywhere.
--
--   Substrate = PixelGraph Integer
--
-- This makes the architecture diagram exact:
--
--       [ BASE SUBSTRATE ]              [ STATE SPACE ]
--       PixelGraph Integer              PixelCochain Integer Amplitude
-----------------------------------------------------------------------

||| The directed causal relations of the spacetime grid (causal poset).
||| Spacetime relations are literally a multiset of pixel-to-pixel edges.
public export
0 Substrate : Type
Substrate = Multiset (Geometry, Geometry)

-----------------------------------------------------------------------
-- 4. SPARSE MAXEL (The Quantum State Vector)
-----------------------------------------------------------------------

||| The state vector (energy/mass field coefficients).
||| A state is literally a multiset of pixel-amplitude pairs.
public export
0 SparseMaxel : Type
SparseMaxel = Multiset (Geometry, Amplitude)

-----------------------------------------------------------------------
-- 5. UNIVERSE STATE (The Total Cosmological Configuration)
-----------------------------------------------------------------------

||| The complete universe state: a causal substrate graph paired with a
||| quantum state vector.
|||
public export
record UniverseState where
  constructor MkUniverseState
  ||| The directed causal relations (spacetime / poset / substrate).
  substrate    : Substrate
  ||| The quantum amplitude assignments (matter fields / state vector).
  stateVector  : SparseMaxel

-----------------------------------------------------------------------
-- 6. SUBSTRATE UTILITIES
-----------------------------------------------------------------------

||| Computes the total causal density (Leibniz Lag) of the Substrate.
|||
public export
substrateLag : Substrate -> Nat
substrateLag sub = cast (multiplicityAll sub)

||| Merge two Substrate causal graphs (native multiset union).
|||
public export
mergeSubstrate : Substrate -> Substrate -> Substrate
mergeSubstrate = addMultiset

||| The empty Substrate (vacuum — no causal relations).
public export
emptySubstrate : Substrate
emptySubstrate = ZeroM

||| A single directed causal edge: g1 causally precedes g2.
public export
singleEdge : Geometry -> Geometry -> Substrate
singleEdge g1 g2 = fromList [((g1, g2), 1)]

||| Extracts all unique Geometry nodes referenced in the Substrate
||| (both parents and children of all edges).
public export
substrateNodes : Substrate -> List Geometry
substrateNodes sub =
  nub (concatMap (\((g1, g2), _) => [g1, g2]) (multisetToList sub))

-----------------------------------------------------------------------
-- 7. SparseMaxel UTILITIES
-----------------------------------------------------------------------

||| The empty SparseMaxel — the physical vacuum state.
public export
emptySparseMaxel : SparseMaxel
emptySparseMaxel = ZeroM

||| A singleton SparseMaxel — a single coordinate mapped to one amplitude.
||| This is the result of ascendScale: the entire micro-graph collapses to one entry.
|||
public export
singletonSparseMaxel : Geometry -> Amplitude -> SparseMaxel
singletonSparseMaxel geom amp = fromList [((geom, amp), 1)]

||| Superposition — the native multiset union of two state vectors.
|||
public export
superposeStates : SparseMaxel -> SparseMaxel -> SparseMaxel
superposeStates = addMultiset

||| The total Leibniz Lag of a SparseMaxel (sum of all entry multiplicities).
|||
public export
stateLag : SparseMaxel -> Integer
stateLag m = multiplicityAll m

||| Restriction of a SparseMaxel to entries matching a specific Geometry.
|||
||| This is the sheaf restriction map: pulling back entries from a large
||| open set to a smaller one. In multiset terms: filter by coordinate.
|||
public export
restrictToPixel : Geometry -> SparseMaxel -> SparseMaxel
restrictToPixel geom pip =
  fromList (filter (\((g, _), _) => g == geom) (multisetToList pip))

||| Checks that every Geometry referenced in the SparseMaxel exists as a node
||| in the Substrate causal graph.
|||
||| A synchronised state guarantees the state vector does not reference a
||| location that has no causal history. An unsynchronised state
||| indicates a torn sheaf — undefined physics.
|||
public export
isSynchronised : Substrate -> SparseMaxel -> Bool
isSynchronised sub pip =
  let subNodes = substrateNodes sub
      pipCoords = map (fst . fst) (multisetToList pip)
  in all (\g => elem g subNodes) pipCoords

