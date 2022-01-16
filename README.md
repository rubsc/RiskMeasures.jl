# riskMeasures

[![Build Status](https://github.com/rubsc/riskMeasures.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/rubsc/riskMeasures.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/rubsc/riskMeasures.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/rubsc/riskMeasures.jl)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://rubsc.github.io/riskMeasures.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://rubsc.github.io/riskMeasures.jl/dev)

A Julia package providing several well-known coherent risk measures for finite dimensional random variables.


 ## ToDo:
 add tutorial on coherent/convex risk measures
  --> how to construct sets
  --> add visualization for sets
  --> discuss properties of risk measures
  --> add dynamic risk measures based BSDEs
 
 
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

## Spectral risk measures and distortion risk measures

Note that the class of spectral risk measures is equivalent with the class of distortion risk measures. They differe only in representation. 
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

where F(Z) is a positively homegenouos and convex function and c is a parameter. The user can specify F in the form G(sum(H(Z))) where F and H are straightforward expressions. Note that the sum operator must be included as + together with loops as JuMP will not work with expressions containing sums and similar functions. This limits the flexibility of the covered risk measures but still covers most typicall examples. 
If further capabilities are needed, the functions can be changed directly. 


