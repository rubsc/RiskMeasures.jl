
# Includes basic risk measures and statistics without optimization

"""
Expectation(states,prob)

Computes the expectation for the random variable ``Y`` with values given by `states` under
the probability measure ``Q`` given by `prob`:

```math
\\mathbb{E} Y = states \\cdot prob
```
"""
function Expectation(states,prob)
if prob == 0
    prob = ones(length(states))./ length(states)
end
return(dot(states,prob))
end



#########################################################
#Mean Semi-deviation
#########################################################
""" 
mSD(states,prob,beta,p)

implements the mean semi-deviation of order `p` which is a coherent risk measure defined by
```math
mSD_\\beta^p (Y) = \\mathbb{E} Y  + \\beta \\lvert \\left( Y - \\mathbb{E}Y \\right)_+ \\rvert_p,
```
for the random variable ``Y`` defined by `states` and `prob`.
"""
function mSD(states,prob,beta,p)
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


###################################
""" 
VaR(states,prob,alpha)

implements the Value-at-Risk at level ``\\alpha`` defined by
```math
VaR_\\alpha (Y) = \\argmin_x \\left{ x\\in \\mathbb{R} : F_Y(x) \\geq \\alpha \\right },
```
for the random variable ``Y`` defined by `states` and `prob`.
"""
function VaR(states,prob,alpha)
    # look for smallest x such that  P(-states <= x) >alpha , i.e.
    ind = sortperm(states[1:length(states)])
    states = states[ind]; probs = prob[ind];
    probs2 = prob
    for i=length(states):-1:2
        if(states[i] == states[i-1])
            probs2[i] = probs2[i] + probs2[i-1]
        end
    end

    bla = unique(i -> states[i], length(states):-1:1)
    probs3 = probs2[bla]
    states2 = states[bla]
    d = DiscreteNonParametric(states2, probs3)
    return(quantile(d,alpha))
end

""" 
CTE2(states,prob,alpha)

implements the Conditional Value-at-Risk at level ``\\alpha`` defined by
```math
CTE_\\alpha (Y) = VaR_\\alpha(Y) + \\frac{1}{1-\\alpha} \\mathbb{E} \\left( Y- VaR_\\alpha (Y) \\right)_+ ,
```
for the random variable ``Y`` defined by `states` and `prob`.
"""
function CTE2(states,prob,alpha)
    tmp = VaR(states,prob,alpha)
    tmp2 = tmp + 1/(1-alpha) * dot(prob, max.(states .- tmp,0))
    return sum(tmp2)
end




""" Entropic risk measure 
	as providing the dual variables

	t* log Ee^(Y/t)  for t>0

"""
function entropic(theta::Float64,states, prob)
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


""" Mean Variance risk Measure

"""
function meanVariance(c::Float64,states, prob)
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



""" Mean Deviation risk Measure of order p

"""
function meanDeviation(c::Float64,p::Float64,states, prob)
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




""" Mean-upper-semivariance from a target

"""
function meanSemiVariance(c::Float64,target::Float64,states, prob)
    if c<0
        return(nothing)
    end
	if sum(prob) == 0
		prob = ones(length(states))./ length(states)
        # improve this with isprob and onto simplex?
	end
	
    tmp1 = dot(states,prob)
    tmp2 = pnorm(2,prob, max.(states .- target,0))^2;
	return(tmp1 + c*tmp2) 
end



""" Mean-upper-semideviation of order p from a target

"""
function meanSemiDevi(c::Float64,target::Float64,p::Float64,states, prob)
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