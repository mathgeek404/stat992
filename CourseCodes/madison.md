## The Madison referral network

## To illustrate the data, focus on Madison.


```r
source("http://pages.stat.wisc.edu/~karlrohe/netsci/code/loadData.R")
```

```
## Error in library(data.table): there is no package called 'data.table'
```

```r
mad = DT[City == "MADISON"]
```

```
## Error in eval(expr, envir, enclos): object 'DT' not found
```

```r
tmp = Et[unique(mad$NPI)]  # so cool! and fast!
```

```
## Error in eval(expr, envir, enclos): object 'Et' not found
```

```r
Emad = tmp[complete.cases(tmp)]  #lots of NA's.  Have not inspected why.
```

```
## Error in eval(expr, envir, enclos): object 'tmp' not found
```

```r
el=as.matrix(Emad)[,1:2] #igraph needs the edgelist to be in matrix format
```

```
## Error in as.matrix(Emad): object 'Emad' not found
```

```r
g=graph.edgelist(el,directed = F) # this creates a graph.
```

```
## Error in eval(expr, envir, enclos): could not find function "graph.edgelist"
```

```r
# original graph is directed.  For now, ignore direction.
g= simplify(g)  # removes any self loops and multiple edges
```

```
## Error in eval(expr, envir, enclos): could not find function "simplify"
```

```r
core = graph.coreness(g)  # talk about core.
```

```
## Error in eval(expr, envir, enclos): could not find function "graph.coreness"
```

```r
hist(core)
```

```
## Error in hist(core): object 'core' not found
```

```r
sum(core>10)
```

```
## Error in eval(expr, envir, enclos): object 'core' not found
```

```r
g1 = induced.subgraph(graph = g,vids = V(g)[core>10])  # talk about induced subgraphs.
```

```
## Error in eval(expr, envir, enclos): could not find function "induced.subgraph"
```

```r
plot(g1)
```

```
## Error in plot(g1): object 'g1' not found
```

What is going on with 1700865094?  This is a playground!  Do a google search!  
  
  Could fix this problem by thresholding on in/out degree... 


```r
## OLD WAY
#g=graph.edgelist(el,directed = T) 
#g = induced.subgraph(graph = g,vids = V(g)[degree(g, mode = "in") > 1])  #OMG so annoying. 
#g = as.undirected(g)
#g= simplify(g)

## ANOTHER WAY
# g = induced.subgraph(graph = g, vids = unique(mad$NPI))  # this should work! but it doesn't!

unique(mad$NPI)[1]
```

```
## Error in mad$NPI: object of type 'closure' is not subsettable
```

```r
V(g)[1]
```

```
## Error in eval(expr, envir, enclos): could not find function "V"
```

```r
madgraph = induced.subgraph(graph = g, vids = which(V(g)$name %in% unique(mad$NPI)))
```

```
## Error in eval(expr, envir, enclos): could not find function "induced.subgraph"
```

```r
core = graph.coreness(madgraph)
```

```
## Error in eval(expr, envir, enclos): could not find function "graph.coreness"
```

```r
sum(core > 1)
```

```
## Error in eval(expr, envir, enclos): object 'core' not found
```

```r
madgraph = induced.subgraph(graph = madgraph,vids = (core > 1))
```

```
## Error in eval(expr, envir, enclos): could not find function "induced.subgraph"
```

```r
plot(madgraph)
```

```
## Error in plot(madgraph): object 'madgraph' not found
```

Ugh.  Those labels are horrible.  How do you fix that?  Google it!
  
  
  
  ```r
  plot(madgraph, vertex.label= NA)  # Thank you google!
  ```
  
  ```
  ## Error in plot(madgraph, vertex.label = NA): object 'madgraph' not found
  ```
  
  ```r
  clust = clusters(madgraph)  # this finds connected components.
  ```
  
  ```
  ## Error in eval(expr, envir, enclos): could not find function "clusters"
  ```
  
  ```r
  names(clust)
  ```
  
  ```
  ## Error in eval(expr, envir, enclos): object 'clust' not found
  ```
  
  ```r
  clust$csize
  ```
  
  ```
  ## Error in eval(expr, envir, enclos): object 'clust' not found
  ```
  
  ```r
  tmp = induced.subgraph(graph = madgraph,vids = (clust$mem ==9))
  ```
  
  ```
  ## Error in eval(expr, envir, enclos): could not find function "induced.subgraph"
  ```
  
  ```r
  plot(tmp)
  ```
  
  ```
  ## Error in plot(tmp): object 'tmp' not found
  ```
  
  ```r
  sort(degree(tmp))
  ```
  
  ```
  ## Error in sort(degree(tmp)): could not find function "degree"
  ```
  
  ```r
  summary(tmp)
  ```
  
  ```
  ## Error in summary(tmp): object 'tmp' not found
  ```
  
  ```r
  DT[V(tmp)$name]$State  # Oh shit!
  ```
  
  ```
  ## Error in eval(expr, envir, enclos): object 'DT' not found
  ```
  
  ```r
  DT[V(tmp)$name]$City  # whhhhhaaaat?
  ```
  
  ```
  ## Error in eval(expr, envir, enclos): object 'DT' not found
  ```
  
  ```r
  length(V(tmp)$name)  
  ```
  
  ```
  ## Error in eval(expr, envir, enclos): could not find function "V"
  ```
  
  ```r
  length(DT[V(tmp)$name]$City)  # oh.
  ```
  
  ```
  ## Error in eval(expr, envir, enclos): object 'DT' not found
  ```

Perhaps there is a better way to do all of this.  igraph allows you to assign vertex (and edge) attributes.  


```r
wi = DT[State == "WI"]
```

```
## Error in eval(expr, envir, enclos): object 'DT' not found
```

```r
tmp = Et[unique(wi$NPI)]  
```

```
## Error in eval(expr, envir, enclos): object 'Et' not found
```

```r
Ewi = tmp[complete.cases(tmp)]  #lots of NA's.  Have not inspected why.
```

```
## Error in eval(expr, envir, enclos): object 'tmp' not found
```

```r
el=as.matrix(Ewi)[,1:2] #igraph needs the edgelist to be in matrix format
```

```
## Error in as.matrix(Ewi): object 'Ewi' not found
```

```r
g=graph.edgelist(el,directed = F) # this creates a graph.
```

```
## Error in eval(expr, envir, enclos): could not find function "graph.edgelist"
```

```r
ids = V(g)$name
```

```
## Error in eval(expr, envir, enclos): could not find function "V"
```

```r
cities = wi[ids, mult = "first"]$City
```

```
## Error in eval(expr, envir, enclos): object 'wi' not found
```

```r
-sort(-table(cities))[1:10]
```

```
## Error in table(cities): object 'cities' not found
```

```r
mean(is.na(cities))
```

```
## Error in mean(is.na(cities)): object 'cities' not found
```

```r
g = set.vertex.attribute(g, name = "city", index=V(g),value =  cities)
```

```
## Error in eval(expr, envir, enclos): could not find function "set.vertex.attribute"
```

```r
wig = g
```

```
## Error in eval(expr, envir, enclos): object 'g' not found
```

```r
madgraph = induced.subgraph(graph = g,vids = which(V(g)$city == "MADISON"))
```

```
## Error in eval(expr, envir, enclos): could not find function "induced.subgraph"
```

```r
summary(madgraph)
```

```
## Error in summary(madgraph): object 'madgraph' not found
```

```r
core = graph.coreness(madgraph)
```

```
## Error in eval(expr, envir, enclos): could not find function "graph.coreness"
```

```r
sum(core>1)
```

```
## Error in eval(expr, envir, enclos): object 'core' not found
```

```r
madgraph = induced.subgraph(graph = madgraph,vids = core>1)
```

```
## Error in eval(expr, envir, enclos): could not find function "induced.subgraph"
```

```r
plot(madgraph, vertex.label = NA)
```

```
## Error in plot(madgraph, vertex.label = NA): object 'madgraph' not found
```

Let's color the nodes in this figure by some other interesting attributes in DT. 


```r
colnames(DT)
```

```
## Error in is.data.frame(x): object 'DT' not found
```

```r
features = colnames(DT)[c(8:12, 18,19, 21, 28)]
```

```
## Error in is.data.frame(x): object 'DT' not found
```

```r
features
```

```
## Error in eval(expr, envir, enclos): object 'features' not found
```

```r
ids = V(madgraph)$name
```

```
## Error in eval(expr, envir, enclos): could not find function "V"
```

```r
tmp = wi[ids, mult = "last"]
```

```
## Error in eval(expr, envir, enclos): object 'wi' not found
```

```r
atbs = tmp[,features, with = F]  # Thank you google for helping to find "with"
```

```
## Error in eval(expr, envir, enclos): object 'tmp' not found
```

```r
mean(complete.cases(atbs))
```

```
## Error in complete.cases(atbs): object 'atbs' not found
```

```r
atbs = as.matrix(atbs)
```

```
## Error in as.matrix(atbs): object 'atbs' not found
```

```r
for(i in 1:ncol(atbs)){
madgraph = set.vertex.attribute(madgraph, name = colnames(atbs)[i], index=V(madgraph),value =  atbs[,i])
}
```

```
## Error in ncol(atbs): object 'atbs' not found
```

```r
summary(madgraph)
```

```
## Error in summary(madgraph): object 'madgraph' not found
```

Now, let's plot it with several different colorings.  The thing that takes the longest in plotting is computing the node locations (extensive field of algorithmic study!).


```r
locs = layout.fruchterman.reingold(madgraph)
```

```
## Error in eval(expr, envir, enclos): could not find function "layout.fruchterman.reingold"
```

```r
summary(madgraph)
```

```
## Error in summary(madgraph): object 'madgraph' not found
```

```r
plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Gender"), layout = locs)
```

```
## Error in plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$Gender), : object 'madgraph' not found
```

```r
plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Credential"), layout = locs)
```

```
## Error in plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$Credential), : object 'madgraph' not found
```

```r
plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Medical school name"), layout = locs)
```

```
## Error in plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Medical school name"), : object 'madgraph' not found
```

```r
year = as.numeric(V(madgraph)$"Graduation year")
```

```
## Error in eval(expr, envir, enclos): could not find function "V"
```

```r
plot(madgraph, vertex.label = NA, vertex.color = grey((year - min(year))/(max(year) - min(year))) , layout = locs)
```

```
## Error in plot(madgraph, vertex.label = NA, vertex.color = grey((year - : object 'madgraph' not found
```

```r
plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Primary specialty"), layout = locs)
```

```
## Error in plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Primary specialty"), : object 'madgraph' not found
```

```r
plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Organization legal name"), layout = locs)
```

```
## Error in plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Organization legal name"), : object 'madgraph' not found
```

```r
plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Organization DBA name"), layout = locs)
```

```
## Error in plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Organization DBA name"), : object 'madgraph' not found
```

```r
plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Claims based hospital affiliation CCN 1"), layout = locs)
```

```
## Error in plot(madgraph, vertex.label = NA, vertex.color = as.factor(V(madgraph)$"Claims based hospital affiliation CCN 1"), : object 'madgraph' not found
```

What are they?


```r
table(atbs[,7])
```

```
## Error in table(atbs[, 7]): object 'atbs' not found
```

Next, let's plot the data using zip codes.  Zip codes are another data playground!

