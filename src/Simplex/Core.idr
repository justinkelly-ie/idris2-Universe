module Simplex.Core

import public Math.Multiset
import public Math.LMultiset
import public Math.Maxel
import public Math.DepMultiset
import public Math.DepMaxel
import public Math.DepVexel
import public Math.IntPolynumber
import public Math.Chromogeometry
import public Math.Pixel
import public Math.BoxInt
import public Math.Interfaces
import Data.List

%default total

-----------------------------------------------------------------------
-- THE TWO FUNDAMENTAL PRIMITIVES
--
-- Every concept in this engine is built from two nested structures:
--
--   Geometry  = Pixel BoxInt    (a 2-component chromogeometric coordinate)
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
Geometry = Pixel Blue BoxInt

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
Substrate = Multiset Integer (Geometry, Geometry)

-----------------------------------------------------------------------
-- 4. SPARSE MAXEL (The Quantum State Vector)
-----------------------------------------------------------------------

||| The state vector (energy/mass field coefficients).
||| A state is literally a multiset of pixel-amplitude pairs.
public export
0 Vexel : Type
Vexel = Multiset Integer (Geometry, Amplitude)

||| The total Leibniz Lag of a Vexel (sum of all entry multiplicities).
|||
public export
stateLag : Vexel -> Integer
stateLag m = multiplicityAll m

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
  stateVector  : Vexel

-----------------------------------------------------------------------
-- 6. SUBSTRATE UTILITIES
-----------------------------------------------------------------------

||| Computes the total causal density (Leibniz Lag) of the Substrate.
|||
public export
substrateLag : Substrate -> Nat
substrateLag sub = Prelude.integerToNat (multiplicityAll sub)

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
-- 7. Vexel UTILITIES
-----------------------------------------------------------------------

||| The empty Vexel — the physical vacuum state.
public export
emptyVexel : Vexel
emptyVexel = ZeroM

||| A singleton Vexel — a single coordinate mapped to one amplitude.
||| This is the result of ascendScale: the entire micro-graph collapses to one entry.
|||
public export
singletonVexel : Geometry -> Amplitude -> Vexel
singletonVexel geom amp = fromList [((geom, amp), 1)]

||| Superposition — the native multiset union of two state vectors.
|||
public export
superposeStates : Vexel -> Vexel -> Vexel
superposeStates = addMultiset



||| Restriction of a Vexel to entries matching a specific Geometry.
|||
||| This is the coordinate filter: pulling back entries from the global state vector
||| to a specific coordinate pixel key. In multiset terms: filter by coordinate.
|||
public export
restrictToPixel : Geometry -> Vexel -> Vexel
restrictToPixel geom pip =
  fromList (filter (\((g, _), _) => g == geom) (multisetToList pip))

||| Checks that every Geometry referenced in the Vexel exists as a node
||| in the Substrate causal graph.
|||
||| A synchronised state guarantees the state vector does not reference a
||| location that has no causal history. An unsynchronised state
||| indicates a causal boundary violation — undefined physics.
|||
public export
isSynchronised : Substrate -> Vexel -> Bool
isSynchronised sub pip =
  let subNodes = substrateNodes sub
      pipCoords = map (fst . fst) (multisetToList pip)
  in all (\g => elem g subNodes) pipCoords

-----------------------------------------------------------------------
-- 8. STATE SERIALIZATION BRIDGE (JSON Export)
-----------------------------------------------------------------------

||| Formats a List of String elements with a separator.
private
join : String -> List String -> String
join sep [] = ""
join sep [x] = x
join sep (x :: xs) = x ++ sep ++ join sep xs

||| Serializes a Geometry (Pixel BoxInt) to JSON.
public export
serializeGeometry : Geometry -> String
serializeGeometry (MkPixel s t) =
  let (MkUr sVal) = boxToInt s
      (MkUr tVal) = boxToInt t
  in "{\"src\":" ++ show sVal ++ ",\"tgt\":" ++ show tVal ++ "}"

||| Serializes a polynomial term to JSON.
public export
serializeTerm : ((Nat, Nat), BoxInt) -> String
serializeTerm ((alpha, beta), count) =
  let (MkUr countVal) = boxToInt count
  in "{\"alpha\":" ++ show alpha ++ ",\"beta\":" ++ show beta ++ ",\"count\":" ++ show countVal ++ "}"

||| Serializes an Amplitude (IntPolynumber) to JSON.
public export
serializeAmplitude : Amplitude -> String
serializeAmplitude amp =
  "[" ++ join "," (map serializeTerm (multisetToList amp)) ++ "]"

||| Serializes a Vexel state vector element to JSON.
public export
serializeMaxelItem : ((Geometry, Amplitude), Integer) -> String
serializeMaxelItem ((geom, amp), count) =
  "{\"geom\":" ++ serializeGeometry geom ++
  ",\"amplitude\":" ++ serializeAmplitude amp ++
  ",\"count\":" ++ show count ++ "}"

||| Serializes a Vexel state vector to JSON.
public export
serializeVexel : Vexel -> String
serializeVexel maxel =
  "[" ++ join "," (map serializeMaxelItem (multisetToList maxel)) ++ "]"

||| Serializes a Substrate causal edge to JSON.
public export
serializeEdge : ((Geometry, Geometry), Integer) -> String
serializeEdge ((parent, child), count) =
  "{\"parent\":" ++ serializeGeometry parent ++
  ",\"child\":" ++ serializeGeometry child ++
  ",\"count\":" ++ show count ++ "}"

||| Serializes a Substrate causal graph to JSON.
public export
serializeSubstrate : Substrate -> String
serializeSubstrate sub =
  "[" ++ join "," (map serializeEdge (multisetToList sub)) ++ "]"

||| Serializes the complete UniverseState to a structured JSON string.
public export
serializeUniverseState : UniverseState -> String
serializeUniverseState (MkUniverseState sub stateVec) =
  "{\"substrate\":" ++ serializeSubstrate sub ++
  ",\"stateVector\":" ++ serializeVexel stateVec ++ "}"


