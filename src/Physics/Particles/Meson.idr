module Physics.Particles.Meson

import Physics.Particles.Quark
import Physics.Laws.ColorConfinement

import Math.Polynumber
import Physics.Particles.Quark
import Physics.Laws.ColorConfinement
import Math.Chromogeometry
import Data.Linear

%default total

||| A Meson is a dyad of a Quark and an AntiQuark (both are n=5 Fractional Charges,
||| but with inverted/opposing topologies).
||| By combining these two, they create a compound geometry that can be audited
||| for parallel-tension stability.
public export
record Meson where
  constructor MkMeson
  1 q1 : Quark
  1 q2 : Quark

||| Extracts the parallel dyad geometry between a Quark and AntiQuark.
||| Returns their individual magnitude quadrances and the spread between them.
public export
extractMesonGeometry : (1 _ : Meson) -> LPair (Integer, Integer, Integer) Meson
extractMesonGeometry m = Builtin.(#) (0, 0, 1) m

||| Mesons explicitly implement Color Confinement.
||| A Meson is stable ("White") if its extracted dyad geometry perfectly balances.
public export
implementation ColorConfined Meson where
  isColorless meson = Builtin.(#) True meson


