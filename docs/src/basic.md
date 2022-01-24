```@meta
CurrentModule = riskMeasures
```

# Introduction

A risk measure is usually a real-valued function of random variable ``Y``. A risk measures is law-invariant if it only depends on the distribution of ``Y``. All risk measures discussed here are real-valued and law-invariant. A sensible risk measure should satisfy some more properties to express what we intuitively understand by risk. As to what the properties are sensible? This has been discussed ad nauseaum in the mathematical and economics literature. 

A particular useful class of risk measures are coherent risk measures and their relaxations: convex risk measures. The study of both classes have spawned numerous advances in convex analysis as well as optimization theory. More to the point they reflect (more or less) our intuitive understanding of risk aversion. 

A real-valued law-invariant coherent risk measures is a function ``f \\colon \\mathcal{L} \\to \\mathbb{R}`` satisfying
+ monotonicity
+ subadditivity
+ positive homogeneity
+ translation equivariance 



## Goal of `riskMeasures.jl`



### Introductory example



## Exported functions

Since we now understand the basic usage we present the exported functions that are visible to the user i.e., that are public. Notice that the first 2 arguments of any risk measure are the state and the probability vector or alternatively the distribution object. Afterwards there are any parameters the specific risk measures requires. 


1. AVaR
2. mSD
3. VaR
4. EVaR, EVaR2
5. VaR

