module riskMeasures

# Write your package code here.


using JuMP, LinearAlgebra, Ipopt



include("helper.jl")
include("basic_RM.jl")
include("valueRisk.jl")

export CTE, EVaR, EVaR2, Expectatio, mSD, pnorm, ontoSimplex, goldenSearch

end
