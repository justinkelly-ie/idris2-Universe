# idris2-LUniverse

**The core natural science simulation engine for [Nat-Science](https://github.com/justinkelly-ie/Nat-Science).**

[![Idris2](https://img.shields.io/badge/Idris2-Pure_Nat-blue.svg)](https://github.com/idris-lang/Idris2)
[![Modules](https://img.shields.io/badge/Modules-59-green.svg)]()
[![Tests](https://img.shields.io/badge/Tests-55_passing-brightgreen.svg)]()

---

## Overview

`idris2-LUniverse` is the physics, chemistry, biology, and neurology engine within the **Nat-Science** project — a unified discrete natural science model built entirely over Natural Numbers (`Nat`).

Every physical concept — particles, bonds, elements, cosmological epochs, biological folds — is modelled as a pure algebraic constraint on a flat integer multiset grid. No floating point. No arbitrary constants. No continuous fields.

### Dependencies

| Package | Role |
|---|---|
| [`idris2-Multiset`](https://github.com/justinkelly-ie/idris2-Multiset) | Pure RLE multiset algebra |
| [`idris2-Chromogeometry`](https://github.com/justinkelly-ie/idris2-Chromogeometry) | Wildberger's RGB rational chromogeometry |
| [`idris2-QuickCheck`](https://github.com/justinkelly-ie/idris2-QuickCheck) | Property-testing harness |

---

## Module Structure (59 modules)

```
src/
├── Simplex/              ← Discrete multiset substrate
│   ├── Core.idr              Multiset type aliases, Geometry, Amplitude
│   ├── SigmaLinear.idr       Linear Dependent Multisets, Dynamic DPairs
│   ├── Composition.idr
│   ├── DiscreteCalculus.idr
│   └── Twist.idr
│
├── Evolution/            ← Universal engine — prime spread polynomial gates
│   ├── Gate.idr              n=2,3,4,5,7,11,13 adaptive cycle phases
│   ├── Cycle.idr
│   ├── SpreadPolynumber.idr
│   ├── Transform.idr
│   └── Clock.idr, Identity.idr, Init.idr, State.idr
│
└── Physics/              ← Emergent science
    ├── SigmaBridge.idr       Sigma-Linear Execution Engine Bridge
    ├── Particles/            Photon, Quark, Baryon, Electron, Meson,
    │                         Neutrino, WeakBoson, Bond
    ├── Laws/                 ColorConfinement, EnergyConservation,
    │                         PauliExclusion, PrimorialConservation, WeakForce
    ├── Analysis/             14 cosmological & field analysis modules
    │                         (Baryogenesis, DarkEnergy, FineStructure, ...)
    ├── Elements/             Hydrogen, Oxygen, Water, Carbon, Methane
    ├── Scales/               PythagoreanFixedPoint, ScaleTrajectory,
    │                         IceGeometry, NaturalFolding, Phylogeny
    └── System/               CosmicPartition, PeriodicTable, HadronGluonDynamics
```

---

## Key Results

| Result | Property |
|---|---|
| 137 stable elements from gate pipeline | `prop_periodicTableHas137` |
| Cosmic budget 128/55/27 from S₁₃ | `prop_cosmicBudgetMatches` |
| Water (4,3)↔(3,4) is Pythagorean Fixed Point | `prop_waterIsFixedPoint` |
| Electron IS the bond | `prop_electronSpreadIsBondSpread` |
| Hydrogen bond is null vector (Red Q=0) | `prop_hydrogenBondIsIdentity` |
| 76/137 scales gate-pure; 137 = decoherence | `coherentScaleCount` |
| Observer epoch k=38 gate-pure; 137³⁸ ≈ 10⁸¹ | `prop_eddingtonIsCoherent` |
| Spacetime deforms dynamically with mass-energy | `deformSubstrate` co-evolution |
| Exact Chebyshev symbolic expression recurrence | `SpreadPolyExpr` expression |

---

## Building

This package is resolved as a local dependency via `pack.toml` in the parent [Nat-Science](https://github.com/justinkelly-ie/Nat-Science) workspace.

```bash
# Inside fedora-toolbox-44:
pack build idris2-LUniverse.ipkg
```

See [Nat-Science](https://github.com/justinkelly-ie/Nat-Science) for the full test harness and wiki.

---

© Justin Kelly. All rights reserved.
