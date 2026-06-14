module Evolution.UniverseStream

import Math.ExtendedCosmology
import Math.Chromogeometry
import Math.Pixel

||| An infinite stream modeling space-time cycles.
public export
data UniverseStream : Type where
  TimeStep : (darkEnergy : DarkEnergyMetric) -> 
             (particles  : SignedMatter) -> 
             Inf UniverseStream -> 
             UniverseStream


||| Combines two universe streams, forcing matter-antimatter annihilation 
||| to feed the acceleration of Dark Energy.
public export
evolveUniverse : (1 u1 : UniverseStream) -> (1 u2 : UniverseStream) -> UniverseStream
evolveUniverse (TimeStep de1 p1 next1) (TimeStep de2 p2 next2) =
  let newDE = tropicalMultiply de1 de2
  in case (p1, p2) of
       (Matter m1, Matter m2) => 
         TimeStep newDE (Matter (Nest m1)) (evolveUniverse next1 next2)
       (Antimatter a1, Antimatter a2) => 
         TimeStep newDE (Antimatter (Nest a1)) (evolveUniverse next1 next2)
       _ => -- Annihilation case: Mutates into massive Tropical metric expansion
         let catastrophicExpansion = tropicalMultiply newDE (Expansion 5)
         in TimeStep catastrophicExpansion (Matter One) (evolveUniverse next1 next2)
