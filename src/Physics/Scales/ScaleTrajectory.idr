module Physics.Scales.ScaleTrajectory

import Simplex.Core
import Physics.Scales.PythagoreanFixedPoint
import Physics.Elements.Water
import Evolution.Gate

import Simplex.Core
import Evolution.Gate
import Physics.Elements.Water
import Physics.Scales.PythagoreanFixedPoint

import Math.Multiset
import Math.IntPolynumber
import Math.SpreadPolynumber
import Math.Chromogeometry

%default total

||| Scale Trajectory — The 38-Scale Self-Addition Path
|||
||| Starting from Water's Pythagorean fixed point (4,3), each scale
||| is reached by adding (4,3) to the previous position:
|||
|||   position(k) = (4(k+1), 3(k+1))
|||
||| This yields a universal invariance:
|||
|||   Blue Q(k)  = 25(k+1)² = ChargeGate² × (k+1)²
|||   Red Q(k)   = 7(k+1)²  = TimeGate × (k+1)²
|||   Green Q(k) = 24(k+1)² = Oxygen×MatterGate × (k+1)²
|||
||| The gate fingerprint (25, 7, 24) is preserved at EVERY scale.
||| The only variable is (k+1)², the generation number squared.
|||
||| Decoherence occurs when (k+1) contains a prime beyond the gate
||| hierarchy {2, 3, 5, 7, 11, 13}. The decoherent primes are:
|||
|||   {17, 19, 23, 29, 31, 37, 41, 43, ...}
|||
||| The full trajectory spans 137 scales (the grid wall).
||| We are in the 38th epoch (n=39 = 3×13 = MatterGate×ResonanceGate).
||| The Eddington epoch is gate-pure — the universe is coherent HERE.

-----------------------------------------------------------------------
-- TRAJECTORY
-----------------------------------------------------------------------

||| The position at scale k.
public export
scalePosition : Nat -> Pixel Integer
scalePosition k =
  let n = cast {to=Integer} k + 1
  in MkPixel (4 * n) (3 * n)

||| The fingerprint at scale k.
public export
scaleFingerprint : Nat -> PythagoreanFixedPoint
scaleFingerprint k = fingerprint (scalePosition k)

-----------------------------------------------------------------------
-- INVARIANTS
-----------------------------------------------------------------------

||| Blue quadrance at scale k = 25 × (k+1)²
public export
blueAtScale : Nat -> Integer
blueAtScale k = let n = cast {to=Integer} k + 1 in 25 * n * n

||| Red quadrance at scale k = 7 × (k+1)²
public export
redAtScale : Nat -> Integer
redAtScale k = let n = cast {to=Integer} k + 1 in 7 * n * n

||| Green quadrance at scale k = 24 × (k+1)²
public export
greenAtScale : Nat -> Integer
greenAtScale k = let n = cast {to=Integer} k + 1 in 24 * n * n

||| The gate fingerprint is invariant: Blue/n² = 25, Red/n² = 7, Green/n² = 24.
public export
fingerprintInvariant : Nat -> Bool
fingerprintInvariant k =
  let fp = scaleFingerprint k
      n = cast {to=Integer} k + 1
      nSq = n * n
  in fp.blueQ == 25 * nSq && fp.redQ == 7 * nSq && fp.greenQ == 24 * nSq

-----------------------------------------------------------------------
-- GATE PURITY
-----------------------------------------------------------------------

||| Divides out all factors of d from x.
divOut : Integer -> Integer -> Integer
divOut x d = if d <= 1 || x == 0 then x
             else if mod x d == 0 then assert_total (divOut (div x d) d)
             else x

||| Checks if an integer factors purely into gate primes {2,3,5,7,11,13}.
public export
isGatePure : Integer -> Bool
isGatePure n =
  let reduced = foldl divOut (abs n) [2, 3, 5, 7, 11, 13]
  in reduced == 1 || n == 0

||| Is generation n gate-pure? Decoherence occurs when n contains
||| a prime beyond the gate hierarchy.
public export
isCoherentGeneration : Nat -> Bool
isCoherentGeneration k = isGatePure (cast k + 1)

-----------------------------------------------------------------------
-- THE 38-CYCLE
-----------------------------------------------------------------------

||| The grid wall: 137 total scales.
public export
gridWall : Nat
gridWall = 137

||| The observer's epoch: the 38th cycle.
public export
observerEpoch : Nat
observerEpoch = 38

||| The Eddington generation number: 39 = 3 × 13 = MatterGate × ResonanceGate.
public export
eddingtonGeneration : Integer
eddingtonGeneration = cast observerEpoch + 1

||| The Eddington cycle is gate-pure.
public export
eddingtonIsCoherent : Bool
eddingtonIsCoherent = isCoherentGeneration observerEpoch

||| 39 = 3 × 13 = MatterGate × ResonanceGate.
public export
eddingtonIsMatterTimesResonance : Bool
eddingtonIsMatterTimesResonance =
  eddingtonGeneration == cast (degree MatterGate) * cast (degree ResonanceGate)

||| The number of gate-pure scales in the full 137-grid [0..136].
public export
coherentScaleCount : Nat
coherentScaleCount = length (filter isCoherentGeneration [0..136])

||| The number of decoherent scales in the full 137-grid.
public export
decoherentScaleCount : Nat
decoherentScaleCount = gridWall `minus` coherentScaleCount

||| First decoherence occurs at k=16 (n=17, the first non-gate prime).
public export
firstDecoherence : Nat
firstDecoherence = 16

||| k=16 is indeed decoherent.
public export
firstDecoherenceIsK16 : Bool
firstDecoherenceIsK16 = not (isCoherentGeneration 16) && isCoherentGeneration 15


