##------------------------------##
##------------------------------##
##----PROGETTO NETWORK DATA-----##
##------------------------------##
rm(list = ls())
##------------------------------##
##------------------------------##

library(igraph)

g <- read_graph("Data/mouse_visual.cortex_2.graphml", "graphml")
g.Y <- as.matrix(as_adjacency_matrix(g, sparse = TRUE))
diag(g.Y)=NA
plot(g, vertex.size = 10,  edge.arrow.size = 0.5,
     vertex.label.cex = 1)

## statistiche di rete

g_density <- edge_density(g)
isSymmetric.matrix(g.Y)
g_reciprocity <- reciprocity(g)
g_transitivity <- transitivity(g)
unique(V(g)$type1)
V(g)$attr <- factor(V(g)$type1)
g_assortativity <- assortativity(g, V(g)$attr)

## statistiche nodali

g.sy = as.undirected(g, mode = "collapse")
g.degree.u<- centr_degree(g, loops = F)$centralization
g.degree.in <- centr_degree(g,mode="in", loops = F)$centralization
g.degree.out <- centr_degree(g,mode="out", loops = F)$centralization
g.closeness <- centr_clo(g,mode="out")$centralization
g.betweeness.u <- centr_betw(g, directed = F)$centralization
g.betweeness.d <- centr_betw(g, directed = T)$centralization
g.eigen.u <- eigen_centrality(g,directed=F)$vector 
g.eigen.d <- eigen_centrality(g,directed=T)$vector
## SRG con approccio naive

n = nrow(g.Y)
rho.MLE = mean(g.Y,na.rm=T) # compute the MLE for p
B = 1000
rho.sim = reciprocity.sim =transitivity.sim=degree.sim.in=degree.sim.out=degree.sim.u=bmw.sim.u=bmw.sim.d=eigen.sim.u=eigen.sim.d=c()
for(b in 1:B){
  set.seed(1+b)
  tmp = rbinom(n^2,1,rho.MLE)
  Y.sim = matrix(tmp, n,n)
  diag(Y.sim) = NA
  rho.sim[b] = mean(Y.sim, na.rm = TRUE)
  Y.sim = graph_from_adjacency_matrix(Y.sim)
  reciprocity.sim[b] <- reciprocity(Y.sim)
  transitivity.sim[b] <- transitivity(Y.sim)
  degree.sim.u[b]= centr_degree(Y.sim,loops=F)$centralization
  degree.sim.in[b]= centr_degree(Y.sim,mode="in",loops=F)$centralization
  degree.sim.out[b]= centr_degree(Y.sim,mode="out",loops=F)$centralization
  bmw.sim.u[b]=centr_betw(Y.sim, directed = F)$centralization
  bmw.sim.d[b]=centr_betw(Y.sim, directed = T)$centralization
  eigen.sim.d[b]=eigen_centrality(Y.sim, directed = T)$vector
  eigen.sim.u[b]=eigen_centrality(Y.sim, directed = F)$vector
}

# grafici statistiche rete
par(mfrow=c(1,3))
mtext("Network Statistics")
hist(rho.sim, col = "lightgray", main = "Density")
abline(v = rho.MLE, col = "red", lwd=2)
mean(rho.sim >= rho.MLE)
hist(reciprocity.sim, col = "lightgray", main = "Reciprocity")
abline(v = g_reciprocity, col = "red", lwd=2)
mean(reciprocity.sim <= g_reciprocity)

hist(transitivity.sim, col = "lightgray", main = "Transitivity")
abline(v =g_transitivity  , col = "red", lwd=2)
mean(transitivity.sim<= g_transitivity)

# grafici statistiche nodali
par(mfrow=c(1,3))
hist(degree.sim.in, col = "lightgray", main = "Degree In")
abline(v = g.degree.in  , col = "red", lwd=2)
mean(degree.sim.in >=g.degree.in)

hist(degree.sim.out, col = "lightgray", main = "Degree Out",xlim=c(0,g.degree.out))
abline(v = g.degree.out  , col = "red", lwd=2)
mean(degree.sim.out>=g.degree.out)

hist(degree.sim.u, col = "lightgray", main = "Degree Undirected",xlim=c(0,g.degree.u))
abline(v = g.degree.u  , col = "red", lwd=2)
mean(degree.sim.u>=g.degree.u)

par(mfrow=c(1,2))
hist(bmw.sim.u, col = "lightgray", main = "Betweeness undirected",xlim=c(0,g.betweeness.u))
abline(v = g.betweeness.u  , col = "red", lwd=2)
mean(bmw.sim.u>=g.betweeness.u)

hist(bmw.sim.d, col = "lightgray", main = "Betweeness directed",xlim=c(0,g.betweeness.d))
abline(v = g.betweeness.d  , col = "red", lwd=2)
mean(bmw.sim.d>=g.betweeness.d)


hist(eigen.sim.u, col = "lightgray", main = "Eigenvector undirected",xlim=c(0,g.eigen.u))
abline(v = g.eigen.u  , col = "red", lwd=2)
mean(eigen.sim.u>=g.eigen.u)

hist(eigen.sim.d, col = "lightgray", main = "Eigenvector directed",xlim=c(0,g.eigen.d))
abline(v = g.eigen.d  , col = "red", lwd=2)
mean(eigen.sim.d>=g.eigen.d)

