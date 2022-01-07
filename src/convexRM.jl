# convex risk measures and other similar objects


""" Solving the optimization problem associated with evaluating EVaR as well
	as providing the dual variables

	min (β+log Ee^(t*Y)	)/t  for t>0

	Here with goldenSearch Algorithm

"""
function entropic(theta::Float64,states, prob)
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