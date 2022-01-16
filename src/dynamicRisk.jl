# Provides dynamic risk measures for SDEs and tree processes

# In the future also more general lattices will be dealt with


################
# First a test

d = 100 # number of dimensions
X0 = repeat([1.0f0, 0.5f0], div(d,2)) # initial value of stochastic state
tspan = (0.0f0,1.0f0)
r = 0.05f0
sigma = 0.4f0
f(X,u,σᵀ∇u,p,t) = r * (u - sum(X.*σᵀ∇u))
g(X) = sum(X.^2)
μ_f(X,p,t) = zero(X) #Vector d x 1
σ_f(X,p,t) = Diagonal(sigma*X) #Matrix d x d
prob = TerminalPDEProblem(g, f, μ_f, σ_f, X0, tspan)



hls  = 10 + d #hide layer size
opt = Flux.ADAM(0.001)
u0 = Flux.Chain(Dense(d,hls,relu),
                Dense(hls,hls,relu),
                Dense(hls,1))
σᵀ∇u = Flux.Chain(Dense(d+1,hls,relu),
                  Dense(hls,hls,relu),
                  Dense(hls,hls,relu),
                  Dense(hls,d))
pdealg = NNPDENS(u0, σᵀ∇u, opt=opt)


ans = solve(prob, pdealg, verbose=true, maxiters=150, trajectories=100,
                            alg=EM(), dt=0.2, pabstol = 1f-6)