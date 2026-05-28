module Evolution.Transform

import Simplex.Core
import Simplex.Twist
import Evolution.State

import Evolution.State
import Simplex.Core
import Simplex.Twist
import Math.Chromogeometry

import Math.Multiset
import Math.Multiset
import Math.IntPolynumber
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



||| Validates if a local space-time region matches the exact 137 Primorial threshold to level up.
||| Driven by your clean list-comprehension triad extractor and GCD-bounded rational twist engine.
public export
canAscend : Metric -> Substrate -> SparseMaxel -> Bool
canAscend metric substrate stateSpace =
  let -- 1. Current State Output: Total active particle energy density in the State Space
      currentOutput = stateLag stateSpace
      
      -- 2. Ancestral Lag: Total structural linkage counts across the Substrate poset network
      ancestralLag = cast (multiplicityAll substrate)
      
      -- 3. Twisting Capacity: The GCD-reduced, path-summed angular spread curvature
      twistingDegrees = cast (computeTwist metric substrate)
      
      -- Combined combinatoric real estate must meet or breach the 137 Leibniz capacity barrier
      totalComputeValue = currentOutput + ancestralLag + twistingDegrees
  in totalComputeValue >= 137


