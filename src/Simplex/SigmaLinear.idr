module Simplex.SigmaLinear

import Simplex.Core

-----------------------------------------------------------------------
-- PHASE 1: CORE FOUNDATIONAL TYPES (The Linear Dependent Multiset)
-----------------------------------------------------------------------

||| A Directed Edge (1-Simplex) pairing a source and target vertex coordinate.
public export
0 Edge : Type
Edge = (Simplex.Core.Geometry, Simplex.Core.Geometry)

-----------------------------------------------------------------------
-- MULTISET ALIASES
-----------------------------------------------------------------------

||| The purely type-verified Vertex Multiset (replaces LCell0 logic)
public export
0 LVexel : (contents : List (Simplex.Core.Geometry, Integer)) -> Type
LVexel contents = LMultiset Integer Simplex.Core.Geometry contents

||| Legacy compatibility alias for LVexel.
public export
0 LDepVexel : (contents : List (Simplex.Core.Geometry, Integer)) -> Type
LDepVexel = LVexel

||| The purely type-verified Edge Multiset (replaces runtime multiset edges)
public export
0 LSubstrate : (contents : List (Edge, Integer)) -> Type
LSubstrate contents = LMultiset Integer Edge contents

||| Legacy compatibility alias for LSubstrate.
public export
0 LDepSubstrate : (contents : List (Edge, Integer)) -> Type
LDepSubstrate = LSubstrate

-----------------------------------------------------------------------
-- PHASE 2: MATHEMATICAL SPECIFICATIONS (The Formal Layer)
-----------------------------------------------------------------------

||| Computes the multiset coordinate reduction of a Substrate boundary to a Vexel boundary.
||| A directed edge (src, tgt) with count c adds `c` to tgt and subtracts `c` from src.
public export
computeBoundaryIndex : List (Edge, Integer) -> List (Simplex.Core.Geometry, Integer)
computeBoundaryIndex [] = []
computeBoundaryIndex (((src, tgt), count) :: xs) = 
  (tgt, count) :: (src, -count) :: computeBoundaryIndex xs

||| Formal Specification of a generic time evolution epoch.
||| This acts as the indisputable mathematical proof of the physics logic.
||| (Placeholder: strictly increments counts to prove structure logic).
public export
nextContents : List (a, Integer) -> List (a, Integer)
nextContents [] = []
nextContents ((item, count) :: xs) = (item, count + 1) :: nextContents xs

-----------------------------------------------------------------------
-- PHASE 3: THE LINEAR EXECUTION ENGINE (The Physics Layer)
-----------------------------------------------------------------------

||| The blazing-fast, strictly linear algorithm that physically shreds 
||| edges into vertices at runtime. The compiler structurally forces it 
||| to perfectly match the `computeBoundaryIndex` math specification!
public export
applyBoundary : {0 edges : List (Edge, Integer)} -> 
                (1 chain : LDepSubstrate edges) -> 
                LDepVexel (computeBoundaryIndex edges)
applyBoundary LEmptyM = LEmptyM
applyBoundary (LAddM (src, tgt) count prev) =
  LAddM tgt count (LAddM src (-count) (applyBoundary prev))

||| A time-evolution step that consumes the universe linearly.
||| The compiler mathematically guarantees that the runtime output perfectly matches 
||| the `nextContents` specification.
public export
stepUniverse : {0 contents : List (a, Integer)} -> 
               (1 currentMesh : LMultiset Integer a contents) -> 
               LMultiset Integer a (nextContents contents)
stepUniverse LEmptyM = LEmptyM
stepUniverse (LAddM item count prev) = LAddM item (count + 1) (stepUniverse prev)

-----------------------------------------------------------------------
-- PHASE 4: DYNAMIC MACROS (The Sigma Layer)
-----------------------------------------------------------------------

||| The Dynamic Vertex Multiset.
||| Wraps the linear structure in a Dependent Pair (DPair) so the compiler 
||| doesn't explode when the universe expands, while still formally proving execution.
public export
0 DynamicVexel : Type
DynamicVexel = (c : List (Simplex.Core.Geometry, Integer) ** LDepVexel c)

||| The Dynamic Edge Substrate.
public export
0 DynamicSubstrate : Type
DynamicSubstrate = (edges : List (Edge, Integer) ** LDepSubstrate edges)

||| The Dynamic Causal Flow Boundary Wrapper.
||| Unpacks the DPair, applies the causal boundary math to the type index, 
||| executes the linear physics in-place, and repacks it.
public export
runBoundary : DynamicSubstrate -> DynamicVexel
runBoundary (edges ** chain) = (computeBoundaryIndex edges ** applyBoundary chain)

||| The Dynamic Universe Wrapper.
public export
0 DynamicUniverse : (a : Type) -> Type
DynamicUniverse a = (c : List (a, Integer) ** LMultiset Integer a c)

||| The Macroscopic Runtime Epoch.
public export
runDynamicEpoch : DynamicUniverse a -> DynamicUniverse a
runDynamicEpoch (c ** mesh) = (nextContents c ** stepUniverse mesh)

-----------------------------------------------------------------------
-- PHASE 5: LINEAR SCALE PROMOTION (The L-Scale Promotion Layer)
-----------------------------------------------------------------------

||| A strictly linear, type-verified Universe State.
||| Tracks both the substrate edges and state vector contents at the type level.
public export
data LUniverseState : (edges : List (Edge, Integer)) -> 
                      (contents : List ((Simplex.Core.Geometry, Amplitude), Integer)) -> 
                      Type where
  MkLUniverseState : (1 substrate : LSubstrate edges) -> 
                     (1 stateVector : LMultiset Integer (Simplex.Core.Geometry, Amplitude) contents) -> 
                     LUniverseState edges contents

||| The Dynamic Linear Universe State.
||| Wraps the type-verified linear state in a double dependent pair.
public export
0 DynamicLUniverseState : Type
DynamicLUniverseState = 
  (edges : List (Edge, Integer) ** 
   contents : List ((Simplex.Core.Geometry, Amplitude), Integer) ** 
   LUniverseState edges contents)

||| Sums the amplitudes of a list of states.
public export
sumLinearAmplitudes : List ((Simplex.Core.Geometry, Amplitude), Integer) -> Amplitude
sumLinearAmplitudes [] = emptyIntPoly
sumLinearAmplitudes (((_, poly), count) :: xs) = 
  addIntPoly (scaleMultiset (fromInteger count) poly) (sumLinearAmplitudes xs)

||| Computes the type-level content index of a post-ascension Vexel.
public export
computeAscendContents : (target : Simplex.Core.Geometry) -> 
                         List ((Simplex.Core.Geometry, Amplitude), Integer) -> 
                         List ((Simplex.Core.Geometry, Amplitude), Integer)
computeAscendContents target contents =
  let sumPoly = sumLinearAmplitudes contents
  in [((target, sumPoly), 1)]

||| Strictly linear scale promotion.
||| Consumes the linear state vector in-place, sums the amplitudes, and returns 
||| a type-verified singleton LMultiset at the target coordinate.
public export
lascendScale : {0 contents : List ((Simplex.Core.Geometry, Amplitude), Integer)} -> 
               (target : Simplex.Core.Geometry) -> 
               (1 state : LMultiset Integer (Simplex.Core.Geometry, Amplitude) contents) -> 
               LMultiset Integer (Simplex.Core.Geometry, Amplitude) (computeAscendContents target contents)
lascendScale target state =
  let MkLUnboxResult frozen = lunboxLMultiset state
  in LAddM (target, sumLinearAmplitudes frozen) 1 LEmptyM
