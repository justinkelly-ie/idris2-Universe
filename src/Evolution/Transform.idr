module Evolution.Transform

import Simplex.Core
import Simplex.Twist
import Evolution.State
import Math.Chromogeometry
import Math.Multiset
import Math.IntPolynumber
import Math.SpreadPolynumber
import Data.List
import Data.Vect
import Decidable.Equality

%default total

-----------------------------------------------------------------------
-- 1. THE PARTITION GATE (Latent / Visible Split)
--

||| Evaluates if a given monomial term coefficient belongs to the Latent band.
isLatentTerm : Integer -> ((Nat, Nat), Integer) -> Bool
isLatentTerm latentBarrier (_, coef) = coef >= latentBarrier

||| The fundamental partition gate. 
public export
partitionLogic : Integer 
              -> Pixel Integer
              -> IntPolynumber 
              -> (Multiset (Pixel Integer, IntPolynumber), Multiset (Pixel Integer, IntPolynumber))
partitionLogic latentBarrier geom rawTerms_mset =
  let (latentTerms, visibleTerms) = partition (isLatentTerm latentBarrier) (multisetToList rawTerms_mset)
      latentPoly  = fromList latentTerms
      visiblePoly = fromList visibleTerms
      latentSpace  = fromList [( (geom, latentPoly), 1 )]
      visibleSpace = fromList [( (geom, visiblePoly), 1 )]
  in (latentSpace, visibleSpace)

-----------------------------------------------------------------------
-- 2. THE RESONANCE GATE (Modulo Shattering)
--

||| Evaluates polynomial shattering on a single monomial term using a specific modulo base.
shatterTerm : Integer -> ((Nat, Nat), Integer) -> ((Nat, Nat), Integer)
shatterTerm moduloBase (powers, coef) = 
  let residue = coef `mod` moduloBase
  in (powers, residue)

||| The Resonance Filter.
public export
evaluateResonance : Integer 
                 -> Integer
                 -> Pixel Integer 
                 -> Multiset (Pixel Integer, IntPolynumber) 
                 -> Multiset (Pixel Integer, IntPolynumber)
evaluateResonance capacityLimit moduloBase geom visibleSpace@items_mset =
  let totalLag = multiplicityAll visibleSpace
  in if totalLag > capacityLimit
        then 
          let allTerms = concatMap (\((_, polyItems_mset), count) => 
                                      map (\(p, c) => (p, c * count)) (multisetToList polyItems_mset)) (multisetToList items_mset)
              shatteredTerms = map (shatterTerm moduloBase) allTerms
              residuePoly    = fromList shatteredTerms
          in fromList [( (geom, residuePoly), 1 )]
        else 
          visibleSpace

-----------------------------------------------------------------------
-- 3. THE ASCENSION GATE (Scale N -> N+1)
--

||| Scalar-only ascension check.
||| Use buildAscensionCapacities for the full three-fold proof.
public export
checkAscension : Integer -> Multiset (Pixel Integer, IntPolynumber) -> Bool
checkAscension capacityLimit stateSpace =
  let totalLag = multiplicityAll stateSpace
  in totalLag == capacityLimit

||| Macro Scale Condensation.
public export
ascendScale : Pixel Integer 
           -> Multiset (Pixel Integer, IntPolynumber) 
           -> Multiset (Pixel Integer, IntPolynumber)
ascendScale macroGeom items_mset =
  let macroPoly = foldl (\acc, ((_, poly), count) =>
                          addMultiset acc (scaleMultiset count poly)
                        ) emptyIntPoly (multisetToList items_mset)
  in fromList [( (macroGeom, macroPoly), 1 )]

-----------------------------------------------------------------------
-- 4. THREE-FOLD ASCENSION PROOF
--

||| Validates whether a local space-time region has reached the scale-ascension horizon.
|||
||| Implements the Deterministic Algebraic Scale Promotion: the 137 scalar tally threshold
||| is replaced by the Chromogeometric Horizon (Three-Fold Spread Lock). Ascension is
||| triggered when, for any 4-cycle loop in the Substrate, the reciprocal spread sum
|||   sum_i (1 / s_i) >= 2
||| meaning metrical torsion saturates the coordinate plane and forces a fold to N+1.
|||
||| The `metric` and `stateSpace` parameters are retained for API compatibility and
||| future Goh Factorisation integration.
||| Computes the degree (maximum alpha power) of an IntPolynumber.
public export
polyDegree : IntPolynumber -> Nat
polyDegree ZeroM = 0
polyDegree (AddM (alpha, beta) _ rest) = max alpha (polyDegree rest)

||| Extracts the aggregate partition polynomial of a Vexel.
public export
extractVexelPoly : Vexel -> IntPolynumber
extractVexelPoly vex =
  foldl (\acc, ((_, poly), count) =>
          addIntPoly acc (scaleMultiset count poly)
        ) emptyIntPoly (multisetToList vex)

||| Validates the Goh Factorisation algebraic horizon for the state.
public export
gohFactorisationHorizon : Vexel -> Bool
gohFactorisationHorizon vex =
  let p = extractVexelPoly vex
      n = polyDegree p
  in n > 0 && p == memoSpreadPoly n

||| Validates whether a local space-time region has reached the scale-ascension horizon.
|||
||| Implements the Deterministic Algebraic Scale Promotion: the 137 scalar tally threshold
||| is replaced by the Chromogeometric Horizon (Three-Fold Spread Lock) and/or the Goh Factorisation.
||| Ascension is triggered when either:
|||   1. Chromogeometric: sum_i (1 / s_i) >= 2
|||   2. Goh Factorisation: P(s) = prod_{d|n} Psi_d(s)
public export
canAscend : Metric -> Substrate -> Vexel -> Bool
canAscend _ substrate stateSpace =
  chromogeometricHorizon substrate || gohFactorisationHorizon stateSpace

