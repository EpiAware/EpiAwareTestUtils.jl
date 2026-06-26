#!/usr/bin/env julia
# MANAGED by EpiAwarePackageTools.scaffold — do not edit by hand.
#
# JET static-analysis runner, run in this isolated environment so JET's
# JuliaSyntax pin does not clash with the main test deps.
#
#   julia --project=test/jet test/jet/runtests.jl

using JET
using EpiAwarePackageTools

JET.test_package(EpiAwarePackageTools; target_modules = (EpiAwarePackageTools,))
