# install.packages("RPostgreSQL")
########################run after compile.R, uses some of the same tables. 
require("RPostgreSQL")
library(plyr)
require(dplyr)
library(data.table)

# create a connection
pw <- {
  "secret"
}

# load the PostgreSQL driver
drv <- dbDriver("PostgreSQL")
# create a connection to the postgres database
con <- dbConnect(drv, dbname = "FVSOut",
                 host = "localhost", port = 5432,
                 user = "sara", password = pw)
rm(pw) # remove the password

#read in rx specific tables
rx1bau <- dbReadTable(con, "rx1bau")
rx1fsc <- dbReadTable(con, "rx1fsc")
rx2 <- dbReadTable(con, "rx2")
rx2i <- dbReadTable(con, "rx2i")
rx2o <- dbReadTable(con, "rx2o")
rx3 <- dbReadTable(con, "rx3")
rx4 <- dbReadTable(con, "rx4")
rx5 <- dbReadTable(con, "rx5")
rx5i <- dbReadTable(con, "rx5i")
rx5o <- dbReadTable(con, "rx5o")
matrix <- dbReadTable(con, "matrix")
parcel<-dbReadTable(con, "parcel")

#ADD opposite buffers to the rx records. 
rx2_FSC<-merge(rx2, matrix[, c("standid","fsc")], by="standid")
rx3_FPA<-merge(rx3, matrix[, c("standid","non_rip")], by="standid")
rx4_FPA<-merge(rx4, matrix[, c("standid","non_rip")], by="standid")

#for each rx specific table:
#multiply the per acre values, with the number of acres treated by that package
#basically, expanding the per acre values by the number of acres
rx1bau$rbdftE<-rx1bau$rbdft * rx1bau$core
rx1fsc$rbdftE<- rx1fsc$rbdf * rx1fsc$fsc_grow
rx2$rbdftE<- rx2$rbdf * rx2$non_rip
rx3$rbdftE<- rx3$rbdf * rx3$fsc
rx4$rbdftE<- rx4$rbdf * rx4$fsc
rx5$rbdftE<- rx5$rbdf * rx5$non_rip
rx2i$rbdftE<- rx2i$rbdf * rx2i$inner
rx2o$rbdftE<- rx2o$rbdf * rx2o$outer
rx5i$rbdftE<- rx5i$rbdf * rx5i$inner
rx5o$rbdftE<- rx5o$rbdf * rx5o$outer
rx2_FSC$rbdftE<- rx2_FSC$rbdf * rx2_FSC$fsc
rx3_FPA$rbdftE<- rx3_FPA$rbdf * rx3_FPA$non_rip
rx4_FPA$rbdftE<- rx4_FPA$rbdf * rx4_FPA$non_rip

#specify the variables that we want to carry forward
myvars <- c("parcel","year", "rbdftE")

#subset the rx specific tables (expanded by acres)
# to include only the desired variables specified above
rx1bauS <- rx1bau[myvars]
rx1fscS <- rx1fsc[myvars]
rx2S <- rx2[myvars]
rx3S <- rx3[myvars]
rx4S <- rx4[myvars]
rx5S <- rx5[myvars]
rx2iS <- rx2i[myvars]
rx2oS <- rx2o[myvars]
rx5iS <- rx5i[myvars]
rx5oS <- rx5o[myvars]
rx2_FSCS <- rx2_FSC[myvars]
rx3_FPAS <- rx3_FPA[myvars]
rx4_FPAS <- rx4_FPA[myvars]


##################  RX2  FPA - FSC buffers #######################################################
#create a master table that contains all the treatments necessary for rx2 with FSC buffers
#merge them into one table - rx2all
rx2FSC<-rbind(rx1fscS, rx2_FSCS)

rx2FSC_m<-merge(rx2FSC, parcel[, c("parcel","total")], by="parcel")

#sum all the values
#grouping by standid, year, and total. 
#this will give us a total expanded sum for each stand 
#at each time point
FPA_FSC<- rx2FSC_m %>%
  group_by(parcel, year, total) %>%
  summarise_each(funs(sum))

#divide the expanded values by the total number of acres  
#average values over the stand for all treatment areas. 
FPA_FSC[, c(4)]<- FPA_FSC[, c(4)] / FPA_FSC$total

#change names 
setnames(FPA_FSC, old=c("rbdftE"), new=c("rbdft_wfsc"))

#merge with other dataframe containing actual FPA buffer expansions
rx2_b<-merge(BAU[, c("parcel", "rbdft", "year")], FPA_FSC[, c("parcel","rbdft_wfsc", "year")], by=c("parcel", "year"))


##################  RX3  FSC - short with FPA buffers################################################
#create a master table that contains all the treatments necessary for rx2 with FSC buffers
#merge them into one table - rx2all
rx3FPA<-rbind(rx1bauS, rx2iS, rx2oS, rx3_FPAS)

rx3FPA_m<-merge(rx3FPA, parcel[, c("parcel","total")], by="parcel")
#sum all the values
#grouping by standid, year, and total. 
#this will give us a total expanded sum for each stand 
#at each time point
FSC_FPA<- rx3FPA_m %>%
  group_by(parcel, year, total) %>%
  summarise_each(funs(sum))

#divide the expanded values by the total number of acres  
#average values over the stand for all treatment areas. 
FSC_FPA[, c(4)]<- FSC_FPA[, c(4)] / FSC_FPA$total

#change names 
setnames(FSC_FPA, old=c("rbdftE"), new=c("rbdft_wfpa"))

#merge with other dataframe containing actual FPA buffer expansions
rx3_b<-merge(FSC[, c("parcel", "rbdft", "year")], FSC_FPA[, c("parcel","rbdft_wfpa", "year")], by=c("parcel", "year"))

##################  RX4  FSC - long with FPA buffers################################################
#create a master table that contains all the treatments necessary for rx2 with FSC buffers
#merge them into one table - rx2all
rx4FPA<-rbind(rx1bauS, rx5iS, rx5oS, rx4_FPAS)

rx4FPA_m<-merge(rx4FPA, parcel[, c("parcel","total")], by="parcel")
#sum all the values
#grouping by standid, year, and total. 
#this will give us a total expanded sum for each stand 
#at each time point
FSClong_FPA<- rx4FPA_m %>%
  group_by(parcel, year, total) %>%
  summarise_each(funs(sum))

#divide the expanded values by the total number of acres  
#average values over the stand for all treatment areas. 
FSClong_FPA[, c(4)]<- FSClong_FPA[, c(4)] / FSClong_FPA$total

#change names 
setnames(FSClong_FPA, old=c("rbdftE"), new=c("rbdft_wfpa"))

#merge with other dataframe containing actual FPA buffer expansions
rx4_b<-merge(FSC[, c("parcel", "rbdft", "year")], FSClong_FPA[, c("parcel","rbdft_wfpa", "year")], by=c("parcel", "year"))


rm(rx4_FPA, rx4_FPAS, rx4all, rx4E, rx4FPA, rx4FPA_m, rx4S,
   rx3_FPA, rx3_FPAS, rx3all, rx3E, rx3FPA, rx3FPA_m, rx3S,
   rx2_FSC, rx2_FSCS, rx2all, rx2E, rx2FSC, rx2FSC_m, rx2S,
   rx1fscE, rx1fscS, rx1bauE, rx1bauS, rx5S, rx5oS, rx5iS, 
   rx5iE, rx2iS, rx2oE, rx2oS)


########CREATE COMBO TABLE####################
#convert bft to MBF
rx2_b$MBF=rx2_b$rbdft/1000
rx3_b$MBF=rx3_b$rbdft/1000
rx4_b$MBF=rx4_b$rbdft/1000

rx2_b$MBFs=rx2_b$rbdft_wfsc/1000
rx3_b$MBFs=rx3_b$rbdft_wfpa/1000
rx4_b$MBFs=rx4_b$rbdft_wfpa/1000


rx2_s<- rx2_b %>% 
  group_by(parcel) %>% 
  summarise(bauMBF=sum(MBF), bauMBFs=sum(MBFs))

rx3_s<- rx3_b %>% 
  group_by(parcel) %>% 
  summarise(fscMBF=sum(MBF), fscMBFs=sum(MBFs))

rx4_s<- rx4_b %>% 
  group_by(parcel) %>% 
  summarise(fsclongMBF=sum(MBF), fsclongMBFs=sum(MBFs))

#merge tables
switch<-merge(rx2_s, rx3_s, by="parcel")
switchAll<-merge(switch, rx4_s, by="parcel")

#drop unneeded tables
rm(rx2_b, rx3_b, rx4_b, rx2_s, rx3_s, rx4_s)

#### calculate percents
switchAll$perFSC_FSCbuff=((switchAll$fscMBF-switchAll$bauMBF)/switchAll$bauMBF)*100
switchAll$perFSClong_FSCbuff=((switchAll$fsclongMBF-switchAll$bauMBF)/switchAll$bauMBF)*100
switchAll$perFSC_FPAbuff=((switchAll$fscMBFs-switchAll$bauMBF)/switchAll$bauMBF)*100
switchAll$perFSClong_FPAbuff=((switchAll$fsclongMBFs-switchAll$bauMBF)/switchAll$bauMBF)*100
switchAll$perFPA_FSCbuff=((switchAll$bauMBFs-switchAll$bauMBF)/switchAll$bauMBF)*100

#create a summary table
table<- switchAll %>% 
  summarise(FSC_FSCbuff=mean(perFSC_FSCbuff), FSClong_FSCbuff=mean(perFSClong_FSCbuff), 
            FSC_FPAbuff=mean(perFSC_FPAbuff), FSClong_FPAbuff=mean(perFSClong_FPAbuff), 
            FPA_FSCbuff=mean(perFPA_FSCbuff))