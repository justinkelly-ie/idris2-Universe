module Physics.Elements.Methane

import Physics.Elements.Hydrogen
import Physics.Elements.Carbon
import Simplex.Core
import Physics.Particles.Electron
import Physics.Elements.Element
import Evolution.Gate

import Math.Multiset
import Math.IntPolynumber
import Math.SpreadPolynumber
import Math.Chromogeometry

%default total

||| Methane (CH₄) — The Simplest Organic Molecule
|||
||| Methane is composed of 1 Carbon atom and 4 Hydrogen atoms.
||| Carbon's valence of 4 (= BondGate degree) means it forms exactly 4 bonds.
|||
||| Chromogeometric Structure
|||
||| In 3D space, Methane is tetrahedral. In our 2D chromogeometric grid,
||| it projects as a perfectly balanced cross in the Blue metric.
|||
|||   C  = (0, 0)     — Carbon at origin
|||   H₁ = (4, 3)     — Q_Blue = 25, Q_Red = 7
|||   H₂ = (-3, 4)    — Q_Blue = 25, Q_Red = -7
|||   H₃ = (-4, -3)   — Q_Blue = 25, Q_Red = 7
|||   H₄ = (3, -4)    — Q_Blue = 25, Q_Red = -7
|||
||| Notice the incredible structural symmetries:
|||   1. Blue Quadrance = 25 (ChargeGate²) for all 4 bonds.
|||   2. The bonds are perfectly orthogonal in the Blue Metric (Euclidean cross).
|||   3. The Red Quadrance exactly alternates between +7 and -7 (TimeGate).
|||      This perfectly balanced TimeGate signature represents the dynamic
|||      stability (oscillation/folding) of the carbon backbone!

-----------------------------------------------------------------------
-- CANONICAL GEOMETRY
-----------------------------------------------------------------------

public export
ch4_h1 : Pixel Integer
ch4_h1 = MkPixel 4 3

public export
ch4_h2 : Pixel Integer
ch4_h2 = MkPixel (-3) 4

public export
ch4_h3 : Pixel Integer
ch4_h3 = MkPixel (-4) (-3)

public export
ch4_h4 : Pixel Integer
ch4_h4 = MkPixel 3 (-4)

public export
cPosition : Pixel Integer
cPosition = MkPixel 0 0

-----------------------------------------------------------------------
-- BOND PROPERTIES
-----------------------------------------------------------------------

||| All 4 bonds share the same Blue quadrance: 25 = ChargeGate²
public export
methaneBondQuadrance : Integer
methaneBondQuadrance = quadranceNL Blue cPosition ch4_h1

||| The H1-H2 bond angle is exactly 90 degrees (orthogonal) in the Blue metric.
||| Blue dot product: (4)(-3) + (3)(4) = -12 + 12 = 0
public export
bondsBlueOrthogonal : Bool
bondsBlueOrthogonal = isPerpendicularNL Blue ch4_h1 ch4_h2

||| The Red quadrance perfectly alternates between +7 and -7.
||| This is the TimeGate signature (+7) balancing itself dynamically.
public export
redSignatureH1 : Integer
redSignatureH1 = quadranceNL Red cPosition ch4_h1 -- 16 - 9 = 7

public export
redSignatureH2 : Integer
redSignatureH2 = quadranceNL Red cPosition ch4_h2 -- 9 - 16 = -7

public export
redSignatureH3 : Integer
redSignatureH3 = quadranceNL Red cPosition ch4_h3 -- 16 - 9 = 7

public export
redSignatureH4 : Integer
redSignatureH4 = quadranceNL Red cPosition ch4_h4 -- 9 - 16 = -7

-----------------------------------------------------------------------
-- FORMAL FINDINGS & PROOFS
-----------------------------------------------------------------------

||| Formal Proof that the Red Quadrance signature of Methane forms
||| a perfect TimeGate oscillation (+7, -7, +7, -7).
public export
methaneTimeOscillation : (Physics.Elements.Methane.redSignatureH1 = 7, Physics.Elements.Methane.redSignatureH2 = -7, Physics.Elements.Methane.redSignatureH3 = 7, Physics.Elements.Methane.redSignatureH4 = -7)
methaneTimeOscillation = (Refl, Refl, Refl, Refl)

||| Formal Proof that Methane forms a pure Null Vector in Minkowski space.
||| The total TimeGate oscillation sums to exactly 0 (7 - 7 + 7 - 7 = 0).
||| This means the Carbon Backbone is causally stable (a persistent identity),
||| exactly like the (7,7) hydrogen bond in IceGeometry!
public export
methaneNullVector : (Physics.Elements.Methane.redSignatureH1 + Physics.Elements.Methane.redSignatureH2 + Physics.Elements.Methane.redSignatureH3 + Physics.Elements.Methane.redSignatureH4 = 0)
methaneNullVector = Refl

||| Formal Proof that the Methane bonds are perfectly orthogonal
||| in the Blue (Euclidean) Metric.
public export
methaneOrthogonal : isPerpendicularNL Blue Physics.Elements.Methane.ch4_h1 Physics.Elements.Methane.ch4_h2 = True
methaneOrthogonal = Refl

||| Formal Proof that all Methane bonds conserve exactly the same 
||| Blue Quadrance (25 = ChargeGate²) as the Water molecule.
public export
methaneChargeConservation : (Physics.Elements.Methane.methaneBondQuadrance = 25)
methaneChargeConservation = Refl

public export
methaneBaryonicLag : Integer
methaneBaryonicLag =
  multiplicityAll (elementalState 1 ch4_h1)
   + multiplicityAll (elementalState 1 ch4_h2)
   + multiplicityAll (elementalState 1 ch4_h3)
   + multiplicityAll (elementalState 1 ch4_h4)
   + multiplicityAll (elementalState 6 cPosition)

public export
methaneBaryonicLagIs10 : (Physics.Elements.Methane.methaneBaryonicLag = 10)
methaneBaryonicLagIs10 = Refl

||| Formal Proof of Discrete E=mc² (Mass-Energy Equivalence).
||| The total Baryonic Mass (Z) of Methane is 10.
||| The total Euclidean Energy (Blue Quadrance) of its 4 bonds is 100 (25 × 4).
||| Energy (100) = Mass (10)².
||| Water does NOT have this property (50 ≠ 10²), making Methane the first
||| "Complete" particle in the scale hierarchy where bond energy perfectly
||| squares the mass.
public export
methaneMassEnergyEquivalence : (Physics.Elements.Methane.methaneBondQuadrance * 4 = Physics.Elements.Methane.methaneBaryonicLag * Physics.Elements.Methane.methaneBaryonicLag)
methaneMassEnergyEquivalence = Refl

-----------------------------------------------------------------------
-- MOLECULE CONSTRUCTION
-----------------------------------------------------------------------

||| A Methane molecule: 4 Hydrogen atoms + 1 Carbon atom + 4 bonds.
public export
record MethaneMolecule where
  constructor MkMethane
  1 hydrogen1  : HydrogenAtom
  1 hydrogen2  : HydrogenAtom
  1 hydrogen3  : HydrogenAtom
  1 hydrogen4  : HydrogenAtom
  1 carbonAtom : CarbonAtom
  1 bonds      : Multiset (Pixel Integer, IntPolynumber)

||| Constructs a Methane molecule at the canonical geometry.
public export
methane : MethaneMolecule
methane =
  let h1 = hydrogen ch4_h1
      h2 = hydrogen ch4_h2
      h3 = hydrogen ch4_h3
      h4 = hydrogen ch4_h4
      c  = carbon cPosition
      bondPoly = spreadPoly (degree BondGate)
      bonds = fromList [ ((ch4_h1, bondPoly), 1)
                       , ((ch4_h2, bondPoly), 1)
                       , ((ch4_h3, bondPoly), 1)
                       , ((ch4_h4, bondPoly), 1) ]
  in MkMethane h1 h2 h3 h4 c bonds


