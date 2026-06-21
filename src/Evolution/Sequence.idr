module Evolution.Sequence

import Simplex.Core
import Evolution.Cycle
import Math.Chromogeometry

%default total

||| Formal Wildberger sequence type (infinite lazy stream).
||| Avoids standard library Stream to maintain strict finitist architectural control.
public export
data Sequence : Type -> Type where
  Seq : a -> Inf (Sequence a) -> Sequence a

||| Fuel for bounded observation of infinite sequences.
public export
data Fuel = Dry | More (Inf Fuel)

public export
limit : Nat -> Fuel
limit Z = Dry
limit (S k) = More (limit k)

||| Observes a prefix of the causal timeline.
public export
observeSequence : Fuel -> Sequence a -> List a
observeSequence Dry _ = []
observeSequence (More f) (Seq x xs) = x :: observeSequence f xs

||| Generates the infinite causal timeline of the universe.
||| Evaluated lazily; perfect for polling from the JS/WASM UI every 10 seconds.
public export
universeSequence : Nat -> ChromoMetric -> Geometry -> UniverseState -> Sequence UniverseState
universeSequence cap metric target state =
  let nextState = runAdaptiveCycle cap metric target state
  in Seq state (universeSequence cap metric target nextState)
