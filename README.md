# EpiAwarePackageTools.jl

<!-- badges:start -->
| **Documentation** | **Build Status** | **Code Quality** | **License & DOI** | **Downloads** |
|:-----------------:|:----------------:|:----------------:|:-----------------:|:-------------:|
| [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://epiawarepackagetools.epiaware.org/stable/) [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://epiawarepackagetools.epiaware.org/dev/) | [![Test](https://github.com/EpiAware/EpiAwarePackageTools.jl/actions/workflows/test.yaml/badge.svg?branch=main)](https://github.com/EpiAware/EpiAwarePackageTools.jl/actions/workflows/test.yaml) [![codecov](https://codecov.io/gh/EpiAware/EpiAwarePackageTools.jl/graph/badge.svg)](https://codecov.io/gh/EpiAware/EpiAwarePackageTools.jl) | [![SciML Code Style](https://img.shields.io/static/v1?label=code%20style&message=SciML&color=9558b2&labelColor=389826)](https://github.com/SciML/SciMLStyle) [![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl) [![JET](https://img.shields.io/badge/%E2%9C%88%EF%B8%8F%20tested%20with%20-%20JET.jl%20-%20red)](https://github.com/aviatesk/JET.jl) | [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) | [![Downloads](https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Ftotal_downloads%2FEpiAwarePackageTools&query=total_requests&label=Downloads)](https://juliapkgstats.com/pkg/EpiAwarePackageTools) [![Downloads](https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Fmonthly_downloads%2FEpiAwarePackageTools&query=total_requests&suffix=%2Fmonth&label=Downloads)](https://juliapkgstats.com/pkg/EpiAwarePackageTools) |
<!-- badges:end -->

## Overview

EpiAwarePackageTools (the kit) is the scaffolding toolkit for
[EpiAware](https://github.com/EpiAware) Julia packages.
It supplies package-quality helpers (Aqua, JET, docstring and formatting
checks), an AD-gradient harness, benchmark reporting, and a `scaffold`/
`update` pair that writes and keeps in sync the standard CI, documentation
build, and test infrastructure a package would otherwise maintain by hand.
Package-specific content — the actual distributions, models, or fixtures —
stays in each adopting package; the kit only supplies the reusable machinery.

## Quick start

Add EpiAwarePackageTools to a package's test environment, then adopt the
standard tooling:

```julia
using EpiAwarePackageTools

scaffold(pkgdir(MyPackage))   # adopt the standard tooling once
update(pkgdir(MyPackage))     # re-apply managed files later, report drift
```

See
[Getting started](https://epiawarepackagetools.epiaware.org/stable/getting-started/)
for the full quickstart, and
[Infrastructure and template sync](https://epiawarepackagetools.epiaware.org/stable/getting-started/infrastructure/)
for what `scaffold`/`update` manage versus what stays package-owned.
Every exported helper is documented in the
[Public API](https://epiawarepackagetools.epiaware.org/stable/lib/public/)
reference.

## Documentation

- [Stable docs](https://epiawarepackagetools.epiaware.org/stable/) — the latest
  release.
- [Dev docs](https://epiawarepackagetools.epiaware.org/dev/) — the `main`
  branch.

## Installation

The package is not yet registered in the General registry. Until it is, depend
on it from a test environment via a `[sources]` git pin:

```toml
[sources]
EpiAwarePackageTools = {url = "https://github.com/EpiAware/EpiAwarePackageTools.jl", rev = "main"}
```

## Contributing

This package follows [ColPrac](https://github.com/SciML/ColPrac) and the
[SciML style](https://github.com/SciML/SciMLStyle).

## Supporting and citing

If you would like to support EpiAwarePackageTools, please star the repository —
such metrics help secure future funding.

If you use EpiAwarePackageTools in your work, please cite it:

```bibtex
@software{EpiAwarePackageTools_jl,
  author       = {Abbott, Sam and EpiAware contributors},
  title        = {EpiAwarePackageTools.jl},
  year         = {2025},
  doi          = {10.5281/zenodo.XXXXXXX},
  url          = {https://github.com/EpiAware/EpiAwarePackageTools.jl}
}
```

The DOI is a placeholder until the package is released to Zenodo.

## License

Released under the
[MIT License](https://github.com/EpiAware/EpiAwarePackageTools.jl/blob/main/LICENSE).
