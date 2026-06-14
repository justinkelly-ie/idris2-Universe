module Simplex.DiscreteCalculus

import Math.IntPolynumber
import Math.SpreadPolynumber
import Math.Multiset
import Data.List
import Simplex.Core
import Simplex.SigmaLinear
import Evolution.Cycle
import System.CosmicPartition
import Math.BoxInt

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

||| The multiset derivative of a list of states.
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
  (S k) + leibnizIntegralLag k

||| Grounded Leibniz Integration over the causal substrate network.
||| Sums the amplitude-weighted edge multiplicities across all directed links
||| in the substrate to measure total accumulated coordinate tension.
public export
substrateIntegral : Substrate -> Vexel -> Integer
substrateIntegral substrate field =
  let edges  = multisetToList substrate
      states = multisetToList field
      
      getEnergy : Simplex.Core.Geometry -> Integer
      getEnergy geom =
        case filter (\((g, _), _) => g == geom) states of
          (((_, amp), _) :: _) =>
            let (MkUr val) = boxToInt (multiplicityAll amp)
            in val
          []                   => 0
          
      edgeContribution : ((Simplex.Core.Geometry, Simplex.Core.Geometry), Integer) -> Integer
      edgeContribution ((src, tgt), count) =
        let energySrc = getEnergy src
            energyTgt = getEnergy tgt
        in count * (energySrc + energyTgt)
  in sum (map edgeContribution edges)

||| Computes the discrete flux integral of a 1-cochain (edge field) over the substrate.
||| Sums the signed multiplicity weights of all edges, representing the net flow.
public export
discreteFluxIntegral : Substrate -> Integer
discreteFluxIntegral sub =
  sum (map snd (multisetToList sub))

||| Computes the discrete antiderivative (integration by summation) for a sequence
||| of difference polynomials. Given a list of derivatives [df_0, df_1, ...],
||| returns the accumulated sequence [F_0, F_1, F_2, ...] where F_{k+1} - F_k = df_k.
public export
wildbergerAntiderivative : List IntPolynumber -> List IntPolynumber
wildbergerAntiderivative dfs =
  go ZeroM dfs
  where
    go : IntPolynumber -> List IntPolynumber -> List IntPolynumber
    go acc [] = [acc]
    go acc (df :: rest) =
      acc :: go (addIntPoly acc df) rest

||| A discrete path integral summing over all valid transition histories (Feynman analogue).
||| Runs N epochs, accumulating all intermediate field states as a superposed Multiset path sum.
public export
pathEnsemble : Nat -> UniverseState -> Vexel
pathEnsemble Z state = stateVector state
pathEnsemble (S k) state =
  let capLimit = calculateGridLimit constructPrimorialGrid
      cycled = runAdaptiveCycle capLimit Blue (MkPixel 0 0) state
  in addMultiset (stateVector state) (pathEnsemble k cycled)

-----------------------------------------------------------------------
-- 4. DISCRETE EXTERIOR CALCULUS & LAPLACIAN
-----------------------------------------------------------------------

||| Wildberger's Signed Incidence / Coboundary Operator (Node-to-Edge gradient).
||| Projects a 0-cochain (Vexel vertex field) to a 1-cochain (Substrate edges)
||| by calculating exact integer difference across directed pixel links.
public export
applyCoboundary : Vexel -> Substrate -> Substrate
applyCoboundary stateVector substrate =
  let edges  = multisetToList substrate
      states = multisetToList stateVector
      
      getEnergy : Geometry -> Integer
      getEnergy geom =
        case filter (\((g, _), _) => g == geom) states of
          ((_, c) :: _) => c
          []            => 0
          
      coboundaryEdges = map (\((src, tgt), count) =>
                              let energySrc = getEnergy src
                                  energyTgt = getEnergy tgt
                                  diff = energyTgt - energySrc
                              -- Wildberger's transpose mapping: preserves edge connectivity
                              -- but sets multiplicity to the node potential difference
                              in ((src, tgt), diff)
                            ) edges
  in fromList coboundaryEdges

||| The discrete boundary operator ∂₁ mapping 1-chains (Substrate) to 0-chains (Vexel).
public export
boundaryOp : Substrate -> Vexel
boundaryOp sub =
  let edges = multisetToList sub
      boundaryList = computeBoundaryIndex edges
      states = map (\(geom, count) => ((geom, emptyIntPoly), count)) boundaryList
  in fromList states

||| The Discrete Laplacian operator Δ = ∂ ∘ δ on Pixel space.
||| Evaluates the divergence of the gradient entirely using whole-number arithmetic.
public export
discreteLaplacian : Vexel -> Substrate -> Vexel
discreteLaplacian field substrate =
  let gradient = applyCoboundary field substrate
  in boundaryOp gradient
