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

$$
\begin{align}
  \tag{1.1}
  \rho(Y) = \frac{4}{3}\pi r^3
\end{align}
$$


A generic implementation of the dual representation is also provided. However, the user has to construct the set explicitly himself. 
