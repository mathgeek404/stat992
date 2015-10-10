library(data.table)  # so fast!
library(igraph)  # all the basic graph operations.

Et = fread("~/projects/stat992/data/physician-referrals-2015-days365.txt",sep = ",",  colClasses = c("character", "character","numeric", "numeric", "numeric"))
setkey(Et, V1)
head(Et)
b= c(rep("character", 6),rep("factor",4), "numeric", rep("factor",6), "character", "character", "character", "numeric", rep("character",2), "factor", "character", "factor", "character", rep("character", 10), rep("factor", 6))
DT = fread("~/projects/stat992/data/National_Downloadable_File.csv",colClasses = b)
names(DT)[1] <- c("NPI")
setkey(DT, NPI)
rm(b)



library(zipcode)
data(zipcode)
zipcode = as.data.table(zipcode); setkey(zipcode, zip)  # thanks data.table for making things so 

library(geosphere)

edgeDistances = function(NPIfrom, NPIto){
  ed = distGeo(
    zipcode[
      substr(
        DT[NPIfrom, mult = "first"]$"Zip Code" ,start = 1, stop = 5
      )
      , c("longitude", "latitude"), with = F] 
    , zipcode[substr(DT[NPIto, mult = "first"]$"Zip Code" ,start = 1, stop = 5), c("longitude", "latitude"), with = F] 
  )/1000
  return(ed)
}
