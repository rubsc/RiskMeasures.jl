using Documenter
using riskMeasures

push!(LOAD_PATH,"../src/")
makedocs(sitename="riskMeasures.jl Documentation",
         pages = [
            "Home" => "index.md",
            "Tutorials" => "tutorial.md",
            "Function Library" => "library.md",
         ],
         format = Documenter.HTML(prettyurls = false)
)
# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/rubsc/riskMeasures.jl.git",
    devbranch = "main"
)