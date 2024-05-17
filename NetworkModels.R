#--------------------------------------------#
#--------------------------------------------#
#                  Lab 7                     #
#     Exponential Random Graph Models        #
#--------------------------------------------#
#--------------------------------------------#

rm(list = ls())

# -----------------------#
# ------ 1. Set-up ----- #
# -----------------------
library(igraph)

g <- read_graph("Data\\mouse_visual.cortex_2.graphml","graphml")
plot(g, vertex.size = 20, edge.arrow.size = 0.5)
Y = as_adjacency_matrix(g, sparse = F)
diag(Y)  = NA


# -------- srg_no_homo: homogeneous binomial random graph model --------
p.MLE = mean(Y, na.rm = T)
p.MLE


library(ergm)

# asneuronswork per passare da oggetto igraph a neuronswork. dovrebbe mantenere l'ordine
neurons = network(Y, directed = T)

# add neurons work and edge attributes
neurons %v% "type1" = vertex_attr(g,"type1",V(g))
neurons %v% "type2" = vertex_attr(g, "type2",V(g))


# Let's estimate the NULL model: SRG
# let us estimate parameters of a SRG model via the ergm function
# which is the sufficient statistic for theta? 
# y.. -> the number of observed edges
srg_homo  = ergm(neurons ~ edges) 
summary(srg_homo)

# which information do we have? 
# 1) formula: recall the estimated model
# 2) stime con la ML classica
# 3) poiché questo modello corrisponde semplicemente a una regressione logistica
# possiamo interpretare i risultati come di consueto


# edge parameter
# 1) is it significant? Yes -> there is a significant difference 
# between Pr(Y_ij = 1) and Pr(Y_ij = 0)  
# That is, these quantities are significantly different from 0.5
# 2) sign? Negative ->  Pr(Y_ij = 1)< 0.5

# indeed...
exp(coef(srg_homo))
# the odds of observing a relation between two randomly 
# selected nodes is about 99.5% lower than that of not observing it

# indeed... 
edge_density(g)
# or
p.MLE
# or, via the expit function
exp(coef(srg_homo ))/(1+exp(coef(srg_homo )))


# -------------------------------------------
# let us move towards the non-homogeneous SRG
# -------------------------------------------
# which sufficient statistics for theta?
# n. of edges
# in-degrees -> receiver effects
# out-degrees -> sender effects
srg_no_homo = ergm(neurons ~ edges + sender + receiver)
summary(srg_no_homo)

# how do we interpret the results? 
# 1) significant parameters? 
# 2) sign of the parameters? 

# which model is more appropriate? 
BIC(srg_homo , srg_no_homo)
AIC(srg_homo , srg_no_homo)
# as expected, bic is more conservative

# -----------------------------------------------
# let us now consider the dyad independence model
# -----------------------------------------------
# which sufficient statistics for theta?
# n. of edges
# in-degrees -> receiver effects
# out-degrees -> sender effects
# n. of mutual relations 

# ! ATT -- MCMCMLE used for estimation 
# let us fix a seed to replicate results
p1_classic = ergm(neurons ~ edges + sender + receiver + mutual, 
            control = control.ergm(seed = 1))

summary(p1_classic)

p1_sender_ind = ergm(neurons ~ edges + receiver + mutual, control = control.ergm(seed = 1))
summary(p1_sender_ind)
p1_receiver_ind = ergm(neurons ~ edges + sender + mutual, control = control.ergm(seed = 1))
summary(p1_receiver_ind)
# many parameters not significantly different from zero
# let us also exclude the receiver parameter
p1_mutual_only = ergm(neurons ~ edges + mutual)
summary(p1_mutual_only)
# which model should we prefer? let us use the BIC
BIC(srg_homo , p1_sender_ind, p1_mutual_only)

# p1_mutual_only seems the best
summary(p1_mutual_only)
# interpret the results
# 1) edge parameter? 
#    negative and significant - less ties than expected by chance
#    -> non-ties are more frequent than ties
# 2) mutuality parameter? 
#    positive and significant --- mutuality plays a role ->
#    there is a positive tendency to return ties -> 
#    more mutual ties than expected by chance

# ----------------
# model diagnostic
# ----------------
# has the model converged?
mcmc.diagnostics(p1_mutual_only)
# Look at standard results you consider for any MCMC estimation: 
# well-mixed, stationary chains
# results look pretty ok
# 1) the chains explore the parameter space
# 2) posterior distributions are almost bell-shaped

# If the MCMC procedure does not converge
# A) the model is ill-specified
# B) try to improve things by increasing the length of the MCMC routine

# ---------------------------------------------
# let us include in the model nodal attributes
# ---------------------------------------------
# main effects 
# quantitative attributes -- nodecov(attr)
# qualitative attributes -- nodefactor(attr)

# homophily effects
# quantitative attributes -- absdiff(attr) - sum_ij[abs(attr_i - attr_j)y_ij]
# qualititave attributes -- nodematch(attr) 
mod5 = ergm(neurons ~ edges + nodefactor("type1") + nodefactor("type2") + 
              nodematch("type1"), control = control.ergm(seed = 1)) 

# let us look at the results
summary(mod5)


mod6 = ergm(neurons ~ edges + mutual+ nodefactor("type1") + nodematch("type1"), control = control.ergm(seed = 1)) 
summary(mod6)
# only the main effect plays a role, let us exclude the homophily effect
mod7 = ergm(neurons ~ edges + mutual + nodefactor("type1") + nodefactor("type2"), control = control.ergm(seed = 1)) 
summary(mod7)

# let us build a new attribute
type.new = rep(0, 195)
type.new[vertex_attr(g,"type1") == "Characterized pyramidal neuron"] = 1
type.new
# add the attribute to the neuronswork
neurons %v% "type.new" = type.new

type2.new = rep(0, 195)
type2.new[vertex_attr(g,"type2") == "Postsynaptic excitatory target"] = 1
type2.new
# add the attribute to the neuronswork
neurons %v% "type2.new" = type2.new


# estimate again the model
mod8 = ergm(neurons ~ edges +nodefactor("type.new") + nodefactor("type2.new"), control = control.ergm(seed = 1)) 
mod8.1=ergm(neurons ~ edges +nodefactor("type.new") +nodefactor("type2.new") + nodematch("type.new")+ nodematch("type2.new") , control = control.ergm(seed = 1)) 
mod8.2= ergm(neurons ~ edges + nodefactor("type.new") + nodematch("type.new") , control = control.ergm(seed = 1))
mod8.3 = ergm(neurons ~ edges + nodefactor("type1") +nodematch("type1") , control = control.ergm(seed = 1))

summary(mod8)
summary(mod8.1)
summary(mod8.2) ## migliore per ora
summary(mod8.3)

# how do we interpret results?
# negative and significant edges
# positive and significant mutuality
# positive and significant effect for the main effect of Dep2 

# let us verify convergence
mcmc.diagnostics(mod8.2) # non fa mcmc senza mutualità

# -------------------------------------------
# let us move towards the Markov graph model
# -------------------------------------------
# Let us add to the model the triangle term, the in- and the out-stars of order 2
# (indicating the tendency to form clusters in the neuronswork)

mod9 = ergm(neurons ~ edges + nodefactor("type.new") + istar(2) + triangles, 
             control = control.ergm(seed = 1))  
summary(mod9)

mod9.1 = ergm(neurons ~ edges + nodefactor("type.new") + ostar(2) + triangles, 
            control = control.ergm(seed = 1))  

# the model cannot be estimated due to degeneracy issues; ad ogni iterazione viene sempre lo stesso valore
# non siamo in grado di stimare il modello
# let us try to remove triangles
# still, the model suffer from some estimation issues

# let us try to solve the issue by considering the alternating k-star term
# --------------------------------------------------------------------------
# ergm implements some modified forms of such statistics

# for undirected neuronsworks 
# gwdegree(decay, fixed = FALSE) -- decay = log(lambda/(lambda-1))
# gwdegree -- geometrically weighted degree distribution

# for directed neuronsworks 
# gwidegree(decay, fixed = FALSE) -- decay = log(lambda/(lambda-1))
# gwodegree(decay, fixed = FALSE) -- decay = log(lambda/(lambda-1))
# gwidegree/gwodegree -- geometrically weighted in-/out- degree distribution

# positive estimates -- centralized neuronswork --  few nodes with high degree
# negative estimates -- non centralized neuronswork

# a standard choice for decay is 1, but model selection can be used!
mod10 = ergm(neurons ~ edges + triangle+ nodefactor("type.new") + gwidegree(decay = 1, fixed = TRUE), 
             control = control.ergm(seed = 1))
summary(mod10)

mod11=ergm(neurons ~ edges + triangle+ nodefactor("type1")+ gwidegree(decay = 1, fixed = TRUE), 
             control = control.ergm(seed = 1))
summary(mod11)

mod12 = ergm(neurons ~ edges + triangle + nodefactor("type.new") + gwodegree(decay = 1, fixed = TRUE), 
             control = control.ergm(seed = 1))
summary(mod12)

mod13 = ergm(neurons ~ edges + triangle + nodefactor("type.new") + gwidegree(decay = 1, fixed = TRUE)
             + gwodegree(decay = 1, fixed = TRUE), 
             control = control.ergm(seed = 1))
summary(mod13)
# again, the model cannot be estimated

# ----------------------------------------
# let us consider the social circuit model 
# ----------------------------------------
# alternating k-triangles --> gwesp(decay = 0, fixed = FALSE) 
# geometrically weighted edge-wise shared partners
# the corresponding parameter expresses the tendency for tied nodes 
# to have multiple shared partners

# alternating k-2-paths --> gwdsp(decay = 0, fixed = FALSE)
# geometrically weighted dyad-wise shared partners
# the corresponding parameter expresses the tendency for dyads 
# (whether tied or not) to have multiple shared partners

mod14 = ergm(neurons ~ edges + nodefactor("type.new") + 
               gwesp(decay = 1, fixed = T) + 
                gwdsp(decay = 1, fixed = T), control = control.ergm(seed=1))
summary(mod14)

# non converge
# let us remove the gwesp term
mod15 = ergm(neurons ~ edges + nodefactor("type.new") + 
               gwdsp(decay = 1,fixed = T), control = control.ergm(seed=1))
summary(mod15)


# how can we interpret the parameters?
# 1) the edge parameter is not significantly different from zero, even though it is negative 
#    --> given the effects in the mode, ties and non-ties are equally likely
# 2) the mutuality parameter is significantly different from zero and is positive
#   --> positive tendency to return ties in the neuronswork
# 3) the parameter associated to the nodal attribute is significant and positive
#   --> nodes in department 2 are more active than others
# 3) the gwdsp parameter is significant and negative
#    -> lower tendency to form clusters than that expected by chance

# check convergence
win.graph()
mcmc.diagnostics(srg_no_homo4)


# still look at model selection via BIC
BIC(srg_homo ,srg_no_homo,p1_mutual_only,mod5,mod6,mod7,mod8) ## aggiorna
# srg_no_homo4 seems to be the optimal choice

# let us evaluate the goodness of fit
# ----------------------------------
# simulate from the model
sim = simulate(srg_no_homo4, nsim = 100, verbose = TRUE, seed = 1)

# let us assume we want to verify whether the model is appropriate to represent the degree and the 
# transitivity in the neuronswork

# install.packages("intergraph")
library(intergraph)
?asIgraph

fnc = function(xx){
  ig = asIgraph(xx)
  tr = transitivity(ig)
  ideg = sd(degree(ig, mode = "in"))
  odeg = sd(degree(ig, mode = "out"))
  return(c(tr, ideg, odeg))
}

null.distr = matrix(,100,3)
for(b in 1:100){
  null.distr[b,]  = fnc(sim[[b]])
}
dev.new()
par(mfrow = c(3,1))
hist(unlist(null.distr[,1]), xlab = "transitivity"); abline(v = transitivity(friend), col = "red")
hist(unlist(null.distr[,2]), xlab = "in-degree"); abline(v = sd(degree(friend, mode = "in")), col = "red")
hist(unlist(null.distr[,3]), xlab = "out-degree"); abline(v = sd(degree(friend, mode = "out")), col = "red")


