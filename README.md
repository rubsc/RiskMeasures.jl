# riskMeasures

[![Build Status](https://github.com/rubsc/riskMeasures.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/rubsc/riskMeasures.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/rubsc/riskMeasures.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/rubsc/riskMeasures.jl)


A Julia package providing several well-known coherent risk measures for finite dimensional random variables.

The following risk measures are provided either explicitly or via a primal representation.

* Average Value at risk
* mean Semi deviation
* Entropic Value-at-Risk


## General representation of coherent risk measures

A general coherent risk measure $\rho$ on paired topological spaces can be expressed as

<div style="text-align: center;">
  <img src="https://latex.codecogs.com/svg.latex?\Large&space;\rho(Y)=\sup\{\mathbb{E}YZ,Z\geq0,\mathbb{E}Z=1,F(Z)\leqC\}" title="coherentRiskMeasure" />
</div>

where F(Z) is a positively homegenouos and convex function and c is a parameter. The user can specify F in the form G(sum(H(Z))) where F and H are straightforward expressions. Note that the sum operator must be included as + together with loops as JuMP will not work with expressions containing sums and similar functions. This limits the flexibility of the covered risk measures but still covers most typicall examples. 
If further capabilities are needed, the functions can be changed directly. 


