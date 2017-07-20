setwd("G:/projects/FSC_CaseStudies_2016/Data/Work/AllAreas/SDImax")

#load packages
library(reshape2)
library(sqldf)
library(tcltk2)
library(gdata)
library(plyr)
library(RODBC)

con <- odbcConnectAccess2007("G:/projects/FSC_CaseStudies_2016/Data/Work/AllAreas/SDImax/FVS_SDImax_out.accdb")

#pull in Cost Benefit Tables
compute<-data.frame(sqlFetch(con, "FVS_Compute"))
structure<-data.frame(sqlFetch(con, "FVS_StrClass"))
summary<-data.frame(sqlFetch(con, "FVS_Summary"))
cases<-data.frame(sqlFetch(con, "FVS_Cases"))

compile<-sqldf("SELECT compute.Year, compute.PERBA1, structure.Stratum_1_Species_1, summary.SDI, cases.Variant
                FROM ((compute INNER JOIN structure ON (compute.Year = structure.Year) AND (compute.StandID = structure.StandID)) 
                INNER JOIN summary ON (structure.Year = FVS_Summary.Year) AND (structure.StandID = summary.StandID)) 
                INNER JOIN cases ON compute.CaseID = cases.CaseID
                WHERE (((compute.Year)=2014) AND ((compute.PERBA1)>0.8));")


#calculate summary stats: 98%, 95%, and 90%, count of records in group
stats<-ddply(stands_SDI, groupColumns, summarise, SDI98 = quantile(SDI, .98), SDI95 = quantile(SDI, .95),
             SDI90 = quantile(SDI, .90),  freq=length(Variant))

write.csv(stats, file="SDIstats.csv")
