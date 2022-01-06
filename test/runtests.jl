using riskMeasures
using Test

@testset "helper.jl" begin
    # Write your tests here.
    @test pnorm(2,[0.5 0.5],[1 2]) ≈ 1.5811 atol=0.01

    @test ontoSimplex([0.3 0.3 0.3 0.3]) == [0.25 0.25 0.25 0.25]
    @test ontoSimplex([-0.3 -0.3 0.3 0.3]) == [0.0 0.0 0.5 0.5]
    @test goldenSearch(x -> x^2, 1.0)[2] < 1E-16
end

@testset "basic_RM.jl" begin
    # Write your tests here.
    @test Expectation([1 2 3 4],0) == mean([1 2 3 4])

    @test ontoSimplex([0.3 0.3 0.3 0.3]) == [0.25 0.25 0.25 0.25]
    @test ontoSimplex([-0.3 -0.3 0.3 0.3]) == [0.0 0.0 0.5 0.5]
    @test goldenSearch(x -> x^2, 1.0)[2] < 1E-16
end