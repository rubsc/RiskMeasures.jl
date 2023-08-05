
# Includes basic risk measures and statistics without optimization

"""
    Expectation(states,prob)

Computes the expectation for the random variable ``Y`` with values given by `states` under
the probability measure ``Q`` given by `prob`:

```math
\\mathbb{E} Y = states \\cdot prob
```
"""
function Expectation(states::Vector{Float64},prob::Vector{Float64})
if sum(prob) == 0.0
    prob = ones(length(states))./ length(states)
end
return(dot(states,prob))
end


function Expectation(d::Distribution)
    return(mean(d))
end



"""
    entropic(states, prob,theta::Float64)

implements the entropic risk measure defined as
```math
\\rho_\\theta(Y) = \\theta \\cdot \\log \\mathbb{E} e^{\\frac{Y}{\\theta}},
```
where ``\\theta`` is greater 0 and ``Y`` is the random variable defined by `states` and `prob`.
"""
function entropic(states::Vector{Float64}, prob::Vector{Float64},theta::Float64)
    if theta <= 0
        return(nothing)
    end
	if sum(prob) == 0
		prob = ones(length(states))./ length(states)
        # improve this with isprob and onto simplex?
	end
	
    w = states./theta
    offset = maximum(w)
    we = exp.(w .- offset)
    s = dot(prob, we)
    w = log(s) + offset
    tmp = theta*w
	
	return(tmp) 
end


function entropic(d::Distribution,t::Float64)
    if t <= 0
        return(nothing)
    end
	tmp = mgf(d,1.0 ./t);
    return ( t* log(tmp))
end


#########################################################
#Mean Semi-deviation
#########################################################
""" 
    mSD(states,prob,beta::Float64,p::Float64)

implements the mean semi-deviation of order `p` which is a coherent risk measure defined by
```math
mSD_\\beta^p (Y) = \\mathbb{E} Y  + \\beta \\lvert \\left( Y - \\mathbb{E}Y \\right)_+ \\rvert_p,
```
for the random variable ``Y`` defined by `states` and `prob`.
"""
function mSD(states::Vector{Float64},prob::Vector{Float64},beta::Float64,p::Float64)
	if sum(prob) == 0
		prob = ones(length(states))./ length(states)
	end

	if beta == 0.0
		mSD = dot(prob, states)
	else
		tmp = max.(states .- dot(prob,states),0)
		mSD = dot(prob,states) + beta*pnorm(p,prob,tmp)
	end
	return(mSD)
end


"""
    meanVariance(states, prob,c::Float64)

implements the mean Variance risk measure defined by
```math
\\rho_c(Y) := \\mathbb{E}Y + c \\cdot \\mathbb{E} \\left( Y- \\mathbb{E}Y)^2 \\right),
```
where ``c >0`` and ``Y`` is the random variable defined by `states` and `prob`.
"""
function meanVariance(states::Vector{Float64}, prob::Vector{Float64},c::Float64)
    if c<0
        return(nothing)
    end
	if sum(prob) == 0
		prob = ones(length(states))./ length(states)
        # improve this with isprob and onto simplex?
	end
	
    tmp1 = dot(states,prob)
    tmp2 = dot(prob, (states .- tmp1).^2);
	return(tmp1 + c*tmp2) 
end


"""
    meanDeviation(states, prob,c::Float64,p::Float64)

implements the mean deviation risk measure of order ``p\\geq 1`` defined by
```math
\\rho_c^p(Y) := \\mathbb{E}Y + c \\cdot \\lVert \\left( Y- \\mathbb{E}Y \\right)^2 \\rVert_p,
```
where ``c >0`` and ``Y`` is the random variable defined by `states` and `prob`.
"""

function meanDeviation(states::Vector{Float64}, prob::Vector{Float64},c::Float64,p::Float64)
    if c<0
        return(nothing)
    end
    if p<1.0
        return(nothing)
    end
	if sum(prob) == 0
		prob = ones(length(states))./ length(states)
        # improve this with isprob and onto simplex?
	end
	
    tmp1 = dot(states,prob)
    tmp2 = pnorm(p,prob, states .- tmp1);
	return(tmp1 + c*tmp2) 
end



"""
    meanSemiVariance(states, prob,c::Float64,t::Float64)

implements the mean upper-semi variance risk measure from a target ``t`` defined by
```math
\\rho_{c,t}(Y) = \\mathbb{E}Y + c \\cdot \\mathbb{E} \\left( Y - t \\right)^2_+ ,
```
where ``c >0`` and ``Y`` is the random variable defined by `states` and `prob`.
"""
function meanSemiVariance(states::Vector{Float64}, prob::Vector{Float64},c::Float64,t::Float64)
    if c<0
        return(nothing)
    end
	if sum(prob) == 0
		prob = ones(length(states))./ length(states)
        # improve this with isprob and onto simplex?
	end
	
    tmp1 = dot(states,prob)
    tmp2 = pnorm(2,prob, max.(states .- t,0))^2;
	return(tmp1 + c*tmp2) 
end



"""
    meanSemiDevi(states, prob,c::Float64,target::Float64,p::Float64)

implements the mean upper-semi variance risk measure of order ``p \\geq 1`` from a target ``t`` defined by
```math
\\rho_{c,t}^p(Y) = \\mathbb{E}Y + c \\cdot \\lVert \\left( Y - t \\right)_+ \\rVert_p ,
```
where ``c >0`` and ``Y`` is the random variable defined by `states` and `prob`.
"""
function meanSemiDevi(states::Vector{Float64}, prob::Vector{Float64},c::Float64,target::Float64,p::Float64)
    if c<0
        return(nothing)
    end
    if p<1.0
        return(nothing)
    end
	if sum(prob) == 0
		prob = ones(length(states))./ length(states)
        # improve this with isprob and onto simplex?
	end
	
    tmp1 = dot(states,prob)
    tmp2 = pnorm(p,prob, max.(states .- target,0));
	return(tmp1 + c*tmp2) 
end
