# General abstract formulation of risk measures
    # Spectral risk measures --> Done
    # Coherent risk measures based on dual formulation --> Concept done
    # Convex risk measures based on dual formulation    --> Concept done
    # utility based risk measures --> build check for utility functions






""" Spectral risk measure
    Calculates spectral risk measure by numerically integrating product
    of quantile function and given spectral function. 

    The quantile function is the quantile function for the discrete distribution
    implied by states and prob vectors. 
"""
function spectral(spec,states, prob)
    # spec(x) = x^2
    # spectral(spec, [1, 2], [0.2, 0.8])

    # ToDo: check that prob is probability vector

    #ToDo: check that spec is a spectral function
    if checkSpectral(spec) == false
        return(nothing)
    end



    # create distribution
    d = DiscreteNonParametric(states, prob)

    # approximate integral
    integral, err = quadgk(x -> quantile(d,x)*spec(x), 0, 1, rtol=1e-8)
	return(integral)
end


""" Coherent risk measure
    Calculates a general coherent risk measure based on duality representations
"""
function GenCoherent(conds,states, prob)
    # based on the dual representation a set of conditions can be set and
    # using IpOpt + JuMP the risk measure can be considered. 

    # conds is nx2 matrix. Each row is of the form function(x) <= b similar to:
    #tmp2 = [ x-> x^2 , x->x,  x->x^3, x-> x^2]

    #Zopt = ones(length(prob))
	#EV = Model(with_optimizer(Ipopt.Optimizer, print_level=0))
	#function objective_dual(Z)
    #    tmp = dot(prob,Z)
	#	return(tmp)
	#end
	#register(EV, :objective_dual, length(prob), objective_dual, autodiff=true)
	
    #@variable(EV,Z,start = Zopt)
	#@constraint(EV, Z .>=0)
    #@constraint(EV, dot(prob,Z)==1)
	#@NLobjective(EV, Min, objective1(t) )

	#JuMP.optimize!(EV)
	#EVaR = JuMP.objective_value(EV)
	#tOpt = JuMP.value(t)


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
