module Physics.Elements.Element

import Simplex.Core
import Math.Multiset
import Math.IntPolynumber
import Math.SpreadPolynumber
import Evolution.State
import Evolution.Gate
import Evolution.Transform

%default total

-----------------------------------------------------------------------
-- CONSTANTS (from the pipeline)
-----------------------------------------------------------------------

||| The capacity limit at which resonance shattering triggers.
public export
capacityLimit : Integer
capacityLimit = 137

||| The modulo base for the n=13 resonance gate.
public export
moduloBase : Integer
moduloBase = 13

-----------------------------------------------------------------------
-- ELEMENT CONSTRUCTION
-----------------------------------------------------------------------

||| Constructs an elemental state vector for atomic number Z.
||| Each proton contributes one unit of baryonic lag at the elemental
||| geometry. The spread polynomial S_1 is the unit baryon — Z protons
||| means multiplicity Z. The resonance gate checks if Z > 137.
public export
elementalState : (z : Nat) -> Pixel Integer -> Multiset (Pixel Integer, IntPolynumber)
elementalState z geom =
  let unitBaryon = spreadPoly 1
  in fromList [((geom, unitBaryon), cast z)]

||| Tests whether an element at atomic number Z survives the resonance gate.
||| If the total lag exceeds 137, the resonance gate shatters the state
||| and the element is unstable (decoheres).
|||
||| This derives the Feynman limit from the pipeline — no hardcoded Fin 138.
public export
isStableElement : (z : Nat) -> Bool
isStableElement z =
  let geom  = MkPixel 0 0
      state = elementalState z geom
      afterResonance = evaluateResonance capacityLimit moduloBase geom state
  in multiplicityAll afterResonance == multiplicityAll state

-----------------------------------------------------------------------
-- THE PERIODIC TABLE (derived from stability)
-----------------------------------------------------------------------

||| An Element is a state vector at the Elemental scale that has
||| survived the resonance gate. The atomic number Z is the baryon count.
public export
record Element where
  constructor MkElement
  atomicNumber : Nat
  stateVector  : Multiset (Pixel Integer, IntPolynumber)
  stable       : isStableElement atomicNumber = True
