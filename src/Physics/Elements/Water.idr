module Physics.Elements.Water

import Physics.Elements.Hydrogen
import Simplex.Core
import Physics.Particles.Electron
import Physics.Elements.Element
import Evolution.Gate
import Physics.Elements.Oxygen

import Simplex.Core
import Physics.Elements.Hydrogen
import Physics.Elements.Oxygen
import Physics.Particles.Electron
import Evolution.Gate
import Physics.Elements.Element

import Math.Multiset
import Math.IntPolynumber
import Math.SpreadPolynumber
import Math.Chromogeometry

%default total

||| Water (H₂O) — The Molecular Bridge
|||
||| Water is the canonical product of Oxygen's mediator role. Oxygen's
||| valence of 2 (= BackgroundGate degree) means it accepts exactly 2
||| electrons, bonding with exactly 2 Hydrogen atoms.
|||
||| Chromogeometric Structure
|||
||| The H₁-O-H₂ triangle has a canonical geometry on the grid:
|||
|||   O  = (0, 0)     — Oxygen at origin
|||   H₁ = (4, 3)     — BondGate(4), MatterGate(3) coordinates
|||   H₂ = (3, 4)     — Symmetric swap
|||
||| Gate Hierarchy Encoded in the Bond Triangle:
|||
|||   ┌──────────────────────┬──────────────┬──────────────────────┐
|||   │ Quantity             │ Value        │ Gate Origin          │
|||   ├──────────────────────┼──────────────┼──────────────────────┤
|||   │ Bond quadrance       │ 25 = 5²     │ ChargeGate²          │
|||   │ Bond spread          │ 49/625      │ TimeGate² / ChargeGate⁴│
|||   │ Inter-H quadrance    │ 2           │ BackgroundGate       │
|||   │ Red perpendicularity │ True        │ Null-separated       │
|||   │ Coordinates          │ (4,3)↔(3,4) │ BondGate × MatterGate│
|||   └──────────────────────┴──────────────┴──────────────────────┘
|||
||| The two O-H bonds are perpendicular in the Red metric (relativistic),
||| meaning they are null-separated in Minkowski space. This is why
||| water's bent geometry is stable — the bonds are orthogonal in the
||| metric that governs causal structure.
|||
||| Archimedes Function: A(Q)_Blue = 196, A(Q)_Red = A(Q)_Green = -196
||| The chromatic anti-symmetry (Blue = -Red = -Green) is the signature
||| of a stable molecular configuration.
|||
||| Electron Interaction
|||
||| The Electron is the simplest non-fractional topological knot on the
||| MatterGate (n=3). In Water, each O-H bond is mediated by an electron
||| shared between the Hydrogen proton and Oxygen's electron cloud.
|||
||| The electron's position in the bond is the MatterGate component of
||| the H position: (4, 3) → the "3" IS the electron's MatterGate coordinate.
||| The "4" is the BondGate coordinate holding the electron in place.
|||
||| Oxygen's 8 electrons fill the electron cloud, but 2 are "lone pair"
||| electrons available for bonding. These 2 lone pairs accept the 2
||| Hydrogen electrons, forming the 2 covalent bonds. The number of
||| lone pairs available = Oxygen's valence = BackgroundGate degree = 2.

-----------------------------------------------------------------------
-- CANONICAL GEOMETRY
-----------------------------------------------------------------------

||| Hydrogen 1 position on the grid: (BondGate, MatterGate) = (4, 3)
public export
h1Position : Pixel Integer
h1Position = MkPixel 4 3

||| Hydrogen 2 position on the grid: (MatterGate, BondGate) = (3, 4)
public export
h2Position : Pixel Integer
h2Position = MkPixel 3 4

||| Oxygen position: the origin
public export
oPosition : Pixel Integer
oPosition = MkPixel 0 0

-----------------------------------------------------------------------
-- BOND PROPERTIES (from chromogeometry)
-----------------------------------------------------------------------

||| The bond quadrance: Q(OH) = 4² + 3² = 25 = ChargeGate²
||| Both O-H bonds have identical quadrance (symmetric molecule).
public export
bondQuadrance : Integer
bondQuadrance = quadranceNL Blue oPosition h1Position

||| The bond spread at O (the "bond angle"):
||| spread = (4·4 - 3·3)² / (25 · 25) = 49/625 = 7²/5⁴
|||
||| Numerator = TimeGate²
||| Denominator = ChargeGate⁴
public export
bondSpread : (Integer, Integer)
bondSpread = spreadNL Blue oPosition h1Position h2Position

||| The inter-hydrogen quadrance: Q(H₁H₂) = (4-3)² + (3-4)² = 2
||| This is exactly the BackgroundGate degree.
public export
interHydrogenQuadrance : Integer
interHydrogenQuadrance = quadranceNL Blue h1Position h2Position

||| The O-H bonds are perpendicular in the Red metric.
||| Red perpendicularity: a1·a2 - b1·b2 = 4·3 - 3·4 = 0
||| This means the bonds are null-separated in Minkowski geometry.
public export
bondsRedPerpendicular : Bool
bondsRedPerpendicular = isPerpendicularNL Red h1Position h2Position

-----------------------------------------------------------------------
-- ELECTRON INTERACTION
-----------------------------------------------------------------------

||| An electron in the Water bond: placed at the MatterGate coordinate.
||| The electron sits on the n=3 MatterGate, providing visible geometry.
||| Its state is the S_3 spread polynomial at the bond position.
public export
bondElectron : Pixel Integer -> Electron
bondElectron pos = MkElectron (fromList [((pos, spreadPoly 3), 1)])

||| The two bonding electrons in Water, one per O-H bond.
||| Each electron sits at its respective H position on the MatterGate.
public export
bondingElectrons : (Electron, Electron)
bondingElectrons = (bondElectron h1Position, bondElectron h2Position)

||| The electron's spread interaction with the O-H bond.
||| The electron at position H₁ = (4,3) has:
|||   Q_Blue(electron) = 25 = ChargeGate²   (same as bond quadrance)
|||   Q_Red(electron)  = 4² - 3² = 7        (= TimeGate degree!)
|||   Q_Green(electron) = 2·4·3 = 24        (= 8 × 3 = Oxygen × MatterGate)
|||
||| The Red quadrance of the electron IS the TimeGate degree.
||| The Green quadrance IS Oxygen's Z (8) times the MatterGate degree (3).
public export
electronRedQuadrance : Integer
electronRedQuadrance = quadranceNL Red oPosition h1Position

||| The Green quadrance of the electron in the bond.
||| Q_Green = 2·4·3 = 24 = 8 × 3 = Oxygen(Z) × MatterGate(n)
public export
electronGreenQuadrance : Integer
electronGreenQuadrance = quadranceNL Green oPosition h1Position

||| The electron-to-electron spread between the two bonding electrons.
||| This measures the angular separation of the two electrons as seen
||| from the Oxygen nucleus.
public export
electronElectronSpread : (Integer, Integer)
electronElectronSpread = spreadNL Blue oPosition h1Position h2Position

-----------------------------------------------------------------------
-- MOLECULE CONSTRUCTION
-----------------------------------------------------------------------

||| A Water molecule: 2 Hydrogen atoms + 1 Oxygen atom + 2 bonds.
||| All components are linearly held — the molecule consumes its atoms.
public export
record WaterMolecule where
  constructor MkWater
  1 hydrogen1  : HydrogenAtom
  1 hydrogen2  : HydrogenAtom
  1 oxygenAtom : OxygenAtom
  1 bonds      : Multiset (Pixel Integer, IntPolynumber)

||| Constructs a Water molecule at the canonical geometry.
||| H₁ at (4,3), H₂ at (3,4), O at origin.
||| The bond polynomial is S_4 (BondGate spread) at each H position.
public export
water : WaterMolecule
water =
  let h1 = hydrogen h1Position
      h2 = hydrogen h2Position
      o  = oxygen oPosition
      bondPoly = spreadPoly (degree BondGate)
      bonds = fromList [ ((h1Position, bondPoly), 1)
                       , ((h2Position, bondPoly), 1) ]
  in MkWater h1 h2 o bonds

||| The total baryonic lag of Water: Z_total = 2×1 + 8 = 10
public export
waterBaryonicLag : Integer
waterBaryonicLag =
  multiplicityAll (elementalState 1 h1Position)
   + multiplicityAll (elementalState 1 h2Position)
   + multiplicityAll (elementalState 8 oPosition)

||| Number of bonds = Oxygen's valence = BackgroundGate degree = 2
public export
waterBondCount : Nat
waterBondCount = oxygenValence

||| Water is stable: total Z (10) is well below the Feynman limit (137).
public export
waterIsStable : Bool
waterIsStable = isStableElement 10


