# Includes value at risk measures



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
	if sum(prob) == 0
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
				return( (beta.+ log(dot(prob,exp.(t.*states))))/t)
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


function AVaR(states,prob, alpha)
    var2 = dot(prob, (states .- dot(prob,states)).^2);
     #First trivial case
    if alpha == 0.0
        return(dot(prob, states))
  #Now set up optimization problem using goldenSearch
    else
       tOpt = sqrt.(2 *alpha/var2)
       EV = Model(with_optimizer(Ipopt.Optimizer, print_level=0))
		function objective1(t)
			return( t + 1/(1-alpha) * dot(prob, max.(states .- t,0)) )
		end
		register(EV, :objective1, 1, objective1, autodiff=true)
	    @variable(EV,t,start = tOpt)
		@NLobjective(EV, Min, objective1(t) )

		JuMP.optimize!(EV)
		AVaR = JuMP.objective_value(EV)
	    tOpt = JuMP.value(t)
    end
    return(AVaR, tOpt)
end