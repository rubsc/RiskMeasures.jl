# convex risk measures and other similar objects


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




""" Spectral risk measure
    Calculates spectral risk measure by numerically integrating product
    of quantile function and given spectral function. 

    The quantile function is the quantile function for the discrete distribution
    implied by states and prob vectors. 
"""
function spectral(spec,states, prob)
    # check that prob is probability vector
    # create distribution --> quantile function
    # integrate product of quantile function and given spectral function if possible

	return(nothing)
end


""" Coherent risk measure
    Calculates a general coherent risk measure based on duality representations
"""
function GenCoherent(conds,states, prob)
    # based on the dual representation a set of conditions can be set and
    # using IpOpt + JuMP the risk measure can be considered. 
    


    return(nothing)
	
end


""" Convex risk measure
    Calculates a general convex risk measure based on duality representations 
"""
function GenConvex(conds,states, prob)
    # based on the dual representation a set of conditions can be set and
    # using IpOpt + JuMP the risk measure can be considered. 

	return(nothing)
end
