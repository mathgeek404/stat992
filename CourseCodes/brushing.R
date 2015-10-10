# to create the data file that is used below, run the code in 
#   "http://pages.stat.wisc.edu/~karlrohe/netsci/code/brushMadgraph.Rmd"
# Then, after running JGR() in R, a new window will open.  
# This code should be run in that JGR window.
# click on the plots.  drag your cursor across the screen.
# click up and down arrows.
# hold down shift while you re-highlight points. 

# load("~/dataFiles/physicianReferral/madStuff.RData")
load(url("http://pages.stat.wisc.edu/~karlrohe/netsci/data/madStuff.RData"))
iplot(madStuff[,1], madStuff[,2])
ibar(madStuff[,8])
sort(table(madStuff[,8]))
ibar(madStuff[,3])

table(madStuff[,4])
nas = which(madStuff[,4] =="")
madStuff[nas,4] = "NA"
ibar(madStuff[,4])