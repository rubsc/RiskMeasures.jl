
# For testing : 
# states = [1 2 3]; prob = [0.3 0.4 0.3]

# INPUT NEEDS TO BE SOMETHING LIKE THIS:

o1 = :( (Y)^2 *p)
o2 = :sqrt
conds = [o1 o2]

states = [1 2 3]; prob = [0.3 0.4 0.3];


function expressionTest(conds,states, prob)
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