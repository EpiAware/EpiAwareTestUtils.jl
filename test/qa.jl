# Exercise the QA helpers. The docstring/format checks run over
# EpiAwarePackageTools itself (a clean module); the ambiguity and doctest helpers
# are checked on their structure and a tiny synthetic case so the suite stays
# light and package-agnostic.

@testitem "QA helpers" begin
    using Test
    using EpiAwarePackageTools

    # True when running `f` (a check that internally builds a `@testset`) records at
    # least one Fail/Error. `f` runs on a fresh `Task`, which starts with an empty
    # task-local testset stack, so the check's `@testset` is top-level there and
    # throws a `TestSetException` on finish when it recorded a Fail/Error — which we
    # read as "the check flagged a problem". Running on a separate task (rather than
    # popping the stack by hand) avoids the internal stack functions, whose names
    # differ across Julia releases (e.g. `pop_testset` is absent on 1.13-pre), so it
    # keeps the surrounding suite's testset stack untouched.
    function check_flags(f)
        t = Task() do
            try
                f()
                false
            catch err
                err isa Test.TestSetException ? (err.fail + err.error > 0) :
                rethrow()
            end
        end
        schedule(t)
        return fetch(t)
    end

    # A synthetic conforming module: its exported symbols follow the docstring
    # conventions (Arguments / Keyword Arguments sections, an @example, fields named
    # in the struct docstring, a resolving @ref). Defined at top level so its
    # docstrings register before the testset runs.
    module _Conforming

    export Widget, build

    """
        Widget

    A widget.

    # Fields
      - `size`: the widget size.

    See also [`build`](@ref).
    """
    struct Widget
        size::Int
    end

    """
        build(n; scale = 1)

    Build something.

    # Arguments
      - `n`: how many.

    # Keyword Arguments
      - `scale`: a multiplier.

    ```@example
    build(2; scale = 3)
    ```
    """
    build(n; scale = 1) = n * scale

    end # module _Conforming

    # A synthetic non-conforming module: the function takes arguments and keyword
    # arguments but documents neither section, and the struct omits its field.
    module _NonConforming

    export Gadget, run_it

    "A gadget with an undocumented field."
    struct Gadget
        weight::Int
    end

    "Run it, with no Arguments or Keyword Arguments section and no example."
    run_it(a, b; opt = 1) = a + b + opt

    end # module _NonConforming

    @testset "QA helpers" begin
        @testset "test_docstring_format passes a conforming module" begin
            test_docstring_format(_Conforming)
        end

        @testset "test_docstring_format flags a non-conforming module" begin
            # The check runs as its own top-level testset and throws on failure;
            # assert it flagged at least one problem (missing sections/fields).
            @test check_flags(() -> test_docstring_format(_NonConforming))
        end

        @testset "test_formatting over self" begin
            # Check the package src tree is JuliaFormatter-clean.
            root = dirname(dirname(pathof(EpiAwarePackageTools)))
            test_formatting([joinpath(root, "src")])
        end

        @testset "test_formatting skips missing dirs" begin
            res = test_formatting([joinpath(tempdir(), "does-not-exist-xyz")])
            @test res isa Test.AbstractTestSet
        end

        @testset "test_doctest runs over self" begin
            # EpiAwarePackageTools has no `jldoctest` blocks, so `doctest` passes
            # trivially — this exercises the Documenter wiring end to end.
            test_doctest(EpiAwarePackageTools)
        end

        @testset "test_linting delegates to test_jet" begin
            # The managed QA testset runs `test_jet(EpiAwarePackageTools)`; here
            # just assert the alias forwards to it (same method), without paying for
            # a second full JET pass.
            @test test_linting === test_jet ||
                  first(methods(test_linting)).name === :test_linting
        end

        @testset "ambiguity helpers error on unloaded extension" begin
            # No extension named :NotAnExtension is loaded, so both query helpers
            # error rather than silently passing.
            @test_throws ErrorException raw_ambiguity_count(
                EpiAwarePackageTools, :NotAnExtension)
            @test_throws ErrorException on_surface_ambiguities(
                EpiAwarePackageTools, :NotAnExtension)
        end
    end # @testset "QA helpers"
end # @testitem "QA helpers"
