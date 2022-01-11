# Inside make.jl
push!(LOAD_PATH,"../src/")
using riskMeasures
using Documenter

makedocs(
         sitename = "riskMeasures.jl",
         modules  = [riskMeasures],
         pages=[
                "Home" => "index.md"
               ])
               
deploydocs(;
    repo="github.com/rubsc/riskMeasures.jl",
)