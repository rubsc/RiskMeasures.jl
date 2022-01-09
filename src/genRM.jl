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

    for coherent risk measures the conditions E(Z) = 1 and Z ≥ 0 are enforced.
    conds needs to be a real valued function F such that F(Z) ≤ 0.
    To obtain a coherent risk measure F should be positively homegeneous.
    
    
"""

# For testing : 
# states = [1 2 3]; prob = [0.3 0.4 0.3]

# INPUT NEEDS TO BE SOMETHING LIKE THIS:

function GenCoherent(conds,states, prob)
    # based on the dual representation a set of conditions can be set and
    # using IpOpt + JuMP the risk measure can be considered. 

    n = length(prob); Zopt = ones(n);
    o1 = conds[1]; o2 = conds[2]

    EV = Model(with_optimizer(Ipopt.Optimizer, print_level=2))
    @variable(EV, 0 <= Z[1:n] )
    EV[:Z]

    o_tmp = :(0)
    for i=1:n
        global Y = Z[i]
        global p = prob[i]
        bla = eval(o1)
        o_tmp = add_expr(o_tmp, bla)
        println(o_tmp)
    end
    o_tmp = math_expr(o2,o_tmp)

    add_NL_constraint(EV, :($(o_tmp) <= 2))
    @NLobjective(EV, Max, sum(states[i]*Z[i]*prob[i] for i in 1:n) )
    @constraint(EV, normalized, dot(prob,Z)==1)

    JuMP.optimize!(EV)
    EVaR = JuMP.objective_value(EV)
    ZOpt = JuMP.value.(Z)
	
    return(EVaR, ZOpt)
	
end


""" Convex risk measure
    Calculates a general convex risk measure based on duality representations 
"""
function GenConvex(conds,states, prob)
    # based on the dual representation a set of conditions can be set and
    # using IpOpt + JuMP the risk measure can be considered. 

	return(nothing)
end
