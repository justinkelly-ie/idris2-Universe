module Simplex.DiscreteCalculus

import Math.Polynumber
import Math.IntPolynumber
import Math.SpreadPolynumber
import Math.Multiset
import Data.List

%default total

||| Discrete Calculus on the Primorial Manifold
|||
||| Traditional calculus assumes a continuous continuum (dx -> 0).
||| In the deterministic Primorial architecture, continuity is physically impossible.
||| Instead, we have two native forms of discrete calculus:
|||
||| 1. The McBride Derivative (Topological / Types)
||| 2. The Wildberger Derivative (Algebraic / Arithmetical)
||| 3. Leibniz Integration (Lag Accumulation)

-----------------------------------------------------------------------
-- 1. THE MCBRIDE DERIVATIVE (Topological Defect)
-----------------------------------------------------------------------
||| In type theory, the derivative of a data structure is its "Zipper" — 
||| the structure with exactly one element removed, leaving a "hole".
||| Physically, this represents a Dirac Hole or a local vacuum defect 
||| created when a particle is torn from the background.
public export
record DiracHole a where
  constructor MkHole
  leftContext  : List a
  rightContext : List a

||| The topological derivative of a list of states.
||| Differentiates a sequence by isolating a single state as the focal point,
||| leaving behind a Dirac Hole (the derivative) and the extracted particle.
public export
mcbrideDerivative : List a -> Maybe (DiracHole a, a)
mcbrideDerivative [] = Nothing
mcbrideDerivative (x :: xs) = Just (MkHole [] xs, x)

-----------------------------------------------------------------------
-- 2. THE WILDBERGER DERIVATIVE (Spread Arithmetic)
-----------------------------------------------------------------------
||| Norman Wildberger's Rational Trigonometry does not use limits. 
||| The derivative of a Spread Polynomial is purely algebraic.
||| For $S_n(s)$, the discrete rate of change across adjacent states is:
||| $\Delta S_n(s) = S_{n+1}(s) - S_n(s)$
public export covering
wildbergerDerivative : Nat -> IntPolynumber
wildbergerDerivative n = 
  let sn  = spreadPoly n
      sn1 = spreadPoly (S n)
  in subIntPoly sn1 sn

-----------------------------------------------------------------------
-- 3. LEIBNIZ INTEGRATION (The Lag/Debt Accumulator)
-----------------------------------------------------------------------
||| Integration is not an area under a curve, but the strict algebraic
||| summation of discrete residues (Lag) left behind by coordinate transitions.
||| As particles bind into heavier composites, their internal fractional
||| tension accumulates as a measurable integer "Lag" debt against the grid.
public export
leibnizIntegralLag : Nat -> Nat
leibnizIntegralLag Z = 0
leibnizIntegralLag (S k) = 
  -- Simple placeholder model: Each successive coordinate bounds more lag.
  (S k) + leibnizIntegralLag k
