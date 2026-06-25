# Generic package-quality wrappers: Aqua, JET, and ExplicitImports over a
# target module. Each EpiAware package previously carried its own copy of these;
# the only per-package input is the module under test (and an ExplicitImports
# `ignore` list for unavoidably non-public imports).

using Test: @testset, @test, @test_skip

"""
    test_aqua(mod; kwargs...)

Run the standard Aqua.jl quality suite over `mod`.

Wraps the individual `Aqua.test_*` checks (unbound args, undefined exports,
project extras, stale deps, deps compat, undocumented names, piracies,
ambiguities) in one `@testset`. Keyword arguments forward to each check that
accepts them, so a package can relax a single check without re-listing the rest
(e.g. `test_aqua(MyPkg; ambiguities = false)` to skip the ambiguity check).

Aqua must be a dependency of the calling test environment.
"""
function test_aqua(mod::Module; ambiguities = true, unbound_args = true,
        undefined_exports = true, project_extras = true, stale_deps = true,
        deps_compat = true, undocumented_names = true, piracies = true)
    # `Aqua` is loaded at call time via `Base.require`, so its methods live in a
    # newer world age than this function; call them through `invokelatest` to
    # avoid a world-age error.
    Aqua = Base.require(Base.PkgId(
        Base.UUID("4c88cf16-eb10-579e-8560-4a9242c79595"), "Aqua"))
    return @testset "Aqua.jl: $(nameof(mod))" begin
        unbound_args && @testset "unbound args" begin
            Base.invokelatest(Aqua.test_unbound_args, mod)
        end
        undefined_exports && @testset "undefined exports" begin
            Base.invokelatest(Aqua.test_undefined_exports, mod)
        end
        project_extras && @testset "project extras" begin
            Base.invokelatest(Aqua.test_project_extras, mod)
        end
        stale_deps && @testset "stale deps" begin
            Base.invokelatest(Aqua.test_stale_deps, mod)
        end
        deps_compat && @testset "deps compat" begin
            Base.invokelatest(Aqua.test_deps_compat, mod)
        end
        undocumented_names && @testset "undocumented names" begin
            Base.invokelatest(Aqua.test_undocumented_names, mod)
        end
        piracies && @testset "piracies" begin
            Base.invokelatest(Aqua.test_piracies, mod)
        end
        ambiguities && @testset "ambiguities" begin
            Base.invokelatest(Aqua.test_ambiguities, mod)
        end
    end
end

"""
    test_explicit_imports(mod; ignore = ())

Run the ExplicitImports.jl conformance checks over `mod`.

Asserts there are no stale explicit imports, no implicit imports, that every
explicit import is public in its source module (with an `ignore` tuple of
`Symbol`s for unavoidable non-public imports, e.g. an upstream internal used by
an extension), and that imports come from their owning module.

ExplicitImports must be a dependency of the calling test environment.
"""
function test_explicit_imports(mod::Module; ignore::Tuple = ())
    # See `test_aqua` for why the checks go through `invokelatest`.
    EI = Base.require(Base.PkgId(
        Base.UUID("7d51a73a-1435-4ff3-83d9-f097790105c7"), "ExplicitImports"))
    return @testset "ExplicitImports: $(nameof(mod))" begin
        @test Base.invokelatest(
            EI.check_no_stale_explicit_imports, mod) === nothing
        @test Base.invokelatest(
            EI.check_no_implicit_imports, mod) === nothing
        @test Base.invokelatest(
            EI.check_all_explicit_imports_are_public, mod;
            ignore = ignore) === nothing
        @test Base.invokelatest(
            EI.check_all_explicit_imports_via_owners, mod) === nothing
    end
end

"""
    test_jet(mod; target_modules = (mod,), env = nothing,
        skip_experimental = true)

Run JET.test_package over `mod`.

JET is run in an isolated environment to keep its `JuliaSyntax` / dependency
pins from clashing with the rest of the test environment. Pass `env` as the path
to a project directory holding JET plus the package; that project's
`runtests.jl` is run in a subprocess and the test passes if it exits zero. When
`env` is `nothing` JET is loaded into the current environment and run directly
(simpler, but only safe when JET coexists with the test deps).

By default JET is skipped on experimental / pre-release Julia (and when
`JULIA_CI_EXPERIMENTAL=true`), where JET often lags the compiler.
"""
function test_jet(mod::Module; target_modules = (mod,),
        env::Union{Nothing, AbstractString} = nothing,
        skip_experimental::Bool = true)
    return @testset "JET: $(nameof(mod))" begin
        if skip_experimental && (VERSION >= v"1.13-" ||
            get(ENV, "JULIA_CI_EXPERIMENTAL", "false") == "true")
            @test_skip "JET skipped on experimental Julia"
            return nothing
        end
        if env === nothing
            # See `test_aqua` for why this goes through `invokelatest`.
            JET = Base.require(Base.PkgId(
                Base.UUID("c3a54625-cd67-489e-a8e7-0a5a0ff4e31b"), "JET"))
            Base.invokelatest(JET.test_package, mod;
                target_modules = target_modules)
        else
            Pkg = Base.require(Base.PkgId(
                Base.UUID("44cfe95a-1eb2-52ea-b672-e2afdf69b78f"), "Pkg"))
            isdir(env) && isfile(joinpath(env, "Project.toml")) ||
                error("JET env $env has no Project.toml")
            runner = joinpath(env, "runtests.jl")
            isfile(runner) || error("JET env $env has no runtests.jl")
            current = Base.active_project()
            Pkg.activate(env)
            Pkg.instantiate()
            Pkg.activate(current)
            result = run(
                pipeline(`$(Base.julia_cmd()) --project=$env $runner`,
                    stdout = stdout, stderr = stderr);
                wait = true)
            @test result.exitcode == 0
        end
    end
end
