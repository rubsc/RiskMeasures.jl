# RiskMeasures

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://rubsc.github.io/RiskMeasures.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://rubsc.github.io/RiskMeasures.jl/dev/)
[![Build Status](https://github.com/rubsc/RiskMeasures.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/rubsc/RiskMeasures.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Build Status](https://travis-ci.com/rubsc/RiskMeasures.jl.svg?branch=master)](https://travis-ci.com/rubsc/RiskMeasures.jl)
[![Coverage](https://codecov.io/gh/rubsc/RiskMeasures.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/rubsc/RiskMeasures.jl)


`RiskMeasures.jl` is a Julia package providing several well-known coherent risk measures for finite dimensional random variables as well as some special distributions.

The following risk measures are provided either explicitly or via a primal representation.

* Average Value at risk and Conditional Tail Expectation
* Entropic Value-at-Risk
* mean Semi-deviation
* Value-at-Risk
* Entropic risk measure
* mean Variance of order p
* mean Deviation from target of order p
* mean Semi-Variance
* mean Semi-Deviation from target of order p

The following general classes can also be used:

* spectral risk measures
* distortion risk measures
* coherent risk measures based on dual representation
* convex risk measures based on dual representation
 
 *N/B* - _This package is actively developed and therefore new improvements and new features are continuously added._


## Installation

To get the latest development version call:

```julia
import Pkg;
Pkg.add("https://github.com/rubsc/RiskMeasures.jl")
```

To use `riskMeasures.jl`, you need to have Julia >= v1.0. This package was developed in Julia 1.9.2, and has been tested for Julia >= v1.9.2 in Linux, OSX and Windows.

## Documentation

The STABLE documentation of RiskMeasures.jl is available [here](https://rubsc.github.io/RiskMeasures.jl/stable/). Here you can get the description of the various functions in the package and also different examples for the different features.

## Example of Usage


### Spectral risk measures and distortion risk measures

Note that the class of spectral risk measures is equivalent with the class of distortion risk measures. They differ only in representation. 
Spectral risk measures operate on quantile functions which are distorted by an increasing density. 
Distortion risk measures distort the cumulative distribution functions. 

For a brief example of how to use a spectral risk measure consider
```julia
states = [0 1]
prob = [0.2 0.8]

spec(x) = 2.0*x

spectral(spec, states, prob)
```
The equivalent distortion risk measure would be:
```julia
states = [0 1]
prob = [0.2 0.8]

dist(x) = x^2 # derivative of dist == spec

distortion(dist, states, prob)
```

## General representation of coherent risk measures

A general coherent risk measure $\rho$ on paired topological spaces can be expressed as

<div style="text-align: center;">
  <img src="https://latex.codecogs.com/svg.latex?\Large&space;\rho(Y)=\sup\{\mathbb{E}YZ,Z\geq0,\mathbb{E}Z=1,F(Z)\leq%20C\}" title="coherentRiskMeasure" />
</div>

where F(Z) is a positively homegeneous and convex function and `c` is a parameter. The user can specify `F` in the form `G(sum(H(Z)))` where `F` and `H` are straightforward expressions. 
Note that the sum operator must be included as `+` together with loops as JuMP will not work with expressions containing sums and similar functions. This limits the flexibility of the covered risk measures but still deals with the most typical examples. 
If further capabilities are needed, the functions can be changed directly. 



 ## ToDo:
 add tutorial on coherent/convex risk measures
  --> how to construct sets
  --> add visualization for sets
  --> discuss properties of risk measures
  --> add dynamic risk measures based BSDEs