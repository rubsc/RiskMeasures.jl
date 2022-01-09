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
  <img src="https://latex.codecogs.com/svg.latex?\Large&space;\rho(Y)= \suo \{ \mathbb{E} YZ,Z\geq0,\mathbb{E}Z=1, F(Z)\leq0\}" title="coherentRiskMeasure" />
</div>



A generic implementation of the dual representation is also provided. However, the user has to construct the set explicitly himself. 
