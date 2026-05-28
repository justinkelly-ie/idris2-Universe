module Physics.Scales.Phylogeny

import Simplex.Core
import Evolution.Identity

import Simplex.Core
import Evolution.Identity

%default total

||| Ontogeny — the individual's lifecycle within the phylogenetic tree.
||| In phylogenetic context, each PersistentIdentity IS an ontogeny:
||| the [J,J] diagonal developing from origin to decoherence at a given scale.
public export
Ontogeny : Nat -> Type
Ontogeny = PersistentIdentity

||| Scale-Invariant Phylogeny (Generalised Parent-Child Lineage)
|||
||| The parent-child relationship is not unique to biology. It is the
||| universal pattern of causal succession in the 137-Grid:
|||
|||   Scale 0 (Quantum):     Particle → decay products
|||   Scale 2 (Molecular):   Reactants → products
|||   Scale 4 (Biological):  Parent → offspring (mitosis / meiosis)
|||   Scale 5 (Neurological): Teacher → student (memetic transmission)
|||   Scale 38 (Cosmic):     Universe N → Universe N+1
|||
||| At every scale, the pattern is the same:
|||   1. A **lineage node** holds a PersistentIdentity (the [J,J] diagonal)
|||      plus linear substrate and accumulated Leibniz Lag
|||   2. To avoid decoherence (death), it **forks** — consuming fresh
|||      environmental substrate to spawn a successor with a new identity
|||   3. The parent's identity persists (ages), the child's identity is fresh
|||   4. When lag exceeds capacity, the node **decoheres** (shatters back
|||      to the scale below)
|||
||| The No-Cloning Theorem is enforced by QTT linearity: you cannot
||| duplicate a lineage node without consuming fresh substrate AND
||| generating a new identity. Two entities cannot share the same [J,J].

||| A lineage node: a PersistentIdentity anchored at a scale,
||| holding linear substrate and accumulating Leibniz Lag over its lifetime.
|||
||| The identity is the [J,J] diagonal — what makes this node THIS node
||| across all its state transitions. The substrate is consumed linearly
||| to enforce the No-Cloning Theorem.
public export
data LineageNode : (n : Nat) -> Type where
  MkNode : (identity : PersistentIdentity n)
         -> (1 state : Substrate)
         -> (lag : Nat) 
         -> LineageNode n

||| A linear pair — parent retains its identity, child receives a new one.
public export
data Fork : (n : Nat) -> Type where
  MkFork : (1 parent : LineageNode n) -> (1 child : LineageNode n) -> Fork n

||| Asexual replication (fork).
|||
||| The parent keeps its [J,J] diagonal (same identity, aged).
||| The child receives a NEW identity and starts with zero lag.
||| Both identities are at the same scale order.
public export
fork : (1 parent : LineageNode n) 
    -> (childIdentity : PersistentIdentity n)
    -> (1 environment : Substrate) 
    -> Fork n
fork (MkNode parentId pState lag) childId envState =
  let aged      = MkNode parentId pState (lag + 1)
      offspring = MkNode childId envState 0
  in MkFork aged offspring

||| A linear triplet — two parent identities persist, child gets a fresh one.
public export
data Merge : (n : Nat) -> Type where
  MkMerge : (1 p1 : LineageNode n) 
          -> (1 p2 : LineageNode n) 
          -> (1 child : LineageNode n) 
          -> Merge n

||| Sexual replication (merge).
|||
||| Two parent nodes each keep their own [J,J] diagonal (both age).
||| The child receives a THIRD identity — distinct from both parents.
||| Three identities, three substrates, no cloning.
public export
merge : (1 parentA : LineageNode n) 
     -> (1 parentB : LineageNode n) 
     -> (childIdentity : PersistentIdentity n)
     -> (1 environment : Substrate) 
     -> Merge n
merge (MkNode idA stateA lagA) (MkNode idB stateB lagB) childId envState =
  let agedA     = MkNode idA stateA (lagA + 1)
      agedB     = MkNode idB stateB (lagB + 1)
      offspring = MkNode childId envState 0
  in MkMerge agedA agedB offspring

||| Viability check (decoherence threshold).
||| When Leibniz Lag exceeds the identity's scale capacity, the node
||| decoheres — the [J,J] diagonal can no longer hold and the structure
||| shatters back to the scale below.
public export
isViable : LineageNode n -> Bool
isViable (MkNode (MkIdentity _ (MkDiagonal geom _)) _ lag) =
  lag < substrateLag (fromList [((geom, geom), 1)])


