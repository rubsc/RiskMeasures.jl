# Includes value at risk measures




function CTE(v,p;rev=false)
    # filter has the "or approximately equalt to quantile" because
    # of floating point path might make the quantile slightly off from the right indexing 
    # e.g. if values should capture <= q, where q should be 10 but is calculated to be 
    # 9.99999...
    if rev
        q = StatsBase.quantile(v,1-p)
        filter = (v .<= q) .| (v .≈ q) 
    else
        q = StatsBase.quantile(v,p)
        filter = (v .>= q) .| (v .≈ q) 
    end    

    return sum(v[filter]) / sum(filter)

end





""" Solving the optimization problem associated with evaluating EVaR as well
	as providing the dual variables

	min (β+log Ee^(t*Y)	)/t  for t>0

	Here with goldenSearch Algorithm

"""
function EVaR2(beta::Float64,states, prob)
	if sum(prob) == 0
		prob = ones(length(states))./ length(states)
	end
	dualZ = zeros(length(states))
	esssup = maximum(states[vec(prob.>0.0)]) 
	varm = dot(prob, (states .- dot(prob,states)).^2)
	if beta == 0.0
		Fvalue = dot(prob, states)
		tOpt = 0.0
		dualZ = exp.(tOpt .*states)
	else
		if varm >0.0
			tOpt = sqrt.(2 *beta/varm)
			function objective1(t)
				t=max(t,0.0)
				w = states./t
				offset = maximum(w)
    			we = exp.(w .- offset)
    			s = dot(prob, we)
    			w = log(s) + offset
				tmp = t*beta + t*w
				#tmp = t*beta + t*log(dot(prob,exp.(states./t)))
				return(tmp)
			end
			out = goldenSearch(objective1,tOpt)
			tOpt = out[1]
			Fvalue = out[2]
		else
			tOpt = 0.0
			Fvalue = 0.0
			dualZ = esssup
		end
		#if Fvalue < esssup
			dualZ = exp.(tOpt .*states)
		#else
		#	Fvalue = esssup
		#	dualZ[states .>= esssup] .= 1
		#end
		dualZ = dualZ / dot(prob,dualZ)
	end
	return(Fvalue,tOpt,dualZ) # for numerical stability
end



""" Solving the optimization problem associated with evaluating EVaR as well
	as providing the dual variables

	min (β+log Ee^(t*Y)	)/t  for t>0

"""
function EVaR(beta,states, prob)
	if prob == 0
		prob = ones(length(states))./ length(states)
	end
	dualZ = zeros(length(states))
	esssup = maximum(states[prob.>0.0]) #error
	var = dot(prob, (states .- dot(prob,states)).^2 )
	if beta == 0.0
		EVaR = dot(prob, states)
		tOpt = 0
		dualZ = exp.(tOpt .*states)
	else
		if var >0
			tOpt = sqrt.(2 *beta/var)
			EV = Model(with_optimizer(Ipopt.Optimizer, print_level=0))
			function objective1(t)
				if t==0
					return(10000000000)
				else
					return( (beta.+ log(dot(prob,exp.(t.*states))))/t)
				end
			end
			register(EV, :objective1, 1, objective1, autodiff=true)

	    	@variable(EV,t,start = tOpt)
			@constraint(EV, t .>=0)
	    	@NLobjective(EV, Min, objective1(t) )

			JuMP.optimize!(EV)
			EVaR = JuMP.objective_value(EV)
	    	tOpt = JuMP.value(t)
		else
			tOpt = 0
			EVaR = 0
			dualZ = esssup
		end
		if EVaR < esssup
			dualZ = exp.(tOpt .*states)
		else
			EVaR = esssup
			#dualZ[states==esssup] .= 1
		end
		#dualZ = dualZ / dot(prob,dualZ)
	end
	return(EVaR,tOpt,dualZ)
end