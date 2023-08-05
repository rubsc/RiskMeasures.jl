module RiskMeasures

using JuMP, LinearAlgebra, Ipopt, Distributions, QuadGK, Test

include("helper.jl")
include("basic_RM.jl")
include("valueRisk.jl")
include("genRM.jl")

export CTE, EVaR, EVaR2, Expectation, mSD, pnorm, ontoSimplex, goldenSearch, VaR, AVaR,
        entropic, meanVariance, meanDeviation, meanSemiVariance, meanSemiDevi,spectral, GenCoherent,
        GenConvex, checkSpectral, distortion, 
        add_expr, math_expr
end
