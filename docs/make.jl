using Documenter
using RiskMeasures

push!(LOAD_PATH,"../src/")
makedocs(sitename="RiskMeasures.jl Documentation",
         pages = [
            "Home" => "index.md",
            "Tutorials" => Any["basic.md",
				    "coherent.md",
				    "convex.md"
            ],
            "Function Library" => "library.md",
         ],
         format = Documenter.HTML(prettyurls = false)
)
# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/rubsc/RiskMeasures.jl.git",
    devbranch = "main"
)
