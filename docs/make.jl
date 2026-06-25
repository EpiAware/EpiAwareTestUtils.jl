using Pkg: Pkg
Pkg.instantiate()

using Documenter
using EpiAwareTestUtils

makedocs(;
    sitename = "EpiAwareTestUtils.jl",
    authors = "EpiAware contributors",
    modules = [EpiAwareTestUtils],
    pages = [
        "Home" => "index.md",
        "API" => "api.md"
    ],
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true"),
    warnonly = [:missing_docs]
)

deploydocs(;
    repo = "github.com/EpiAware/EpiAwareTestUtils.jl",
    devbranch = "main",
    push_preview = true
)
