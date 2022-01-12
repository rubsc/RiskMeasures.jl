# Helper Functions for risk measures

function pnorm(p,prob,Y)
    tmp = transpose(Y)
    A = (dot(prob,tmp.^p))^(1/p)
    return A
end



function ontoSimplex(x)
    #projets given probabilities onto standard simplex to satisfy
    #sum(probabilities)= 1 and probabilities>= 0
    #works for co- and contravariant vectors
        C = x.<0                #replaces numbers under 0 with 0 in x (array)
        k = 1
        for t=1:length(x)
            if C[t] == 1
                x[t] = 0
                k = k+1
            end
        end
        tmp = sum(x)
        n = length(x)
        if tmp > 0
            x = x/tmp
        else
            #fehlt noch wird aber nicht benötigt
    
        end
        return x
    end

    


    

function goldenSearch(fun::Function,x1::Float64)
    #	fun: function to be minimized
    #	x1: initial value. x2: second guess (optional)
    #	example: goldenSearch(@(x)x^2, 1)
        if x1 < 0
            x2 = 1.05*x1-1e-4
        else
            x2 = 1.05*x1+1e-4
        end
        f1= fun(x1)
        f2= fun(x2)
        f3= -Inf
        phi= (sqrt(5)- 1)/2
        x3= (2+phi)*x1 - (1+phi)*x2
        while (f3 <= f1)		#finde zuerst zwei Punkte, wo dazwischen ein Minimum ist.
            x3= (2+phi)*x1 - (1+phi)*x2	#	extrapolate towards minimum by keeping golden ratio
            f3= fun(x3)
            if (f3 <= f1)		#maintain the relation f1 < f2
                x2= x1
                f2= f1
                x1= x3
                f1= f3
            else
                tmp= x1
                x1= x3
                x3= x2
                x2= tmp
                tmp= f1
                f1= f3
                f3= f2
                f2= tmp
                if (x1 > x3)
                    tmp= x1
                    x1= x3
                    x3= tmp
                end
                break
            end
        end
    #Es gelte jetzt x1 < x2 < x3 mit f1> f2 und f2< f3
    #while abs(x3- x1)> TolX*(1+ abs(x2))	%	mit golden Section search verbessere die Loesung
        #x3= (2+phi)*x1 - (1+phi)*x2
        found= false
        deltaX= Inf
        while found == false
            tmp= x3 - x1
            if tmp<deltaX  #   run to machine epsilon
                deltaX= tmp
            else
                found = true
            end
            if (x3-x2 > x2-x1)
                x = phi*x2 + (1-phi)*x3
            else
                x = (1-phi)*x1 + phi*x2
            end
            f= fun(x)
            if (f< f2)
                if (x3-x2 > x2-x1)
                    x1= x2
                    x2= x
                    f1= f2
                    f2= f
                else
                    x3= x2
                    x2= x
                    f3= f2
                    f2= f
                end
            else
                if (x3-x2 > x2-x1)
                    x3= x
                    f3= f
                else
                    x1= x
                    f1= f
                end
            end
        end
    
        if (f2< f1)
            tmp= f2
            f2= f1
            f1= tmp
            tmp= x2
            x2= x1
            x1= tmp
        end
        if (f3< f1)
            tmp= f3
            f3= f1
            f1= tmp
            tmp= x3
            x3= x1
            x1= tmp
        end
        #if (f3< f2)
        #    tmp= f3
        #    f3= f2
        #    f2= tmp
        #    tmp= x3
        #    x3= x2
        #    x2= tmp
    
        #end
        return(x1,f1)
    end
    

#################

function checkSpectral(spec)
    if (quadgk(x -> spec(x), 0, 1, rtol=1e-8)[1] ≈ 1.0) == false
        return(false)
    end

    points = collect(range(0,stop=1,length=1000)); 
    values = spec(points)

    if (minimum(diff(values)) .>= 0) == true
        return(true)
    else
        return(false)
    end

end



function add_expr(op1, op2)
    expr = Expr(:call, :+, op1, op2)
    return expr
end

function math_expr(op,op1)
    expr = Expr(:call, op, op1)
    return expr
end
function math_expr(op,op1,op2)
    expr = Expr(:call, op, op1, op2)
    return expr
end
