module Physics.Scales.IceGeometry

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

||| Ice Geometry — The N+2 Scale Transition
|||
||| At Scale N+1, water molecules bond via hydrogen bonds in direction (7,7).
||| At Scale N+2, those hydrogen bonds arrange tetrahedrally to form ice.
|||
||| The probe reveals a remarkable self-addition pattern:
|||
|||   (11, 10) = (7, 7) + (4, 3)
|||
||| The N+2 direction is the hydrogen bond PLUS the Water fixed point.
||| The fixed point adds itself to the bond to reach the next scale.
|||
||| Properties of the (11, 10) direction:
|||
|||   Q_Blue  = 11² + 10² = 221 = 13 × 17
|||   Q_Red   = 11² - 10² = 21  = 3 × 7 = MatterGate × TimeGate
|||   Q_Green = 2·11·10   = 220 = 4 × 5 × 11 = BondGate × ChargeGate × 11
|||
||| Critical observations:
|||
|||   1. Red quadrance = 21 = MatterGate × TimeGate
|||      This is the product of visible structure and causal evolution —
|||      the signature of FOLDING (a structure that evolves in time).
|||
|||   2. Blue quadrance = 221 = 13 × 17
|||      13 = ResonanceGate (the decoherence boundary)
|||      17 = the FIRST prime beyond the gate hierarchy
|||      This is where the grid begins to shatter.
|||
|||   3. The edge from (7,7) to (11,10) has quadrance 25 = ChargeGate²
|||      and Archimedes function 196 — IDENTICAL to Water's bond.
|||      The N+2 transition has the same chromogeometric signature as Water.
|||
|||   4. Green quadrance = 220 = 4 × 5 × 11 contains the DecoherenceGate (11).
|||      At this scale, decoherence begins to intrude.
|||
||| This means N+2 is a TRANSITIONAL scale: the gate hierarchy is still
||| visible (Red = 3×7, edge Q = 25) but non-gate primes (17) have entered
||| the Blue metric. The structure is folding (21) but approaching
||| decoherence (221 = 13 × 17).

-----------------------------------------------------------------------
-- N+2 DIRECTION
-----------------------------------------------------------------------

||| The N+2 ice direction: hydrogen bond + fixed point.
||| (7,7) + (4,3) = (11, 10)
public export
iceDirection : Pixel Integer
iceDirection = MkPixel (hydrogenBondDirection.src + h1Position.src)
                          (hydrogenBondDirection.tgt + h1Position.tgt)

||| The N+2 direction is the self-addition of the fixed point.
public export
isSelfAddition : Bool
isSelfAddition =
  iceDirection.src == hydrogenBondDirection.src + h1Position.src &&
  iceDirection.tgt == hydrogenBondDirection.tgt + h1Position.tgt

||| N+2 fingerprint.
public export
iceFingerprint : PythagoreanFixedPoint
iceFingerprint = fingerprint iceDirection

-----------------------------------------------------------------------
-- RED QUADRANCE = FOLDING SIGNATURE
-----------------------------------------------------------------------

||| The Red quadrance at N+2: 21 = 3 × 7 = MatterGate × TimeGate.
||| This is the folding number — the product of structure and time.
public export
iceFoldingNumber : Integer
iceFoldingNumber = quadranceNL Red (MkPixel 0 0) iceDirection

||| The folding number factors into MatterGate × TimeGate.
public export
foldingIsMatterTimesTime : Bool
foldingIsMatterTimesTime =
  iceFoldingNumber == cast (degree MatterGate) * cast (degree TimeGate)

-----------------------------------------------------------------------
-- BLUE QUADRANCE = DECOHERENCE ONSET
-----------------------------------------------------------------------

||| The Blue quadrance at N+2: 221 = 13 × 17.
||| 13 = ResonanceGate (the boundary of the periodic table).
||| 17 = first prime BEYOND the gate hierarchy.
||| The product signals the onset of decoherence.
public export
iceBlueQuadrance : Integer
iceBlueQuadrance = quadranceNL Blue (MkPixel 0 0) iceDirection

||| 221 = 13 × 17: ResonanceGate × first non-gate prime.
public export
blueIsResonanceTimesDecoherence : Bool
blueIsResonanceTimesDecoherence = iceBlueQuadrance == 13 * 17

-----------------------------------------------------------------------
-- EDGE QUADRANCE = WATER'S SIGNATURE PERSISTS
-----------------------------------------------------------------------

||| The edge from (7,7) to (11,10):
||| Q = (11-7)² + (10-7)² = 4² + 3² = 25 = ChargeGate²
||| This is IDENTICAL to Water's bond quadrance.
public export
iceEdgeDirection : Pixel Integer
iceEdgeDirection = MkPixel (iceDirection.src - hydrogenBondDirection.src)
                              (iceDirection.tgt - hydrogenBondDirection.tgt)

||| The edge IS the water fixed point (4,3).
public export
edgeIsWaterFixedPoint : Bool
edgeIsWaterFixedPoint =
  iceEdgeDirection.src == h1Position.src &&
  iceEdgeDirection.tgt == h1Position.tgt

||| The edge quadrance = 25 = ChargeGate² (same as Water).
public export
edgeQuadranceIsWater : Bool
edgeQuadranceIsWater =
  quadranceNL Blue (MkPixel 0 0) iceEdgeDirection == bondQuadrance

-----------------------------------------------------------------------
-- THE ARCHIMEDES INVARIANT
-----------------------------------------------------------------------

||| Archimedes function of the (7,7)-(11,10) triangle.
||| A(Q)_Blue = 196 — same as Water's A(Q)_Blue.
||| The chromogeometric signature is inherited across scales.
public export
iceArchimedes : Integer
iceArchimedes = archimedesNL Blue (MkPixel 0 0) hydrogenBondDirection iceDirection

-----------------------------------------------------------------------
-- FOLDING CONNECTION
-----------------------------------------------------------------------

||| The folding number 21 connects to NaturalFolding.
||| A chain of 21 water molecules driven by S_3 (MatterGate) produces
||| 7 folds — exactly the TimeGate. Or driven by S_7 (TimeGate),
||| produces 3 folds — exactly the MatterGate.
|||
||| 21 / 3 = 7 (TimeGate folds from MatterGate polynomial)
||| 21 / 7 = 3 (MatterGate folds from TimeGate polynomial)
|||
||| The folding number IS the scale at which Matter and Time
||| are perfectly reciprocal.
public export
matterFoldsFromTime : Nat
matterFoldsFromTime = cast (the Integer (div 21 (cast (degree TimeGate))))

public export
timeFoldsFromMatter : Nat
timeFoldsFromMatter = cast (the Integer (div 21 (cast (degree MatterGate))))

||| Matter folds from Time = MatterGate degree.
public export
matterFoldsIsMatter : Bool
matterFoldsIsMatter = matterFoldsFromTime == degree MatterGate

||| Time folds from Matter = TimeGate degree.
public export
timeFoldsIsTime : Bool
timeFoldsIsTime = timeFoldsFromMatter == degree TimeGate


