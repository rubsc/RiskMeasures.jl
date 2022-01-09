
using JuMP, Ipopt


function add_expr(op1, op2)
    expr = Expr(:call, :+, op1, op2)
    return expr
end

function math_expr(op,op1)
    expr = Expr(:call, op, op1)
    return expr
end
function math_expr2(op,op1,op2)
    expr = Expr(:call, op, op1, op2)
    return expr
end

EV = Model(with_optimizer(Ipopt.Optimizer, print_level=2))
@variable(EV, 0 <= Z[1:3] )
EV[:Z]

o_tmp = :(0)

o1 = :( (Y)^2 )
for i=1:3
    global Y = Z[i]
    println(Y)
    
    #o1 = :($(Z[i])^2 * $(prob[i]))
    bla = eval(o1)
    #println(bla)
    o_tmp = add_expr(o_tmp, bla)
    println(o_tmp)
end

eval(o_tmp)

add_NL_constraint(EV, :($(o_tmp) <= 2))