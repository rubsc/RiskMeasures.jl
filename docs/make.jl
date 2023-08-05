using RiskMeasures
using Documenter

DocMeta.setdocmeta!(RiskMeasures, :DocTestSetup, :(using RiskMeasures); recursive=true)

makedocs(;
    modules=[RiskMeasures],
    authors="Ruben Schlotter",
    repo="https://github.com/rubsc/RiskMeasures.jl/blob/{commit}{path}#{line}",
    sitename="RiskMeasures.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://rubsc.github.io/RiskMeasures.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/rubsc/RiskMeasures.jl",
    devbranch="master",
)
