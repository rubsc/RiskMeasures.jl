

""" 
    VaR(states,prob,alpha::Float64)

implements the Value-at-Risk at level ``\\alpha`` defined by
```math
VaR_\\alpha (Y) = \\arg \\min_x \\left( x\\in \\mathbb{R} : F_Y(x) \\geq \\alpha \\right),
```
for the random variable ``Y`` defined by `states` and `prob`.
"""
function VaR(x::Vector{Float64}, f::Vector{Float64}, α::Float64)
    ind = sortperm(x[1:length(x)])
    x = x[ind]; f = f[ind];
    i = findfirst(p -> p≥α, cumsum(f))
    if i === nothing
        return x[end]
    else
        return x[i]
    end
end


""" 
    CTE(states,prob,alpha::Float64)

implements the Conditional Value-at-Risk at level ``\\alpha`` defined by
```math
CTE_\\alpha (Y) = VaR_\\alpha(Y) + \\frac{1}{1-\\alpha} \\mathbb{E} \\left( Y- VaR_\\alpha (Y) \\right)_+ ,
```
for the random variable ``Y`` defined by `states` and `prob`.
"""
function CTE(x::Vector{Float64}, f::Vector{Float64}, α::Float64)
    x = -x; α = 1-α;
    x_α = VaR(x, f, α)
    if iszero(α)
        return -x_α
    else
        tail = x .≤ x_α
        result = (sum(x[tail] .* f[tail]) - (sum(f[tail]) - α) * x_α) / α
        return -result
    end
end




"""
    EVaR2(states,prob,beta)

Solves the optimization problem associated with the primal formulation of the Entropic Value-at-Risk:

```math
EVaR_\\alpha(Y) = \\min_{x >0} \\frac{1}{x} \\left( \\beta +  \\log\\mathbb{E} e^{xY} \\right),
```
where ``Y`` is the discrete random variable defined by `states` and `prob`.
Here the optimization is done via the goldenSearch optimization routine implemented as part of this package. 
"""
function EVaR2(states::Vector{Float64}, prob::Vector{Float64},beta::Float64)
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


"""
    EVaR(states,prob,beta::Float64)

Solves the optimization problem associated with the primal formulation of the Entropic Value-at-Risk:

```math
EVaR_\\alpha(Y) = \\min_{x >0} \\frac{1}{x} \\left( \\beta +  \\log\\mathbb{E} e^{xY} \\right),
```
where ``Y`` is the discrete random variable defined by `states` and `prob`. Here, the optimization is done using JuMP and Ipopt.  
"""
function EVaR(states::Vector{Float64}, prob::Vector{Float64},beta::Float64)
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
			EV = Model(optimizer_with_attributes(Ipopt.Optimizer, "print_level" =>0))
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



"""
    AVaR(states,prob,alpha::Float64)

Solves the optimization problem associated with the primal formulation of the Average Value-at-Risk:

```math
AVaR_\\alpha(Y) = \\min_{x\\in \\mathbb{R}} x + \\frac{1}{1-\\alpha} \\mathbb{E} \\left( Y - x \\right)_+,
```
where ``Y`` is the discrete random variable defined by `states` and `prob`.
"""
function AVaR(states::Vector{Float64},prob::Vector{Float64}, alpha::Float64)
    var2 = dot(prob, (states .- dot(prob,states)).^2);
     #First trivial case
    if alpha == 0.0
        return(dot(prob, states))
  #Now set up optimization problem using goldenSearch
    else
       tOpt = sqrt.(2 *alpha/var2)
       EV = Model(optimizer_with_attributes(Ipopt.Optimizer, "print_level" =>0))
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
