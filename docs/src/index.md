# EpiAwareTestUtils.jl

Shared, package-agnostic test utilities for
[EpiAware](https://github.com/EpiAware) Julia packages.

The package collects the test scaffolding that EpiAware packages would
otherwise each copy: standard quality checks over a target module, and an
AD-gradient harness that checks a package's AD backends against a ForwardDiff
reference. Package-specific fixtures stay in each package; this package supplies
only the reusable run logic.

## Package-quality wrappers

```julia
using EpiAwareTestUtils

test_aqua(MyPackage)
test_explicit_imports(MyPackage; ignore = (:SomeInternal,))
test_jet(MyPackage; env = joinpath(@__DIR__, "jet"))
```

## AD-gradient harness

A package supplies an AD-fixture registry satisfying the [`ADRegistry`](@ref)
contract; the harness runs the working scenarios and marks the rest broken:

```julia
using EpiAwareTestUtils

test_working_backend(MyPackageADFixtures, "ReverseDiff")
test_partial_backend(MyPackageADFixtures, "Enzyme forward")
```

See the [API](@ref) page for the full reference.
