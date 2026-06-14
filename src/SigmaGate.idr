module SigmaGate

import Simplex.Core
import Simplex.SigmaLinear
import Math.Multiset

-----------------------------------------------------------------------
-- SIGMA MELT ENGINE (Passes from Non-Linear Runtime to Linear Type)
-----------------------------------------------------------------------

||| Recursively builds a Linear Multiset (LMultiset) from a standard runtime list.
||| This is the magic step that elevates runtime data into the type signature!
public export
buildLDep : (c : List (a, Integer)) -> LMultiset Integer a c
buildLDep [] = LEmptyM
buildLDep ((item, count) :: rest) = LAddM item count (buildLDep rest)

||| Melts a standard Vexel (Legacy) into a Dynamic Universe wrapper (Sigma).
||| This takes the raw non-linear field and locks it into the DPair wrapper.
public export
sigmaMeltVexel : Simplex.Core.Vexel -> Simplex.SigmaLinear.DynamicUniverse (Simplex.Core.Geometry, Simplex.Core.Amplitude)
sigmaMeltVexel mset = 
  let c = multisetToList mset
  in (c ** buildLDep c)

||| Melts a standard Substrate (Legacy) into a Dynamic Substrate (Sigma).
public export
sigmaMeltChain : Simplex.Core.Substrate -> Simplex.SigmaLinear.DynamicSubstrate
sigmaMeltChain sub = 
  let edges = multisetToList sub
  in (edges ** buildLDep edges)

-----------------------------------------------------------------------
-- SIGMA FREEZE ENGINE (Passes from Linear Type back to Non-Linear Runtime)
-----------------------------------------------------------------------


||| Freezes a Dynamic Universe back into the legacy Vexel.
||| This allows the visualizer to render the output cleanly.
public export
sigmaFreezeVexel : Simplex.SigmaLinear.DynamicUniverse (Simplex.Core.Geometry, Simplex.Core.Amplitude) -> Simplex.Core.Vexel
sigmaFreezeVexel (c ** m) = fromList (freezeLDep m)

||| Freezes a Geometry-only multiset boundary into a legacy Vexel.
public export
sigmaFreezeGeometryVexel : Simplex.SigmaLinear.DynamicVexel -> Simplex.Core.Vexel
sigmaFreezeGeometryVexel (c ** m) = 
  let geomList = freezeLDep m
      maxelList = map (\(g, count) => ((g, emptyAmplitude), count)) geomList
  in fromList maxelList

||| Freezes a Dynamic Substrate back into the legacy Substrate.
public export
sigmaFreezeChain : Simplex.SigmaLinear.DynamicSubstrate -> Simplex.Core.Substrate
sigmaFreezeChain (edges ** chain) = fromList (freezeLDep chain)
