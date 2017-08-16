# install.packages("RPostgreSQL")
require("RPostgreSQL")
require(dplyr)

# create a connection
pw <- {
  "r0bin"
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
rip_buff<-dbReadTable(con, "rip_percent")

#for each rx specific table:
#multiply the per acre values, with the number of acres treated by that package
#basically, expanding the per acre values by the number of acres
rx1bau[, c(9:16)]<- rx1bau[, c(9:16)] * rx1bau$core
rx1fsc[, c(9:16)]<- rx1fsc[, c(9:16)] * rx1fsc$fsc_grow
rx2[, c(9:16)]<- rx2[, c(9:16)] * rx2$non_rip
rx3[, c(9:16)]<- rx3[, c(9:16)] * rx3$fsc
rx4[, c(9:16)]<- rx4[, c(9:16)] * rx4$fsc
rx5[, c(9:16)]<- rx5[, c(9:16)] * rx5$non_rip
rx2i[, c(9:16)]<- rx2i[, c(9:16)] * rx2i$inner
rx2o[, c(9:16)]<- rx2o[, c(9:16)] * rx2o$outer
rx5i[, c(9:16)]<- rx5i[, c(9:16)] * rx5i$inner
rx5o[, c(9:16)]<- rx5o[, c(9:16)] * rx5o$outer

#specify the variables that we want to carry forward
myvars <- c("standid", "parcel", "total", "year", "bdft", "rbdft", "total_stand_carbon", "aboveground_total_live",
            "total_removed_carbon", "carbon_released_from_fire", "merch_carbon_stored", "products")

#subset the rx specific tables (expanded by acres)
# to include only the desired variables specified above
#filter out stands less than 1 acre in size
#filter out stands with no trees
rx1bau_sub <- rx1bau[myvars]
rx1bau_sub <- subset(rx1bau_sub, bdft>0 & total>1)
rx1fsc_sub <- rx1fsc[myvars]
rx1fsc_sub <- subset(rx1bau_sub, bdft>0 & total>1)
rx2_sub <- rx2[myvars]
rx2_sub <- subset(rx2_sub, bdft>0 & total>1)
rx3_sub <- rx3[myvars]
rx3_sub <- subset(rx3_sub, bdft>0 & total>1)
rx4_sub <- rx4[myvars]
rx4_sub <- subset(rx4_sub, bdft>0 & total>1)
rx5_sub <- rx5[myvars]
rx5_sub <- subset(rx5_sub, bdft>0 & total>1)
rx2i_sub <- rx2i[myvars]
rx2i_sub <- subset(rx2i_sub, bdft>0 & total>1)
rx2o_sub <- rx2o[myvars]
rx2o_sub <- subset(rx2o_sub, bdft>0 & total>1)
rx5i_sub <- rx5i[myvars]
rx5i_sub <- subset(rx5i_sub, bdft>0 & total>1)
rx5o_sub <- rx5o[myvars]
rx5o_sub <- subset(rx5o_sub, bdft>0 & total>1)


##################  RX2  BAU - short #####################################################################################
#create a master table that contains all the treatments necessary for rx2
#merge them into one table - rx2all
#this table includes the grow only (for core areas), 
#rx2 (for non-riparian acres),
#rx2inner (for acres in the inner buffer), 
#rx2outer (for acres in the outer buffer)
rx2all<-rbind(rx1bau_sub, rx2_sub, rx2i_sub, rx2o_sub)

#sum all the values
#grouping by standid, year, and total. 
#this will give us a total expanded sum for each stand 
#at each time point
BAU<- rx2all %>%
  group_by(parcel, standid, year, total) %>%
  summarise_each(funs(sum))

#divide the expanded values by the total number of acres to the 
#average values over the stand for all treatment areas. 
BAU[, c(4:11)]<- BAU[, c(4:11)] / BAU$total

#calculate the average value over the parcel
BAU_p<-BAU %>%
  group_by(parcel, year, total) %>%
  summarise_each(funs(mean)) 

##################  RX3  FSC - short #####################################################################################
#create a master table that contains all the treatments necessary for rx3
#merge them into one table - rx3all
#this table includes the grow only (for fsc buffers), 
#rx3 (for non-riparian acres),
rx3all<-rbind(rx1fsc_sub, rx3_sub)

#sum all the values
#grouping by standid, year, and total. 
#this will give us a total expanded sum for each stand 
#at each time point
FSC<- rx3all %>%
  group_by(parcel, standid, year, total) %>%
  summarise_each(funs(sum))

#divide the expanded values by the total number of acres to the 
#average values over the stand for all treatment areas. 
FSC[, c(4:11)]<- FSC[, c(4:11)] / FSC$total

#calculate the average value over the parcel
FSC_p<-FSC %>%
  group_by(parcel, year, total) %>%
  summarise_each(funs(mean)) 


##################  RX4  FSC - long #####################################################################################
#create a master table that contains all the treatments necessary for rx4
#merge them into one table - rx4all
#this table includes the grow only (for fsc buffers), 
#rx4 (for non-riparian acres),
rx4all<-rbind(rx1fsc_sub, rx4_sub)

#sum all the values
#grouping by standid, year, and total. 
#this will give us a total expanded sum for each stand 
#at each time point
FSC_long<- rx4all %>%
  group_by(parcel, standid, year, total) %>%
  summarise_each(funs(sum))

#divide the expanded values by the total number of acres to the 
#average values over the stand for all treatment areas. 
FSC_long[, c(4:11)]<- FSC_long[, c(4:11)] / FSC_long$total

#calculate the average value over the parcel
FSC_long_p<-FSC_long %>%
  group_by(parcel, year, total) %>%
  summarise_each(funs(mean)) 

##################  RX5  BAU - long #####################################################################################
#create a master table that contains all the treatments necessary for rx5
#merge them into one table - rx5all
#this table includes the grow only (for core areas), 
#rx5 (for non-riparian acres),
#rx5inner (for acres in the inner buffer), 
#rx5outer (for acres in the outer buffer)
rx5all<-rbind(rx1bau_sub, rx5_sub, rx5i_sub, rx5o_sub)

#sum all the values
#grouping by standid, year, and total. 
#this will give us a total expanded sum for each stand 
#at each time point
BAU_long<- rx5all %>%
  group_by(parcel, standid, year, total) %>%
  summarise_each(funs(sum))

#divide the expanded values by the total number of acres to the 
#average values over the stand for all treatment areas. 
BAU_long[, c(4:11)]<- BAU_long[, c(4:11)] / BAU_long$total

#calculate the average value over the parcel
BAU_long_p<-BAU_long %>%
  group_by(parcel, year, total) %>%
  summarise_each(funs(mean)) 
