
# Includes basic risk measures and statistics without optimization

"""
Expectation(states,prob)

Compute the expectation for the random variable given by `states` under
the probability measure given by `prob`.
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
	if prob == 0
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
