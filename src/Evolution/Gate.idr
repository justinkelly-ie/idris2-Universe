module Evolution.Gate

import Simplex.Core
import Data.List

%default total

||| The Prime Quantum Gates
|||
||| Six fundamental prime numbers partition the cosmological state space. Each prime
||| generates its own Spread Polynomial, governing how the CellState
||| transitions through the 137-Grid.
|||
||| STRUCTURAL DISCOVERY: The six gates map directly onto the 5 phases of the
||| universal Adaptive Cycle (see Evolution.Transition):
|||
|||   Gate n=2  (BackgroundGate) → Phase 1: UNFOLDING
|||     The first binary bit flips. Primordial vacuum potential unfolds into
|||     discrete space. S_2 generates the background binary processing field.
|||
|||   Gate n=3  (MatterGate)     → Phase 2: EXPANSION
|||     The triadic 3D geometry crystallises (3^3 = 27 visible states).
|||     The universe geometrically expands into visible baryonic matter.
|||
|||   Gate n=5  (ChargeGate)     → Phase 3: SATURATION (part 1)
|||   Gate n=7  (TimeGate)       → Phase 3: SATURATION (part 2)
|||     These two gates share one phase because they are COUPLED phenomena.
|||     S_5 introduces irreducible fractional charges (1/3, 2/3) that cannot
|||     resolve to integers. S_7 converts that irresolvability into Leibniz Lag
|||     (time dilation). Fractional charge and time dilation are the SAME event
|||     seen from two perspectives — spatial and temporal incompleteness.
|||
|||   Gate n=11 (WeakForceGate)  → Phase 4: COLLAPSE
|||     Denominator overflow exceeds the 128-state Dark Energy pool. The arithmetic
|||     shatters, forcing beta decay: 11 → 5 + 4 + 2.
|||
|||   Gate n=13 (ResonanceGate)  → Phase 5: RESIDUE
|||     The S_13 decoherence residue is too complex to annihilate cleanly.
|||     It compresses into Dark Energy — the seed for the NEXT cycle's Unfolding.
|||
|||   n=137 (The Grid Wall)      → NOT a gate within the cycle. The hard
|||     asymptotic boundary. Its unreachability makes the 5-phase reset inevitable.
|||     Its inverse (1/137) is the Fine Structure Constant — the universe's
|||     permanent distance from structural collapse.

public export
data GatePrime : Nat -> Type where
  Vacuum     : GatePrime 1
  Background : GatePrime 2
  Matter     : GatePrime 3
  Bond       : GatePrime 4
  Charge     : GatePrime 5
  Time       : GatePrime 7
  WeakForce  : GatePrime 11
  Resonance  : GatePrime 13
  NonGate    : (n : Nat) -> GatePrime n

public export
data FundamentalGateIndexed : Nat -> Type where
  MkFundamentalGateIndexed : String -> GatePrime n -> FundamentalGateIndexed n

public export
0 FundamentalGate : Type
FundamentalGate = (n : Nat ** FundamentalGateIndexed n)

public export
mkFundamentalGate : (name : String) -> (n : Nat) -> (prf : GatePrime n) -> FundamentalGate
mkFundamentalGate name n prf = (n ** MkFundamentalGateIndexed name prf)

public export
degree : FundamentalGate -> Nat
degree g = g.fst

public export
name : FundamentalGate -> String
name (n ** MkFundamentalGateIndexed gateName prf) = gateName

-----------------------------------------------------------------------
-- INDIVIDUAL GATES
-----------------------------------------------------------------------

||| n=1: The identity gate. spreadPoly 1 = ZeroM (vacuum — no evolution).
public export
VacuumGate : FundamentalGate
VacuumGate = mkFundamentalGate "Absolute Vacuum" 1 Vacuum

||| n=2: Phase 1 — UNFOLDING. Binary field instantiation.
public export
BackgroundGate : FundamentalGate
BackgroundGate = mkFundamentalGate "Background" 2 Background

||| n=3: Phase 2 — EXPANSION. 3D geometry crystallisation (3^3 = 27).
public export
MatterGate : FundamentalGate
MatterGate = mkFundamentalGate "Matter" 3 Matter

||| n=4: Phase 2b — MOLECULAR BONDING. The composite gate 2² = 4.
||| After 3D matter crystallises, binary recombination creates stable bonds
||| between baryonic nodes. This is the chemical bond — the bridge between
||| raw matter (n=3) and irreducible charge fractions (n=5).
||| Not prime, because bonding is a second-order interaction derived from the
||| background binary field (n=2).
public export
BondGate : FundamentalGate
BondGate = mkFundamentalGate "Molecular Bond" 4 Bond

||| n=5: Phase 3a — SATURATION (charge). Irreducible fractional charges (1/3, 2/3).
public export
ChargeGate : FundamentalGate
ChargeGate = mkFundamentalGate "Fractional Charge" 5 Charge

||| n=7: Phase 3b — SATURATION (time). Leibniz Lag from fractional irresolvability.
public export
TimeGate : FundamentalGate
TimeGate = mkFundamentalGate "Time Dilation" 7 Time

||| n=11: Phase 4 — COLLAPSE. Denominator overflow triggers beta decay.
public export
WeakForceGate : FundamentalGate
WeakForceGate = mkFundamentalGate "Weak Force" 11 WeakForce

||| n=13: Phase 5 — RESIDUE. Decoherence shattering produces dark matter seed.
public export
ResonanceGate : FundamentalGate
ResonanceGate = mkFundamentalGate "Decoherence Resonance" 13 Resonance

-----------------------------------------------------------------------
-- THE PRIMORIAL MANIFOLD
-----------------------------------------------------------------------

||| The total combinatorial state space (210) generated by the multiplication 
||| of the four foundational Prime Gates. This completely defines the bounds 
||| of the universal state pool natively in the code.
|||
|||   2 × 3 × 5 × 7 = 210 total states
|||   → 27  visible matter  (3^3, Blue Metric)
|||   → 128 dark energy      (2^7, Red Metric)
|||   → 55  background dust  (210 - 27 - 128, Green Metric)
public export
primorialManifold : Nat
primorialManifold = (degree BackgroundGate) * (degree MatterGate) * (degree ChargeGate) * (degree TimeGate)

-----------------------------------------------------------------------
-- THE ADAPTIVE CYCLE (Canonical Gate Sequence)
--
-- The 5-phase Adaptive Cycle is the cosmological heartbeat.
-- Each complete cycle takes the universe from vacuum potential
-- through matter crystallisation, saturation, collapse, and residue.
-- The residue of one cycle seeds the next — the Big Crunch/Big Bang
-- transition is just the boundary between Phase 5 and Phase 1.
--
--   Phase 1:  UNFOLDING   (n=2)   → Binary vacuum → discrete space
--   Phase 2:  EXPANSION   (n=3)   → 3D geometry → baryonic matter
--   Phase 2b: BONDING     (n=4)   → Molecular bonds → chemistry
--   Phase 3:  SATURATION  (n=5,7) → Fractional charges + time dilation
--   Phase 4:  COLLAPSE    (n=11)  → Denominator overflow → beta decay
--   Phase 5:  RESIDUE     (n=13)  → Decoherence residue → dark matter seed
--
-- stepRelationalTime is the generalised single-gate stepper.
-- adaptiveCycle is the canonical sequence that feeds it.
-----------------------------------------------------------------------

||| The canonical 5-phase Adaptive Cycle as an ordered gate sequence.
|||
||| Each gate is applied in order via stepRelationalTime. The output of
||| one gate becomes the input to the next. After Phase 5 (ResonanceGate),
||| the residue loops back to Phase 1 (BackgroundGate) — the cycle repeats.
|||
||| Note: VacuumGate (n=1) is NOT in the cycle — it is the identity / ground state.
||| The cycle begins at n=2 (the first non-trivial evolution).
public export
adaptiveCycle : List FundamentalGate
adaptiveCycle = [ BackgroundGate   -- Phase 1:  Unfolding
               , MatterGate        -- Phase 2:  Expansion
               , BondGate          -- Phase 2b: Molecular Bonding
               , ChargeGate        -- Phase 3a: Saturation (charge)
               , TimeGate          -- Phase 3b: Saturation (time)
               , WeakForceGate     -- Phase 4:  Collapse
               , ResonanceGate     -- Phase 5:  Residue
               ]

||| The total prime degree of one complete Adaptive Cycle.
|||
||| This is the product of all gate degrees in the cycle:
|||   2 × 3 × 4 × 5 × 7 × 11 × 13 = 120120
|||
||| Each cycle multiplies the address space capacity by this factor.
||| After 38 cycles: 30030^38 ≈ the full cosmological state budget.
public export
cycleDegree : Nat
cycleDegree = foldl (*) 1 (map degree adaptiveCycle)

-----------------------------------------------------------------------
-- GATE SELECTION
-----------------------------------------------------------------------

||| Maps a local twist value (already reduced mod 137) to the Adaptive
||| Cycle gate whose degree best characterises that local phase.
|||
||| Selects the largest gate degree that does not exceed n.
||| Defaults to BackgroundGate (degree 2) for the vacuum / trivial case
||| where the local twist is too small to exceed any gate threshold.
|||
||| Used by Evolution.LocalSpreadPolynumber.generateLocalSpreadPoly to
||| convert a chromogeometric local spread measurement into the canonical
||| S_n(s) spread polynomial for that phase of the Adaptive Cycle.
public export
selectGate : Nat -> FundamentalGate
selectGate n =
  let candidates = filter (\g => degree g <= n) adaptiveCycle
  in case last' candidates of
       Just g  => g
       Nothing => BackgroundGate

||| Returns the effective coupling exponent (multiplicity) of a gate at scale k.
public export
runningCoupling : Nat -> FundamentalGate -> Nat
runningCoupling k gate =
  let n = natToInteger k + 1
      d = natToInteger (degree gate)
  in if d <= 1 then Z else go n d Z (k + 1)
  where
    go : Integer -> Integer -> Nat -> Nat -> Nat
    go val base acc Z = acc
    go val base acc (S fuel) =
      if val == 0 then acc
      else if val `mod` base == 0
              then go (val `div` base) base (S acc) fuel
              else acc



