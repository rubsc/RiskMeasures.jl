using riskMeasures
using Test

@testset "helper.jl" begin
    # Write your tests here.
    @test pnorm(2,[0.5 0.5],[1 2]) ≈ 1.5811 atol=0.01

    @test ontoSimplex([0.3 0.3 0.3 0.3]) == [0.25 0.25 0.25 0.25]
    @test ontoSimplex([-0.3 -0.3 0.3 0.3]) == [0.0 0.0 0.5 0.5]
end
