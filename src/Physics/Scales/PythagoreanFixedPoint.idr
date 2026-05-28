module Physics.Scales.PythagoreanFixedPoint

import Simplex.Core
import Physics.System.PeriodicTable
import Physics.Elements.Water
import Evolution.Gate
import Physics.Elements.Oxygen
import Evolution.Identity

import Simplex.Core
import Evolution.Gate
import Evolution.Identity
import Physics.Elements.Water
import Physics.Elements.Oxygen
import Physics.System.PeriodicTable

import Math.Multiset
import Math.IntPolynumber
import Math.SpreadPolynumber
import Math.Chromogeometry

%default total

||| Pythagorean Fixed Points — The Self-Referential Scale Transition
|||
||| The water molecule at (4,3) reveals a deep structural pattern:
||| a coordinate that encodes its own generators across all three
||| chromogeometric metrics simultaneously.
|||
||| This is not a coincidence — it is a FIXED POINT of the gate hierarchy.
|||
||| Definition: A Pythagorean Fixed Point is a grid coordinate (a, b) where:
|||
|||   1. a and b are gate degrees from the pipeline
|||   2. a² + b² (Blue)  is a gate degree squared
|||   3. a² - b² (Red)   is a gate degree
|||   4. 2·a·b   (Green) factors into gate degrees
|||
||| The triple (3, 4, 5) is the ONLY primitive Pythagorean triple
||| composed entirely of gate degrees:
|||
|||   3 = MatterGate    (what generates visible structure)
|||   4 = BondGate       (what holds matter together)
|||   5 = ChargeGate     (what enables interaction)
|||   7 = TimeGate       (what drives causal evolution)
|||   8 = Oxygen = 2³    (what mediates energy transfer)
|||
||| Reading (4,3) in each metric reveals a different gate:
|||
|||   Blue:   4² + 3² = 25 = 5²   → ChargeGate²    (interaction strength)
|||   Red:    4² - 3² = 7          → TimeGate        (causal structure)
|||   Green:  2·4·3   = 24 = 8×3  → Oxygen × Matter (energy × structure)
|||
||| The coordinate that describes the bond also describes the gates
||| that create the bond. The snake eats its tail.
|||
||| Scale Transition (N → N+1)
|||
||| This self-referential encoding is the MECHANISM of scale transition:
|||
|||   Scale N (Elemental):
|||     Gates generate the (4,3) fixed point → Water molecule forms.
|||     The electron at (4,3) IS the bond. Particle = Interaction.
|||
|||   Scale N+1 (Molecular):
|||     Water molecules become the NODES of a higher substrate.
|||     The bonds between water molecules (hydrogen bonds) create
|||     a NEW grid. The question: does this new grid have its own
|||     Pythagorean fixed point?
|||
|||   If yes → another scale transition. If no → decoherence.
|||
||| Water's Identity
|||
||| Water's [J,J] diagonal — its PersistentIdentity — IS the (4,3) coordinate.
||| What makes water WATER across all state transitions (ice, liquid, vapour)
||| is not its temperature or phase but its GEOMETRY: the fact that (4,3)
||| reads every gate from every metric. The identity persists because the
||| fixed point is metric-invariant.
|||
||| This is why water is the universal solvent, the basis of biology,
||| and the mediator of all known chemistry: its identity IS the gate
||| hierarchy. Dissolving something in water means embedding it into
||| the self-referential fixed point of the grid.

-----------------------------------------------------------------------
-- THE FIXED POINT
-----------------------------------------------------------------------

||| A Pythagorean Fixed Point on the grid: a coordinate where
||| the chromogeometric quadrances in all three metrics decode
||| back to gate degrees.
public export
record PythagoreanFixedPoint where
  constructor MkFixedPoint
  ||| The coordinate
  point : Pixel Integer
  ||| Blue quadrance (Euclidean): a² + b²
  blueQ : Integer
  ||| Red quadrance (Minkowski): a² - b²
  redQ  : Integer
  ||| Green quadrance (Product): 2ab
  greenQ : Integer

||| Computes the full chromogeometric fingerprint of a grid coordinate.
public export
fingerprint : Pixel Integer -> PythagoreanFixedPoint
fingerprint p = MkFixedPoint p (quadranceNL Blue (MkPixel 0 0) p) (quadranceNL Red (MkPixel 0 0) p) (quadranceNL Green (MkPixel 0 0) p)

||| The Water fixed point: (4, 3)
public export
waterFixedPoint : PythagoreanFixedPoint
waterFixedPoint = fingerprint h1Position

-----------------------------------------------------------------------
-- GATE DECODING
-----------------------------------------------------------------------

||| Checks if an integer is a gate degree or gate degree squared.
public export
isGateDegree : Integer -> Bool
isGateDegree n = n `elem` [2, 3, 4, 5, 7, 11, 13]

||| Checks if an integer is a perfect square of a gate degree.
public export
isGateDegreeSquared : Integer -> Bool
isGateDegreeSquared n = n `elem` [4, 9, 16, 25, 49, 121, 169]

||| Checks if an integer factors purely into gate degrees.
||| e.g. 24 = 8 × 3 = 2³ × 3 → all prime factors are gate degrees.
public export
factorsIntoGates : Integer -> Bool
factorsIntoGates n =
  let reduced = foldl (\acc, g => divOut acc g) n [2, 3, 5, 7, 11, 13]
  in reduced == 1 || reduced == (-1)
  where
    divOut : Integer -> Integer -> Integer
    divOut x d = if d <= 1 then x
                 else if mod x d == 0 then assert_total (divOut (div x d) d)
                 else x

||| A coordinate is a Pythagorean Fixed Point if ALL its chromogeometric
||| quadrances decode back to gate-related values.
public export
isFixedPoint : PythagoreanFixedPoint -> Bool
isFixedPoint fp =
  isGateDegreeSquared fp.blueQ &&      -- Blue = gate²
  isGateDegree fp.redQ &&              -- Red = gate degree
  factorsIntoGates fp.greenQ           -- Green = product of gates

||| Water IS a Pythagorean Fixed Point.
public export
waterIsFixedPoint : Bool
waterIsFixedPoint = isFixedPoint waterFixedPoint

-----------------------------------------------------------------------
-- N+1 SCALE TRANSITION
-----------------------------------------------------------------------

||| At Scale N+1, water molecules become nodes in a higher substrate.
||| The hydrogen bond between two water molecules creates a new edge.
|||
||| In ice (crystalline water), the structure is tetrahedral:
||| each O is bonded to 4 neighbours. The hydrogen bond is weaker
||| than the covalent O-H bond, but it creates the large-scale geometry.
|||
||| The hydrogen bond direction at N+1 is the DIFFERENCE between
||| two water fixed points, rotated by the BondGate.
public export
hydrogenBondDirection : Pixel Integer
hydrogenBondDirection = MkPixel (h1Position.src + h2Position.src)
                                   (h1Position.tgt + h2Position.tgt)
-- = (4+3, 3+4) = (7, 7) — the TimeGate diagonal!

||| The N+1 hydrogen bond fingerprint.
public export
hydrogenBondFingerprint : PythagoreanFixedPoint
hydrogenBondFingerprint = fingerprint hydrogenBondDirection

||| The hydrogen bond at N+1 has direction (7,7):
|||   Blue:  7² + 7² = 98 = 2 × 49 = BackgroundGate × TimeGate²
|||   Red:   7² - 7² = 0    (null vector — pure identity!)
|||   Green: 2·7·7   = 98   (same as Blue — isotropic!)
|||
||| Red quadrance = 0 means the hydrogen bond IS the identity diagonal.
||| It is a null vector in Minkowski space — a pure self-loop.
||| The N+1 bond IS the [J,J] diagonal of the next scale.
public export
hydrogenBondIsIdentity : Bool
hydrogenBondIsIdentity = (fingerprint hydrogenBondDirection).redQ == 0

||| The hydrogen bond is isotropic: Blue = Green.
||| This means the Euclidean and product metrics agree —
||| the bond looks the same from every geometric perspective.
public export
hydrogenBondIsIsotropic : Bool
hydrogenBondIsIsotropic =
  let fp = fingerprint hydrogenBondDirection
  in fp.blueQ == fp.greenQ

-----------------------------------------------------------------------
-- WATER'S PERSISTENT IDENTITY
-----------------------------------------------------------------------

||| Water's identity IS the Pythagorean fixed point.
||| The [J,J] diagonal at the molecular scale is anchored at the
||| coordinate where ALL gates can be read simultaneously.
|||
||| Phase transitions (ice → liquid → vapour) change the N+1 bonds
||| (hydrogen bonds break/reform) but NEVER touch the (4,3) fixed point.
||| The covalent O-H bond persists because (4,3) is a fixed point.
||| The hydrogen bonds fluctuate because (7,7) is a null vector — 
||| it can form and dissolve without violating the structural lock.
public export
waterIdentityCoord : Pixel Integer
waterIdentityCoord = h1Position

||| Water's identity is the coordinate where the self-referential
||| encoding lives. The identity persists through all phase transitions
||| because the fixed point is metric-invariant.
public export
waterIdentityQuadrance : Integer
waterIdentityQuadrance = quadranceNL Blue (MkPixel 0 0) waterIdentityCoord


