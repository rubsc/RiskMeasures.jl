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
    states = [1 2 3 4]; prob = [0.2 0.4 0.2 0.2]
    @test Expectation([1 2 3 4],0) == sum([1 2 3 4])/4
    @test Expectation(states,prob) == 0.2*1 + 0.4*2 + 0.2*3 + 0.2*4

    @test mSD(0.0,2,states,prob) == Expectation(states,prob)
    @test mSD(1.0,2,states,prob) ≈ 3.16419 atol = 0.001
    @test mSD(1.0,2,states,prob) < mSD(1.0,3,states,prob)

    @test VaR(states,probs,0.0) == min(states)
end