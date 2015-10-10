## The Madison referral network

source("~/projects/stat992/classcode/loadData.R")

mad = DT[City == "MADISON"]
tmp = Et[unique(mad$NPI)]  # so cool! and fast!
Emad = tmp[complete.cases(tmp)]  #lots of NA's.  Have not inspected why.
el=as.matrix(Emad)[,1:2] #igraph needs the edgelist to be in matrix format
g=graph.edgelist(el,directed = F) # this creates a graph.
# original graph is directed.  For now, ignore direction.
g= simplify(g)  # removes any self loops and multiple edges
core = graph.coreness(g)  # talk about core.
hist(core)
sum(core>10)
g1 = induced.subgraph(graph = g,vids = V(g)[core>10])  # talk about induced subgraphs.
plot(g1)

## OLD WAY
#g=graph.edgelist(el,directed = T) 
#g = induced.subgraph(graph = g,vids = V(g)[degree(g, mode = "in") > 1])  #OMG so annoying. 
#g = as.undirected(g)
#g= simplify(g)

## ANOTHER WAY
# g = induced.subgraph(graph = g, vids = unique(mad$NPI))  # this should work! but it doesn't!

unique(mad$NPI)[1]
V(g)[1]
madgraph = induced.subgraph(graph = g, vids = which(V(g)$name %in% unique(mad$NPI)))
core = graph.coreness(madgraph)
sum(core > 1)
madgraph = induced.subgraph(graph = madgraph,vids = (core > 1))
plot(madgraph)

plot(madgraph, vertex.label= NA)  # Thank you google!
clust = clusters(madgraph)  # this finds connected components.
names(clust)
clust$csize
tmp = induced.subgraph(graph = madgraph,vids = (clust$mem ==9))
plot(tmp)
sort(degree(tmp))
summary(tmp)
DT[V(tmp)$name]$State  # Oh shit!
DT[V(tmp)$name]$City  # whhhhhaaaat?
length(V(tmp)$name)  
length(DT[V(tmp)$name]$City)  # oh.

wi = DT[State == "WI"]
tmp = Et[unique(wi$NPI)]  
Ewi = tmp[complete.cases(tmp)]  #lots of NA's.  Have not inspected why.
el=as.matrix(Ewi)[,1:2] #igraph needs the edgelist to be in matrix format
g=graph.edgelist(el,directed = F) # this creates a graph.
ids = V(g)$name
cities = wi[ids, mult = "first"]$City
-sort(-table(cities))[1:10]
mean(is.na(cities))
g = set.vertex.attribute(g, name = "city", index=V(g),value =  cities)
wig = g
madgraph = induced.subgraph(graph = g,vids = which(V(g)$city == "MADISON"))
summary(madgraph)
core = graph.coreness(madgraph)
sum(core>1)
madgraph = induced.subgraph(graph = madgraph,vids = core>1)
plot(madgraph, vertex.label = NA)

colnames(DT)
features = colnames(DT)[c(8:12, 18,19, 21, 28)]
features
ids = V(madgraph)$name
tmp = wi[ids, mult = "last"]
atbs = tmp[,features, with = F]  # Thank you google for helping to find "with"
mean(complete.cases(atbs))
atbs = as.matrix(atbs)
for(i in 1:ncol(atbs)){
madgraph = set.vertex.attribute(madgraph, name = colnames(atbs)[i], index=V(madgraph),value =  atbs[,i])
}
summary(madgraph)

locs = layout.fruchterman.reingold(madgraph)
summary(madgraph)
plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Gender"), layout = locs)

plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Credential"), layout = locs)

plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Medical school name"), layout = locs)

year = as.numeric(V(madgraph)$"Graduation year")
plot(madgraph, vertex.label = NA, vertex.color = grey((year - min(year))/(max(year) - min(year))) , layout = locs)

plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Primary specialty"), layout = locs)

plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Organization legal name"), layout = locs)

plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Organization DBA name"), layout = locs)

plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Claims based hospital affiliation CCN 1"), layout = locs)

