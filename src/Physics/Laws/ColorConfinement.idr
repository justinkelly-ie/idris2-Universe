module Physics.Laws.ColorConfinement


import Data.Linear

%default total

||| The Color Confined Interface
||| A physical structure is 'Color Confined' (White/Stable) if and only if
||| its geometric components successfully lock under the structural condition.
||| For Baryons (3 elements), this is the A(Q) = T(s) Triple Spread lock.
||| For Mesons (2 elements), this is the parallel-tension stability.
||| This is the mathematical mechanism driving Quantum Chromodynamics (QCD).
public export
interface ColorConfined a where
  ||| Computes if the given composite shape mathematically satisfies the 
  ||| geometric stability lock.
  isColorless : (1 _ : a) -> LPair Bool a


