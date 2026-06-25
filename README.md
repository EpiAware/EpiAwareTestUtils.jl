# EpiAwareTestUtils.jl

| | |
|---|---|
| Docs | [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://epiawaretestutils.epiaware.org/dev/) |
| CI | [![Test](https://github.com/EpiAware/EpiAwareTestUtils.jl/actions/workflows/test.yaml/badge.svg?branch=main)](https://github.com/EpiAware/EpiAwareTestUtils.jl/actions/workflows/test.yaml) [![codecov](https://codecov.io/gh/EpiAware/EpiAwareTestUtils.jl/graph/badge.svg)](https://codecov.io/gh/EpiAware/EpiAwareTestUtils.jl) |
| Quality | [![SciML Code Style](https://img.shields.io/static/v1?label=code%20style&message=SciML&color=9558b2&labelColor=389826)](https://github.com/SciML/SciMLStyle) [![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl) [![JET](https://img.shields.io/badge/%E2%9C%88%EF%B8%8F%20tested%20with%20-%20JET.jl%20-%20red)](https://github.com/aviatesk/JET.jl) [![ColPrac](https://img.shields.io/badge/ColPrac-Contributor%27s%20Guide-blueviolet)](https://github.com/SciML/ColPrac) |
| License | [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) |

Shared, package-agnostic test utilities for [EpiAware](https://github.com/EpiAware) Julia packages.

The package collects the test scaffolding that EpiAware packages would
otherwise each copy: standard quality checks over a target module, and an
AD-gradient harness that checks a package's AD backends against a ForwardDiff
reference. Package-specific fixtures (the actual distributions, models, or
interface checklists) stay in each package; this package only supplies the
reusable run logic.

## What is here

### Package-quality wrappers

Run Aqua, ExplicitImports, and JET over a target module:

```julia
using EpiAwareTestUtils

test_aqua(MyPackage)
test_explicit_imports(MyPackage; ignore = (:SomeInternal,))
test_jet(MyPackage; env = joinpath(@__DIR__, "jet"))
```

`test_aqua` and `test_explicit_imports` run in-process. `test_jet` runs JET in
an isolated environment (pass `env` as a project directory holding JET plus the
package) to keep JET's dependency pins from clashing with the rest of the test
environment, or in-process when `env` is omitted.

### AD-gradient harness

Drive an AD-backend correctness suite against a ForwardDiff reference. The
package supplies an AD-fixture registry satisfying the `ADRegistry` contract
(scenarios with references, a backend list, and broken/skip bookkeeping); the
harness runs the working scenarios and marks the rest broken:

```julia
using EpiAwareTestUtils

test_working_backend(MyPackageADFixtures, "ReverseDiff")
test_partial_backend(MyPackageADFixtures, "Enzyme forward")
```

See the `ADRegistry` docstring for the full contract.

## Installation

The package is not yet registered in the General registry. Until it is, depend
on it from a test environment via a `[sources]` git pin:

```toml
[sources]
EpiAwareTestUtils = {url = "https://github.com/EpiAware/EpiAwareTestUtils.jl", rev = "main"}
```

## Contributing

This package follows [ColPrac](https://github.com/SciML/ColPrac) and the
[SciML style](https://github.com/SciML/SciMLStyle).
