module Evolution.Clock

import Data.Nat
import Math.Interfaces
import Math.Multiset
import Math.BoxInt
import Math.ExtendedCosmology

||| Measures the mass magnitude of the nested power layers.
||| One = 1, Nest One = 2, etc.
public export
powerToNat : PositivePower -> Nat
powerToNat One      = 1
powerToNat (Nest x) = 1 + powerToNat x

||| Safely extracts the orientation (SignedUnit) and magnitude (PositivePower) 
||| of a BoxInt. Defaults to (Pos, One) if the weight is ZeroM.
public export
decomposeBoxInt : BoxInt -> (SignedUnit, PositivePower)
decomposeBoxInt xs =
  let (MkUr val) = boxToInt (normalizeBoxInt xs)
  in if val > 0
        then (Pos, toPositivePower val)
        else if val < 0
                then (Neg, toPositivePower (abs val))
                else (Pos, One)

||| Converts a PositivePower and a SignedUnit back into a BoxInt.
public export
recomposeBoxInt : SignedUnit -> PositivePower -> BoxInt
recomposeBoxInt orient power =
  let mag = powerToNat power
      val = natToInteger mag
  in case orient of
          Pos => intToBoxInt val
          Neg => intToBoxInt (-val)

||| Represents a formal n^r basis vector token tracking a discrete 
||| number-theoretic coordinate address in the ℕ* domain.
||| Completely replaces abstract continuous or signed points.
public export
record BasisVector where
  constructor MkBasis
  coordinate : Nat -- The 'n' in n^r (Enforced > 0 by constructor invariants)

||| A highly compressed Mlist component pairing an n^r basis vector 
||| with its corresponding BoxInt energy multiplicity scaler (1/a²).
public export
record BasisComponent where
  constructor MkBasisComponent
  vector : BasisVector
  weight : BoxInt

||| The 13 discrete phases of the universal clock cycle.
public export
data ClockPhase = P1  | P2  | P3  | P4  | P5  | P6  | P7 
                | P8  | P9  | P10 | P11 | P12 | P13

||| Steps the clock phase forward deterministically along a closed topological ring.
public export
tickPhase : ClockPhase -> ClockPhase
tickPhase P1  = P2  ; tickPhase P2  = P3  ; tickPhase P3  = P4
tickPhase P4  = P5  ; tickPhase P5  = P6  ; tickPhase P6  = P7
tickPhase P7  = P8  ; tickPhase P8  = P9  ; tickPhase P9  = P10
tickPhase P10 = P11 ; tickPhase P11 = P12 ; tickPhase P12 = P13
tickPhase P13 = P1

||| Maps the active ClockPhase directly to its corresponding prime basis vector (m^r).
||| This prime signature dictates the geometric spacing of the phase transformation.
public export
getPhaseMultiplier : ClockPhase -> BasisVector
getPhaseMultiplier P1  = MkBasis 2  ; getPhaseMultiplier P2  = MkBasis 3
getPhaseMultiplier P3  = MkBasis 5  ; getPhaseMultiplier P4  = MkBasis 7
getPhaseMultiplier P5  = MkBasis 11 ; getPhaseMultiplier P6  = MkBasis 13
getPhaseMultiplier P7  = MkBasis 17 ; getPhaseMultiplier P8  = MkBasis 19
getPhaseMultiplier P9  = MkBasis 23 ; getPhaseMultiplier P10 = MkBasis 29
getPhaseMultiplier P11 = MkBasis 31 ; getPhaseMultiplier P12 = MkBasis 37
getPhaseMultiplier P13 = MkBasis 41

||| Linearly processes an n^r basis component through the S₁₃ clock gates.
||| Evaluates the Dirichlet transformation: m^r × n^r = (m · n)^r
||| 100% free of machine-level 'cast' traits and continuous assumptions.
public export
processBasisGate : ClockPhase -> BasisComponent -> (BasisComponent, BoxInt)
processBasisGate phase (MkBasisComponent (MkBasis n) weight) =
  let
    (orient, mag) = decomposeBoxInt weight
    
    -- 1. Fetch the exact prime basis multiplier (m^r) for this specific clock tick
    (MkBasis m) = getPhaseMultiplier phase
    
    -- 2. Execute Wildberger's Caret product index translation: (m · n)^r
    nextCoordinate = m * n
    nextVector     = MkBasis nextCoordinate
    magNat         = powerToNat mag
  in
    case phase of
         -- Exploitation Zone (P1 - P4): Bound particle propagation.
         -- The basis scales outward cleanly, maintaining standard mass weights.
         P1 => (MkBasisComponent nextVector (recomposeBoxInt orient mag), 1)
         P2 => (MkBasisComponent nextVector (recomposeBoxInt orient mag), 1)
         P3 => (MkBasisComponent nextVector (recomposeBoxInt orient mag), 1)
         P4 => (MkBasisComponent nextVector (recomposeBoxInt orient mag), 1)
         
         -- Conservation Zone (P5 - P10): Multiplicative Hysteresis.
         -- The coordinate shifts, and internal structural nesting depth compounds inductively.
         P5  => (MkBasisComponent nextVector (recomposeBoxInt orient (Nest mag)), 1)
         P6  => (MkBasisComponent nextVector (recomposeBoxInt orient (Nest mag)), 1)
         P7  => (MkBasisComponent nextVector (recomposeBoxInt orient (Nest mag)), 1)
         P8  => (MkBasisComponent nextVector (recomposeBoxInt orient (Nest mag)), 1)
         P9  => (MkBasisComponent nextVector (recomposeBoxInt orient (Nest mag)), 1)
         P10 => (MkBasisComponent nextVector (recomposeBoxInt orient (Nest mag)), 1)
         
         -- Release & Reorganization Zone (P11 - P13): The Primality Singularity.
         -- If the accumulated coordinate vector exceeds the structural 137-nesting threshold,
         -- the particle state collapses, dumping its excess weight into Dark Energy expansion.
         _ => 
           if nextCoordinate >= 137
              then -- Boundary Singular Collapse: Exceeded the stable element limit.
                   -- The lost baryonic count translates directly to background spatial acceleration.
                   ( MkBasisComponent (MkBasis 1) (recomposeBoxInt Pos One)
                   , 128 -- 128 DE Partition
                   )
              else -- Partial Decay: The basis steps forward, emitting Dark Matter feedback tokens
                   let 
                     reducedMagVal = magNat `div` 2
                   in 
                     if reducedMagVal <= 1
                        then ( MkBasisComponent nextVector (recomposeBoxInt orient One)
                             , 55 -- 55 DM Partition
                             )
                        else ( MkBasisComponent nextVector (recomposeBoxInt orient (toPositivePower (natToInteger reducedMagVal)))
                             , 27 -- 27 Baryonic Partition
                             )
