using Test
using EpiAwareTestUtils

@testset "EpiAwareTestUtils" begin
    include("quality.jl")
    include("ad_harness.jl")
end
