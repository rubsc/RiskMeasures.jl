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