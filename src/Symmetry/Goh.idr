module Symmetry.Goh

import Math.IntPolynumber
import Math.SpreadPolynumber
import Math.BoxInt
import Data.List

||| Returns True if the set of primitive factors changes structural degree composition
||| between scale k1 and k2 (corresponding to generations n1 = k1 + 1 and n2 = k2 + 1).
public export covering
isPhaseTransition : Nat -> Nat -> Bool
isPhaseTransition k1 k2 =
  let factors1 = gohFactorsForDivisors (k1 + 1)
      factors2 = gohFactorsForDivisors (k2 + 1)
      divs1 = map (\(d ** _) => d) factors1
      divs2 = map (\(d ** _) => d) factors2
  in divs1 /= divs2
