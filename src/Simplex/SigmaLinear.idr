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
0 LDepSparseMaxel : (contents : List (Simplex.Core.Geometry, Integer)) -> Type
LDepSparseMaxel contents = LDepMultiset Simplex.Core.Geometry contents

||| The purely type-verified Edge Multiset (replaces runtime multiset edges)
public export
0 LDepSubstrate : (contents : List (Edge, Integer)) -> Type
LDepSubstrate contents = LDepMultiset Edge contents

-----------------------------------------------------------------------
-- PHASE 2: MATHEMATICAL SPECIFICATIONS (The Formal Layer)
-----------------------------------------------------------------------

||| Computes the multiset coordinate reduction of a Substrate boundary to a SparseMaxel boundary.
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
                LDepSparseMaxel (computeBoundaryIndex edges)
applyBoundary LEmptyM = LEmptyM
applyBoundary (LAddM (src, tgt) count prev) =
  LAddM tgt count (LAddM src (-count) (applyBoundary prev))

||| A time-evolution step that consumes the universe linearly.
||| The compiler mathematically guarantees that the runtime output perfectly matches 
||| the `nextContents` specification.
public export
stepUniverse : {0 contents : List (a, Integer)} -> 
               (1 currentMesh : LDepMultiset a contents) -> 
               LDepMultiset a (nextContents contents)
stepUniverse LEmptyM = LEmptyM
stepUniverse (LAddM item count prev) = LAddM item (count + 1) (stepUniverse prev)

-----------------------------------------------------------------------
-- PHASE 4: DYNAMIC MACROS (The Sigma Layer)
-----------------------------------------------------------------------

||| The Dynamic Vertex Multiset.
||| Wraps the linear structure in a Dependent Pair (DPair) so the compiler 
||| doesn't explode when the universe expands, while still formally proving execution.
public export
0 DynamicSparseMaxel : Type
DynamicSparseMaxel = (c : List (Simplex.Core.Geometry, Integer) ** LDepSparseMaxel c)

||| The Dynamic Edge Substrate.
public export
0 DynamicSubstrate : Type
DynamicSubstrate = (edges : List (Edge, Integer) ** LDepSubstrate edges)

||| The Dynamic Causal Flow Boundary Wrapper.
||| Unpacks the DPair, applies the causal boundary math to the type index, 
||| executes the linear physics in-place, and repacks it.
public export
runBoundary : DynamicSubstrate -> DynamicSparseMaxel
runBoundary (edges ** chain) = (computeBoundaryIndex edges ** applyBoundary chain)

||| The Dynamic Universe Wrapper.
public export
0 DynamicUniverse : (a : Type) -> Type
DynamicUniverse a = (c : List (a, Integer) ** LDepMultiset a c)

||| The Macroscopic Runtime Epoch.
public export
runDynamicEpoch : DynamicUniverse a -> DynamicUniverse a
runDynamicEpoch (c ** mesh) = (nextContents c ** stepUniverse mesh)
