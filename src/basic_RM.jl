
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


###################################


 

function VaR(states,probs,alpha)

    # look for smallest x such that  P(-states <= x) >alpha , i.e.

   



    #states = Tree0.state

    #probs = Tree0.probability

    ind = sortperm(states[1:length(states),1])



    states = states[ind]; probs = probs[ind];

    probs2 = probs



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





function CTE2(states,probs,alpha)



    tmp = VaR(states,probs,alpha)



    tmp2 = tmp + 1/(1-alpha) * dot(probs, max.(states .- tmp,0))

return sum(tmp2)



end