# utility based risk measures --> build check for utility functions





""" 
    spectral(states, prob, spec)
    
implements the spectral risk measure    
```math
\\rho(Y) := \\int_0^1 spec(x) \\cdot F_Y^{-1}(\\alpha) d\\alpha,
```
where ``Y`` is the discrete random variable defined by `states` and `prob` and ``spec(\\cdot)`` denotes the spectral function which is

+ increasing
+ integrates to 1.
"""
function spectral(states, prob,spec)
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

""" 
    distortion(states, prob,dist)
    
implements the distortion risk measure    
```math
\\rho(Y) := \\int_0^\\infty 1- dist(F_Y(x)) dx - \\int_{-\\infty}^0 dist(F_Y(x) dx,
```
where ``Y`` is the discrete random variable defined by `states` and `prob` and ``dist(\\cdot)`` denotes the distortion function which is
a right-continuous distribution function.
"""
function distortion(states, prob,dist)
    d = DiscreteNonParametric(states, prob)

    minState = minimum(states)-1; maxState = maximum(states)+1;

    integral1, err1 = quadgk(x -> dist(cdf(d,x)), minState, 0, rtol=1e-10)
    integral2, err2 = quadgk(x -> 1-dist(cdf(d,x)), 0, maxState, rtol=1e-10)
    return (integral2 - integral1)
end


"""
    GenCoherent(states, prob,conds)

implements a generic coherent risk measure based on the dual representation
```math
\\rho(Y) := \\sup \\left( \\mathbb{E} YZ \\colon \\mathbb{E}Z=1, Z\\geq 0, F(Z) \\leq c \\right),
```
where ``F(\\cdot)`` is a positively homegeneous and convex function and c is a constant.     
"""
function GenCoherent(states, prob,conds)
    
# For testing : 
 #states = [1 2 3]; prob = [0.3 0.4 0.3]
 #o1 = :( (Y)^2 *p)
 #o2 = :(sqrt)
 #oJoin = :+
 #conds = [o1 oJoin o2]

    n = length(prob); Zopt = ones(n);
    o1 = conds[1]; o2 = conds[3]
    oJoin = conds[2]


    EV = Model(with_optimizer(Ipopt.Optimizer, print_level=2))
    @variable(EV, 0 <= Z[1:n] )
    EV[:Z]

    o_tmp = :(0)
    for i=1:n
        global Y = Z[i]
        global p = prob[i]
        bla = eval(o1)
        o_tmp = math_expr(oJoin,o_tmp, bla)
    end
    o_tmp = math_expr(o2,o_tmp) # if no operation shall be carried out a unary plus o2 = :+ suffices

    add_NL_constraint(EV, :($(o_tmp) <= 2))
    @NLobjective(EV, Max, sum(states[i]*Z[i]*prob[i] for i in 1:n) )
    @constraint(EV, normalized, dot(prob,Z)==1)

    JuMP.optimize!(EV)
    EVaR = JuMP.objective_value(EV)
    ZOpt = JuMP.value.(Z)
	
    return(EVaR, ZOpt)
	
end

"""
    GenConvex(states, prob, conds, conjugate)

implements a generic coherent risk measure based on the dual representation
```math
\\rho(Y) := \\sup \\left( \\mathbb{E} YZ - conjugate(Z) \\colon \\mathbb{E}Z=1, Z\\geq 0 \\right),
```
where ``conjugate(\\cdot)`` is a and convex function and conds describes the domain of ``conjugate(\\cdot)``.     
"""
function GenConvex(states, prob,conds,conjugate)
    # based on the dual representation a set of conditions can be set and
    # using IpOpt + JuMP the risk measure can be considered. 

	n = length(prob); Zopt = ones(n);
    o1 = conds[1]; o2 = conds[3]
    oJoin = conds[2]


    EV = Model(with_optimizer(Ipopt.Optimizer, print_level=2))
    @variable(EV, 0 <= Z[1:n] )
    
    #register(EV, :conjugate,1,conjugate, autodiff=true)

    o_tmp = :(0)
    o_tmp2 = :(0)
    for i=1:n
        # First the set construction
        global Y = Z[i]
        global p = prob[i]
        bla = eval(o1)
        o_tmp = math_expr(oJoin,o_tmp, bla)

        #Now the convex conjugate
        Conj = eval(conjugate)
        o_tmp2 = math_expr(:+,o_tmp2, Conj)
    end
    o_tmp = math_expr(o2,o_tmp) # if no operation shall be carried out a unary plus o2 = :+ suffices

    #add_NL_constraint(EV, :($(o_tmp) <= 2))
    @NLobjective(EV, Max, sum(states[i]*Z[i]*prob[i] for i in 1:n) - 0.5*sum(Z[i]^2 for i in 1:n) ) # - conjugate(Z) should be added
    @constraint(EV, normalized, dot(prob,Z)==1)

    JuMP.optimize!(EV)
    EVaR = JuMP.objective_value(EV)
    ZOpt = JuMP.value.(Z)
	
    #return(EVaR, ZOpt)
    return(nothing)
end
