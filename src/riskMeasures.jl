module riskMeasures

# Write your package code here.


using JuMP, LinearAlgebra, Ipopt, Distributions



include("helper.jl")
include("basic_RM.jl")
include("valueRisk.jl")

export CTE, EVaR, EVaR2, Expectation, mSD, pnorm, ontoSimplex, goldenSearch, VaR, CTE2

end
