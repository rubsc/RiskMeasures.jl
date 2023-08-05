using RiskMeasures
using Test

@testset "helper.jl" begin
    # Write your tests here.
    @test pnorm(2,[0.5 0.5],[1 2]) ≈ 1.5811 atol=0.01

    @test ontoSimplex([0.3 0.3 0.3 0.3]) == [0.25 0.25 0.25 0.25]
    @test ontoSimplex([-0.3 -0.3 0.3 0.3]) == [0.0 0.0 0.5 0.5]
    @test goldenSearch(x -> x^2, 1.0)[2] < 1E-16
    @test goldenSearch(x -> x^2, -1.0)[2] < 1E-16

    @test checkSpectral(x -> x) == false
    @test checkSpectral(x -> 2 .- 2 .*x) == false
    @test checkSpectral(x -> 0 .*x .+ 1.0) == true

    @test eval(math_expr(:+,1,2)) == 3
    @test eval(math_expr(:+,1)) == 1
    @test eval(add_expr(1, 2)) == 3
end

@testset "basic_RM.jl" begin
    # Write your tests here.
    states = [1.0, 2.0, 3.0, 4.0]; prob = [0.2, 0.4, 0.2, 0.2]
    @test Expectation([1.0, 2.0, 3.0, 4.0],[0.0, 0.0, 0.0, 0.0]) == sum([1 2 3 4])/4
    @test Expectation(states,prob) == 0.2*1 + 0.4*2 + 0.2*3 + 0.2*4

    @test mSD(states,prob,0.0,2.0) == Expectation(states,prob)
    @test mSD([1.0, 1.0], [0.0, 0.0],0.0,2.0) == 1
    @test mSD(states,prob,1.0,2.0) ≈ 3.16419 atol = 0.001
    @test mSD(states,prob,1.0,2.0) < mSD(states,prob,1.0,3.0)

    @test VaR(states,prob,0.0) == minimum(states)
    @test CTE(states,prob,0.0) == Expectation(states,prob)
end


@testset "valueRisk.jl" begin
    # Write your tests here.
    states = [1.0, 2.0, 3.0, 4.0]; prob = [0.2, 0.4, 0.2, 0.2]
    
    @test EVaR2(states, prob,0.0)[1] == Expectation(states,prob)
    @test EVaR2(states, prob,0.5)[1] ≈ 3.413183 atol = 0.001
    @test EVaR2([1.0, 1.0], [0.0, 0.0],0.5)[1] == 0 
    @test EVaR(states, prob,0.0)[1] == Expectation(states,prob)
    @test EVaR(states, prob,0.5)[1] ≈ 3.413183 atol = 0.001
    @test EVaR([1.0, 1.0], [0.0, 0.0],0.5)[1] == 0.0
    @test EVaR(states, prob,5.5)[1] == maximum(states)
    @test AVaR(states,prob, 0.0)[1] == Expectation(states,prob)
    @test AVaR(states,prob, 0.5)[1] ≈ CTE(states,prob,0.5) atol = 0.0001
end


@testset "genRM.jl" begin
    # Write your tests here.
    states = [1.0, 2.0, 3.0, 4.0]; prob = [0.2, 0.4, 0.2, 0.2]

    
    @test entropic(states, prob,1.0) ≈ 2.91430 atol = 0.001
    @test entropic([1.0, 1.0], [0.0, 0.0],0.5) == 1.0
    @test entropic([1.0, 1.0], [0.0, 0.0],0.0) === nothing

    @test meanVariance([1.0, 1.0], [0.0, 0.0],-1.0) === nothing
    @test meanVariance([1.0, 1.0], [0.0, 0.0],1.0) == 1.0

    @test meanDeviation([1.0, 1.0], [0.0, 0.0],-1.0,2.0) === nothing
    @test meanDeviation([1.0, 1.0], [0.0, 0.0],1.0,2.0) == 1.0
    @test meanDeviation([1.0, 1.0], [0.0, 0.0],-1.0,0.5) === nothing
    @test meanDeviation([1.0, 1.0], [0.0, 0.0],1.0,0.5) === nothing

    @test meanSemiVariance([1.0, 1.0], [0.0, 0.0],1.0, 0.0) == 2.0
    @test meanSemiVariance([1.0, 1.0], [0.0, 0.0],-1.0, 0.0) === nothing

    @test meanSemiDevi([1.0, 1.0], [0.0, 0.0],1.0, 0.0, 2.0) == 2.0
    @test meanSemiDevi([1.0, 1.0], [0.0, 0.0],-1.0, 0.0, 2.0) === nothing
    @test meanSemiDevi([1.0, 1.0], [0.0, 0.0],1.0, 0.0, -2.0) === nothing

    @test spectral([0.0, 1.0], [0.2, 0.8], x -> 2.0*x) ≈ 0.96 atol = 0.0001
    @test spectral([0.0, 1.0], [0.2, 0.8], x -> x) === nothing

    @test distortion([0.0, 1.0], [1.0, 0.0], x -> x^2) == 0.0

    o1 = :( (Y)^2 *p); o2 = :sqrt; conds = [o1 :+ o2]; 
    states = [1.0, 2.0, 3.0]; prob = [0.3, 0.4, 0.3];
    #@test GenCoherent(states, prob,conds)[1] ≈ 3.0 atol = 0.0001

    #@test GenConvex(states, prob,conds,x->x) === nothing
end
