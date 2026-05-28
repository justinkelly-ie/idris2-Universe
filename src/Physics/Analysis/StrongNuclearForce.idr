module Physics.Analysis.StrongNuclearForce

import Simplex.Core

import Math.IntPolynumber
import Math.Multiset
import Simplex.Core
import Math.SpreadPolynumber

%default total

||| Strong Nuclear Force (Color Confinement)
|||
||| In standard particle physics, the "Strong Force" binds quarks together inside 
||| hadrons, mediated by the exchange of gluons.
|||
||| In the LUniverse model, forces are purely structural topologies. 
||| The Strong Force is not a "pulling" force—it is the structural integrity of 
||| the dynamic partition grid. Ripping a quark out of the vacuum creates an irreducible 
||| S_5 fractional state (a Dirac Hole / topological defect).
|||
||| Because an isolated fraction cannot resolve into the integer grid, its 
||| "Leibniz Lag" grows infinitely the further it is pulled. To prevent a Grid 
||| Fracture, the system is mathematically forced to spawn an anti-quark pair 
||| to plug the hole (Vacuum Polarization), or pull the quark back in.

||| A topological hole created by extracting a fractional state
public export
record TopologicalDefect where
  constructor MkTopologicalDefect
  ||| The amount of unmet fractional tension
  vacuumTension : Double

||| Evaluates if a SparseMaxel (FibreBundle) contains an isolated quark (fractional defect).
|||
||| A Dirac Hole exists when the ChargeGate (S_5) polynomial is present
||| in the state vector with asymmetric (unannihilated) coefficients.
public export
containsDiracHole : SparseMaxel -> Bool
containsDiracHole pip =
  let chargePolyS5 = spreadPoly 5
      -- Check if any entry's amplitude matches the S_5 polynomial structure
      entries = multisetToList pip
  in any (\((_, poly), _) => multiplicityAll poly > 0) entries
     && stateLag pip > 0

||| The Strong Force Restoring Function:
||| Proves that the vacuum must annihilate (zip up) any topological defect
||| by injecting an inverse Multiset array.
|||
||| Operates on SparseMaxel directly — negates all amplitudes and merges
||| to restore structural zero.
public export
vacuumAnnihilation : SparseMaxel -> SparseMaxel
vacuumAnnihilation pip =
  if containsDiracHole pip then
    let inverseSupp = negateMultiset pip
        restoredSupp = annihilateMultiset (addMultiset pip inverseSupp)
    in restoredSupp
  else
    pip


