module Evolution.IndivisibleHistory

import Math.BoxInt
import Math.SignedFraction
import Math.Chromogeometry
import Simplex.Core
import Data.List

%default total

||| Represents a step-by-step non-Markovian trajectory of geometries.
||| Parameterized by the accumulated quadrance (q_acc) and the most recent node (last_node).
public export
data IndivisibleHistory : (q_acc : BoxInt) -> (last_node : Geometry) -> Type where
  ||| The starting point (origin) of a trajectory.
  Origin : (p : Geometry) -> IndivisibleHistory 0 p
  
  ||| A step in the trajectory. We accumulate the quadranceNL of the transition.
  Step : (prev : IndivisibleHistory q_old last_old)
      -> (next : Geometry)
      -> (metric : Metric)
      -> IndivisibleHistory (q_old + quadranceNL metric (castMetric last_old) (castMetric next)) next

||| Extracts the most recent coordinate node from the history.
public export
lastNode : IndivisibleHistory q last_node -> Geometry
lastNode (Origin p) = p
lastNode (Step _ next _) = next

||| Extracts the length (number of nodes visited) of the history.
public export
historyLength : IndivisibleHistory q last_node -> Nat
historyLength (Origin _) = 1
historyLength (Step prev _ _) = 1 + historyLength prev

||| Extracts the list of nodes in the history.
public export
historyNodes : IndivisibleHistory q last_node -> List Geometry
historyNodes (Origin p) = [p]
historyNodes (Step prev next _) = next :: historyNodes prev

||| Extracts all transitions (directed edges) in the history as a multiset.
public export
historyTransitions : IndivisibleHistory q last_node -> Multiset Integer (Geometry, Geometry)
historyTransitions (Origin _) = ZeroM
historyTransitions (Step prev next _) =
  let edge = (lastNode prev, next)
  in addMultiset (fromList [(edge, 1)]) (historyTransitions prev)

||| Find all targets out of a node in a multiset of transitions.
public export
outTargets : Multiset Integer (Geometry, Geometry) -> Geometry -> List Geometry
outTargets ZeroM _ = []
outTargets (AddM (u, v) _ rest) u' =
  if u == u'
     then nub (v :: outTargets rest u')
     else outTargets rest u'

||| Count occurrences of a specific transition.
public export
transitionCount : Multiset Integer (Geometry, Geometry) -> (Geometry, Geometry) -> Integer
transitionCount ZeroM _ = 0
transitionCount (AddM edge count rest) target =
  if edge == target
     then count + transitionCount rest target
     else transitionCount rest target

||| Sum of squared counts of all outgoing transitions.
public export
sumOutSquared : Multiset Integer (Geometry, Geometry) -> Geometry -> Integer
sumOutSquared mset srcNode =
  let targets = outTargets mset srcNode
      counts = map (\tgt => transitionCount mset (srcNode, tgt)) targets
  in sum (map (\c => c * c) counts)

||| Computes the transition probability p(i -> j) = M_ji^2 / sum_k M_ki^2 as an MSetFraction.
public export
transitionProbability : IndivisibleHistory q last_node -> Geometry -> Geometry -> MSetFraction
transitionProbability hist srcNode tgtNode =
  let mset = historyTransitions hist
      num = transitionCount mset (srcNode, tgtNode)
      numSq = num * num
      den = sumOutSquared mset srcNode
  in if den == 0
        then zeroMSF
        else mkMSF (fromInteger numSq) (Prelude.integerToNat den)

||| Structural recursion helper to check if a Nat is divisible by 3.
public export
divisibleBy3 : Nat -> Bool
divisibleBy3 Z = True
divisibleBy3 (S Z) = False
divisibleBy3 (S (S Z)) = False
divisibleBy3 (S (S (S k))) = assert_total (divisibleBy3 k)

||| Check if the history has reached a division event (reset step).
||| In finite fields of characteristic 3, this occurs at steps matching the field period (multiple of 3).
public export
isDivisionEvent : IndivisibleHistory q last_node -> Bool
isDivisionEvent hist = divisibleBy3 (historyLength hist)
