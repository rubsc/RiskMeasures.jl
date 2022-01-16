
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
""" An implementation of the Mean semi-deviation risk measure of
	order p. This is a coherent risk measure which can be nested by
	adjusting the risk level β → β⋅√(Δt)

	mSD_β^p(Y) = EY + β ⋅ ||(Y-EY)_+||_p
"""
function mSD(beta,p,states,prob)
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


""" An implementation of the Value-at-Risk at level α for 
a given discrete distribution specified by

states
prob
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

""" An implementation of the Conditional Tail-Value-at-Risk at level α for 
a given discrete distribution specified by

states
prob
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