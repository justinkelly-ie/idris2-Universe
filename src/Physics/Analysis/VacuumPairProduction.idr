module Physics.Analysis.VacuumPairProduction

import Simplex.Core

import Math.IntPolynumber
import Math.Multiset
import Simplex.Core
import Math.SpreadPolynumber

%default total

||| Vacuum Pair Production (Schwinger Effect / Hawking Radiation)
|||
||| In standard quantum field theory, the vacuum is not empty; it is a boiling 
||| sea of virtual particles. Under intense electric fields (Schwinger Effect) 
||| or extreme gravitational gradients (Hawking Radiation), these virtual 
||| particles are ripped apart into real particle-antiparticle pairs.
|||
||| In the Primorial architecture, the vacuum is exactly represented by 
||| the Multiset where the sum of multiplicities is 0, but the list contains 
||| latent (1, -1) pairings waiting to be extracted.
|||
||| Pair production is simply a structural mapping: applying a metrical gradient 
||| to an empty Multiset forces the array to explicitly unroll a +1 and -1 
||| node onto the blue visible grid.

||| Creates a spontaneous Matter/Antimatter pair out of the empty grid
||| using the intense gradient of the S_13 Resonance Gate.
|||
||| Operates directly on the SparseMaxel (FibreBundle = Multiset (Geometry, Amplitude)).
||| By injecting +1 and -1 multiplicities at a target coordinate, we model
||| the vacuum being ripped into a pair.
public export
simulateSchwingerEffect : SparseMaxel -> Geometry -> SparseMaxel
simulateSchwingerEffect pip targetCoord =
  let -- Inject a particle (+1) and antiparticle (-1) at the target
      particlePoly     = fromList [((1, 0), 1)]  -- monomial s^1
      antiparticlePoly = fromList [((1, 0), -1)] -- monomial s^1 with negative coefficient
      pairInjection = fromList [ ((targetCoord, particlePoly), 1)
                               , ((targetCoord, antiparticlePoly), 1) ]
  in superposeStates pip pairInjection

||| Hawking Radiation: Near a Grid Fracture boundary (Event Horizon),
||| one half of the pair is captured by the fractional anomaly, while the 
||| other escapes as visible Hawking radiation.
|||
||| Structurally, the grid fracture swallows the negative coefficient,
||| leaving the positive particle stranded on the visible grid.
public export
simulateHawkingRadiation : SparseMaxel -> Geometry -> SparseMaxel
simulateHawkingRadiation pip targetCoord =
  let hawkingPoly = fromList [((1, 0), 1)]
      hawkingEmission = fromList [ ((targetCoord, hawkingPoly), 1) ]
  in superposeStates pip hawkingEmission


