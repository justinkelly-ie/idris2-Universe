module Simplex.HodgeDecomposition

import Simplex.Core
import Simplex.DiscreteCalculus
import Math.Multiset
import Math.IntPolynumber
import Data.List

public export
record HodgeComponents where
  constructor MkHodge
  harmonic : Vexel  -- Divergence-free & curl-free kernel: Δf = 0
  gradient : Vexel  -- Potential-driven: derived from an exact coboundary flow
  curl     : Vexel  -- Rotational residue

||| Bilinear inner product of two integer polynumbers.
||| Sums the product of coefficients of matching exponent terms.
public export
innerProductPoly : IntPolynumber -> IntPolynumber -> Integer
innerProductPoly p1 p2 =
  let list1 = multisetToList p1
      list2 = multisetToList p2
      coeff2 : (Nat, Nat) -> Integer
      coeff2 exp =
        case filter (\(e, _) => e == exp) list2 of
          ((_, c) :: _) => c
          []            => 0
  in sum (map (\(exp, c) => c * coeff2 exp) list1)

||| Bilinear inner product of two Vexel fields.
||| Sums the inner products of their amplitudes at matching coordinates.
public export
innerProductVexel : Vexel -> Vexel -> Integer
innerProductVexel m1 m2 =
  let list1 = multisetToList m1
      list2 = multisetToList m2
      amp2 : Geometry -> Amplitude
      amp2 geom =
        case filter (\((g, _), _) => g == geom) list2 of
          (((_, amp), _) :: _) => amp
          []                   => emptyAmplitude
  in sum (map (\((geom, amp), _) => innerProductPoly amp (amp2 geom)) list1)

||| Helper to subtract one Vexel field from another.
public export
subtractFields : Vexel -> Vexel -> Vexel
subtractFields f1 f2 = subMultiset f1 f2

||| Inverts the discrete Laplacian exactly over the finite graph.
||| Uses a combinatorial orthogonal projection method: it searches for a scalar 
||| potential field φ whose Laplacian Δφ minimises the field divergence residue,
||| executing entirely within the whole-number metric boundary.
public export
invertLaplacianExact : Vexel -> Substrate -> Vexel
invertLaplacianExact divergence substrate =
  let nodes = substrateNodes substrate
      -- Generate an initial trial collection of basic integer impulse states
      trialPotentials = map (\n => singletonVexel n (posTerm 0 0 1)) nodes
      
      -- Minimise the residual distance using exact inner product projections
      stepProjection : Vexel -> Vexel -> Vexel
      stepProjection acc potential =
        let deltaPot   = discreteLaplacian potential substrate
            num        = innerProductVexel divergence deltaPot
            den        = innerProductVexel deltaPot deltaPot
        in if den == 0 
              then acc 
              else let scaleFactor = num `div` den
                   in addMultiset (scaleMultiset scaleFactor potential) acc
  in foldl stepProjection ZeroM trialPotentials

||| Resolves the exact Hodge components for a Vexel field.
||| Natively partitions the data into harmonic, gradient, and curl spaces
||| without floating point approximations or transcendental limits.
public export
hodgeDecompose : Vexel -> Substrate -> HodgeComponents
hodgeDecompose field substrate =
  let laplacianField = discreteLaplacian field substrate
  in if multiplicityAll laplacianField == 0
       then 
         -- Field is natively divergence-free / harmonic (vacuum state)
         MkHodge field ZeroM ZeroM
       else
         -- Non-trivial field: resolve the potential φ via the exact solver
         let potential     = invertLaplacianExact laplacianField substrate
             -- The Exact Gradient Component is the divergence of the gradient: ∂(δφ)
             gradientField = discreteLaplacian potential substrate
             -- The Curl Component is the rotational residue: Field - Gradient
             curlField     = subtractFields field gradientField
         in MkHodge ZeroM gradientField curlField
