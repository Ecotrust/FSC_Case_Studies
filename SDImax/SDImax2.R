setwd("G:/projects/FSC_CaseStudies_2016/Data/Work/AllAreas/SDImax")

#load packages
library(reshape2)
library(sqldf)
library(tcltk2)
library(gdata)
library(plyr)

#read in FVS_Cases table
cases = read.csv("FVS_Cases.csv")  

#read in FVS_Compute table
compute = read.csv("FVS_Compute.csv")

#read in FVS_StrClass table
structure = read.csv("FVS_StrClass.csv") 

#read in FVS_Summary table
summary = read.csv("FVS_Summary.csv") 

compile<-sqldf("SELECT compute.Year, compute.PERBA1, structure.Stratum_1_Species_1, summary.SDI, cases.Variant
                FROM ((compute INNER JOIN structure ON (compute.Year = structure.Year) AND (compute.StandID = structure.StandID)) 
                INNER JOIN summary ON (structure.Year = summary.Year) AND (structure.StandID = summary.StandID)) 
                INNER JOIN cases ON compute.CaseID = cases.CaseID
                WHERE (((compute.Year)=2014) AND ((compute.PERBA1)>0.8));")

#group by variant and species type
groupColumns = c("Variant","Stratum_1_Species_1")

#calculate summary stats: 98%, 95%, and 90%, count of records in group
stats<-ddply(compile, groupColumns, summarise, Max = max(SDI), SDI98 = quantile(SDI, .98), SDI95 = quantile(SDI, .95),
             SDI90 = quantile(SDI, .90),  SDI85=round(SDI95*.85), freq=length(Variant))

#subset data to only species with 100+ counts and remove -- species
stats100<-subset(stats, stats$freq>=100 & stats$Stratum_1_Species_1!="--")

#create variant specific tables
WC_stats<-subset(stats100, stats100$Variant=="WC")
PN_stats<-subset(stats100, stats100$Variant=="PN")

#function to write variant KCP SDImax files
f <- function(x, output) {
  species <- x[2]
  SDI85 <- x[7]
  print(paste("SDIMax           ", species, "       ", SDI85, "                           55.        75", sep=""))
  cat(paste("SDIMax           ", species, "       ", SDI85, "                           55.        75", sep=""), 
      file= output, append = T, fill = T)
}

#write SDImax KCP files
apply(WC_stats, 1, f, output = 'SDImax_WC.KCP')
apply(PN_stats, 1, f, output = 'SDImax_PN.KCP')
