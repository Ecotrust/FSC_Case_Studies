setwd("G:/projects/FSC_CaseStudies_2016/Data/Work/AllAreas/SDImax")

#load packages
library(reshape2)
library(sqldf)
library(tcltk2)
library(gdata)
library(plyr)

#read in TREE_COV_CROSSTAB table from GNN database
tree_cov = read.csv("TREE_COV_CROSSTAB.csv")  

#read in SPPSZ_ATTR_LIVE table from GNN database
stand_att = read.csv("SPPSZ_ATTR_LIVE.csv")

#read in list of stand_CN, stand_ID, and variant values
stand_list = read.csv("StandList.csv")

#reshape the tree data
tree_cov_m<-melt(tree_cov, id="VALUE")

#rename the value field so there are not two value columns
names(tree_cov_m)[names(tree_cov_m) == 'value'] <- 'covPer'

#select records from tree table with cover percent values greater than 80
tree_cov_GE80<-sqldf("SELECT tree_cov_m.VALUE, tree_cov_m.variable, tree_cov_m.covPer
                      FROM tree_cov_m
                      WHERE (((Tree_cov_m.covPer)>80))
                      GROUP BY tree_cov_m.VALUE, tree_cov_m.variable, tree_cov_m.covPer
                      HAVING (((tree_cov_m.variable)<>'FCID'));")

#match stand records to tree records, combine into one table
stands_SDI<-sqldf("SELECT stand_list.Stand_CN, stand_list.Stand_ID, stand_list.Variant, 
                  stand_att.TREEPLBA, tree_cov_GE80.variable, tree_cov_GE80.covPer, stand_att.SDI
                  FROM (tree_cov_GE80 INNER JOIN stand_att ON tree_cov_GE80.VALUE = stand_att.StandCN) 
                  INNER JOIN stand_list ON stand_att.StandCN = stand_list.Stand_CN;
                  ")

#convert field to string from factor
stands_SDI$variable <-as.character(stands_SDI$variable)

#remove trailing spaces from TREEPLBA field
stands_SDI$TREEPLBA<-trim(stands_SDI$TREEPLBA)

#create a column to match to TREEPLBA from variable.  Remove "_cov" from field. 
stands_SDI$varTrim = substr(stands_SDI$variable,1,nchar(stands_SDI$variable)-4)

#if species with 80% cover matches the dominent species in the stand, set match = "Y"
stands_SDI$match <- ifelse(stands_SDI$varTrim == stands_SDI$TREEPLBA, "Y", "N")

#group by variant and species type
groupColumns = c("Variant","varTrim")

#calculate summary stats: 98%, 95%, and 90%, count of records in group
stats<-ddply(stands_SDI, groupColumns, summarise, SDI98 = quantile(SDI, .98), SDI95 = quantile(SDI, .95),
             SDI90 = quantile(SDI, .90),  freq=length(Variant))
