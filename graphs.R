#data pulled into R in compile.R script. must run that first

setwd("C:/Users/sloreno/FSC_Case_Studies/graphing")

#load packages
library(RODBC)
library(ggplot2)
library(sqldf)
library(reshape2)
library(fBasics)
library(data.table)
library(yarrr)
library(ggthemes)
library(scales)
library(plyr)
library(beanplot)
library(data.table)
library(cowplot)
library(easyGgplot2)


#Convert IN FOREST metric tons to carbon equivalent
BAU_p$cpaE=BAU_p$total_stand_carbon*3.67
BAU_long_p$cpaE=BAU_long_p$total_stand_carbon*3.67
FSC_p$cpaE=FSC_p$total_stand_carbon*3.67
FSC_long_p$cpaE=FSC_long_p$total_stand_carbon*3.67

#Convert MERCH WOOD metric tons of to carbon equivalent
BAU_p$wpaE=BAU_p$products*3.67
BAU_long_p$wpaE=BAU_long_p$products*3.67
FSC_p$wpaE=FSC_p$products*3.67
FSC_long_p$wpaE=FSC_long_p$products*3.67

#convert bft to MBF
BAU_p$MBF=BAU_p$rbdft/1000
BAU_long_p$MBF=BAU_long_p$rbdft/1000
FSC_p$MBF=FSC_p$rbdft/1000
FSC_long_p$MBF=FSC_long_p$rbdft/1000


########################## AVERAGE CARBON IN FOREST ##############################
#BAU CARBON
#BAU carbon per acre hurricane chart
#calculate quantiles
BAUcpa<-as.data.table(BAU_p)[, c(as.list(quantile(cpaE)), 
                               avg=mean(cpaE), n=.N), by=year]
#rename variable names in BAUcpa table
BAUcpa<-rename(BAUcpa, c("0%"="x0", "25%"="x25","50%"="x50","75%"="x75","100%"="x100"))

#create BAU hurricane graph
ggplot(data=BAUcpa) + 
  geom_ribbon(aes(x=year, ymin=x0, ymax=x100),fill="#56B4E9", alpha=0.6)+
  geom_ribbon(aes(x=year, ymin=x25, ymax=x75),fill="#0072B2", alpha=0.8)+
  geom_line(aes(x=year, y=avg),colour="#D55E00", size=1.2)+
  theme_minimal(base_size = 22)+
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank())+
  ylim(0,400)
ggsave("BAU.png")

#FSC CARBON
#FSC carbon per acre hurricane chart
#calculate quantiles
FSCcpa<-as.data.table(FSC_p)[, c(as.list(quantile(cpaE)), 
                               avg=mean(cpaE), n=.N), by=year]
#rename variable names in BAUcpa table
FSCcpa<-rename(FSCcpa, c("0%"="x0", "25%"="x25","50%"="x50","75%"="x75","100%"="x100"))

#create fSC hurricane graph
ggplot(data=FSCcpa) + 
  geom_ribbon(aes(x=year, ymin=x0, ymax=x100),fill="#F0E442", alpha=0.6)+
  geom_ribbon(aes(x=year, ymin=x25, ymax=x75),fill="#E69F00", alpha=0.8)+
  geom_line(aes(x=year, y=avg),colour="#D55E00", size=1.2)+
  theme_minimal(base_size = 22)+
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank())+
  ylim(0,400)
ggsave("FSC.png")

#FSClong CARBON
#FSClong carbon per acre hurricane chart
#calculate quantiles
FSClongcpa<-as.data.table(FSC_long_p)[, c(as.list(quantile(cpaE)), 
                                       avg=mean(cpaE), n=.N), by=year]
#rename variable names in FSClongcpa table
FSClongcpa<-rename(FSClongcpa, c("0%"="x0", "25%"="x25","50%"="x50","75%"="x75","100%"="x100"))

#create fSClong hurricane graph
ggplot(data=FSClongcpa) + 
  geom_ribbon(aes(x=year, ymin=x0, ymax=x100),fill="#F0E442", alpha=0.6)+
  geom_ribbon(aes(x=year, ymin=x25, ymax=x75),fill="#E69F00", alpha=0.8)+
  geom_line(aes(x=year, y=avg),colour="#D55E00", size=1.2)+
  theme_minimal(base_size = 22)+
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank())+
  ylim(0,400)
ggsave("FSClong.png")

#BAUlong CARBON
#BAUlong carbon per acre hurricane chart
#calculate quantiles
BAUlongcpa<-as.data.table(BAU_long_p)[, c(as.list(quantile(cpaE)), 
                                          avg=mean(cpaE), n=.N), by=year]
#rename variable names in FSClongcpa table
BAUlongcpa<-rename(BAUlongcpa, c("0%"="x0", "25%"="x25","50%"="x50","75%"="x75","100%"="x100"))

#create fSClong hurricane graph
ggplot(data=BAUlongcpa) + 
  geom_ribbon(aes(x=year, ymin=x0, ymax=x100),fill="#56B4E9", alpha=0.6)+
  geom_ribbon(aes(x=year, ymin=x25, ymax=x75),fill="#0072B2", alpha=0.8)+
  geom_line(aes(x=year, y=avg),colour="#D55E00", size=1.2)+
  theme_minimal(base_size = 22)+
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank())+
  ylim(0,400)
ggsave("BAUlong.png")




################# IN PRODUCT CARBON ##############################################################
#BAU MERCH
#BAU merch wood per acre hurricane chart
#calculate quantiles
BAUwpa<-as.data.table(BAU_p)[, c(as.list(quantile(wpaE, na.rm=T)), 
                               avg=mean(wpaE), n=.N), by=year]
#rename variable names in BAUwpa table
BAUwpa<-rename(BAUwpa, c("0%"="x0", "25%"="x25","50%"="x50","75%"="x75","100%"="x100"))

#create BAU hurricane graph
ggplot(data=BAUwpa) + 
  geom_ribbon(aes(x=year, ymin=x0, ymax=x100),fill="#56B4E9", alpha=0.6)+
  geom_ribbon(aes(x=year, ymin=x25, ymax=x75),fill="#0072B2", alpha=0.8)+
  geom_line(aes(x=year, y=avg),colour="#009E73", size=1.2)+
  theme_minimal(base_size = 22)+
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank())+
  ylim(0,1100)
ggsave("BAUwpa.png")

#FSC MERCH
#FSC merch wood per acre hurricane chart
#calculate quantiles
FSCwpa<-as.data.table(FSC_p)[, c(as.list(quantile(wpaE, na.rm=T)), 
                               avg=mean(wpaE), n=.N), by=year]
#rename variable names in FSCwpa table
FSCwpa<-rename(FSCwpa, c("0%"="x0", "25%"="x25","50%"="x50","75%"="x75","100%"="x100"))

#create FSC hurricane graph
ggplot(data=FSCwpa) + 
  geom_ribbon(aes(x=year, ymin=x0, ymax=x100),fill="#F0E442", alpha=0.6)+
  geom_ribbon(aes(x=year, ymin=x25, ymax=x75),fill="#E69F00", alpha=0.8)+
  geom_line(aes(x=year, y=avg),colour="#009E73", size=1.2)+
  theme_minimal(base_size = 22)+
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank())+
  ylim(0,1100)
ggsave("FSCwpa.png")

#FSClong MERCH
#FSClomg merch wood per acre hurricane chart
#calculate quantiles
FSClongwpa<-as.data.table(FSC_long_p)[, c(as.list(quantile(wpaE, na.rm=T)), 
                                       avg=mean(wpaE), n=.N), by=year]
#rename variable names in FSCwpa table
FSClongwpa<-rename(FSClongwpa, c("0%"="x0", "25%"="x25","50%"="x50","75%"="x75","100%"="x100"))

#create FSC hurricane graph
ggplot(data=FSClongwpa) + 
  geom_ribbon(aes(x=year, ymin=x0, ymax=x100),fill="#F0E442", alpha=0.6)+
  geom_ribbon(aes(x=year, ymin=x25, ymax=x75),fill="#E69F00", alpha=0.8)+
  geom_line(aes(x=year, y=avg),colour="#009E73", size=1.2)+
  theme_minimal(base_size = 22)+
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank())+
  ylim(0,1100)
ggsave("FSClongwpa.png")

#BAUlong MERCH
#BAUlomg merch wood per acre hurricane chart
#calculate quantiles
BAUlongwpa<-as.data.table(BAU_long_p)[, c(as.list(quantile(wpaE, na.rm=T)), 
                                          avg=mean(wpaE), n=.N), by=year]
#rename variable names in FSCwpa table
BAUlongwpa<-rename(BAUlongwpa, c("0%"="x0", "25%"="x25","50%"="x50","75%"="x75","100%"="x100"))

#create FSC hurricane graph
ggplot(data=BAUlongwpa) + 
  geom_ribbon(aes(x=year, ymin=x0, ymax=x100),fill="#56B4E9", alpha=0.6)+
  geom_ribbon(aes(x=year, ymin=x25, ymax=x75),fill="#0072B2", alpha=0.8)+
  geom_line(aes(x=year, y=avg),colour="#009E73", size=1.2)+
  theme_minimal(base_size = 22)+
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank())+
  ylim(0,1100)
ggsave("BAUlongwpa.png")



######  MBF  ########################################################################################

#BAU MBF
library(plyr)

#calculate cummulative volumes
BAU2<-ddply(BAU_p,.(parcel),transform,csum=cumsum(MBF))
#BAU merch wood per acre hurricane chart
#calculate quantiles
BAUMBF<-as.data.table(BAU2)[, c(as.list(quantile(csum, na.rm=T)), 
                                avg=mean(csum), n=.N), by=year]
#rename variable names in BAUwpa table
BAUMBF<-rename(BAUMBF, c("0%"="x0", "25%"="x25","50%"="x50","75%"="x75","100%"="x100"))

#create BAU hurricane graph
ggplot(data=BAUMBF) + 
  geom_ribbon(aes(x=year, ymin=x0, ymax=x100),fill="#56B4E9", alpha=0.6)+
  geom_ribbon(aes(x=year, ymin=x25, ymax=x75),fill= "#0072B2", alpha=0.8)+
  geom_line(aes(x=year, y=avg),colour="#0072B2", size=1.2)+
  theme_minimal(base_size = 22)+
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank())+
  ylim(0,150)
ggsave("BAUMBF2.png")


#FSC MBF
FSC2<-ddply(FSC_p,.(parcel),transform,csum=cumsum(MBF))
#BAU merch wood per acre hurricane chart
#calculate quantiles
FSCMBF<-as.data.table(FSC2)[, c(as.list(quantile(csum, na.rm=T)), 
                                avg=mean(csum), n=.N), by=year]
#rename variable names in BAUwpa table
FSCMBF<-rename(FSCMBF, c("0%"="x0", "25%"="x25","50%"="x50","75%"="x75","100%"="x100"))

#create BAU hurricane graph
ggplot(data=FSCMBF) + 
  geom_ribbon(aes(x=year, ymin=x0, ymax=x100),fill="#F0E442", alpha=0.6)+
  geom_ribbon(aes(x=year, ymin=x25, ymax=x75),fill= "#E69F00", alpha=0.8)+
  geom_line(aes(x=year, y=avg),colour="#0072B2", size=1.2)+
  theme_minimal(base_size = 22)+
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank())+
  ylim(0,150)
ggsave("FSCMBF2.png")

#FSClong MBF
FSClong2<-ddply(FSC_long_p,.(parcel),transform,csum=cumsum(MBF))
#FSClong merch wood per acre hurricane chart
#calculate quantiles
FSClongMBF<-as.data.table(FSClong2)[, c(as.list(quantile(csum, na.rm=T)), 
                                        avg=mean(csum), n=.N), by=year]
#rename variable names in BAUwpa table
FSClongMBF<-rename(FSClongMBF, c("0%"="x0", "25%"="x25","50%"="x50","75%"="x75","100%"="x100"))

#create FSClong hurricane graph
ggplot(data=FSClongMBF) + 
  geom_ribbon(aes(x=year, ymin=x0, ymax=x100),fill="#F0E442", alpha=0.6)+
  geom_ribbon(aes(x=year, ymin=x25, ymax=x75),fill= "#E69F00", alpha=0.8)+
  geom_line(aes(x=year, y=avg),colour="#0072B2", size=1.2)+
  theme_minimal(base_size = 22)+
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank())+
  ylim(0,180)
ggsave("FSClongMBF2.png")

#BAUlong MBF
BAUlong2<-ddply(BAU_long_p,.(parcel),transform,csum=cumsum(MBF))
#BAUlong merch wood per acre hurricane chart
#calculate quantiles
BAUlongMBF<-as.data.table(BAUlong2)[, c(as.list(quantile(csum, na.rm=T)), 
                                        avg=mean(csum), n=.N), by=year]
#rename variable names in BAUwpa table
BAUlongMBF<-rename(BAUlongMBF, c("0%"="x0", "25%"="x25","50%"="x50","75%"="x75","100%"="x100"))

#create BAUlong hurricane graph
ggplot(data=BAUlongMBF) + 
  geom_ribbon(aes(x=year, ymin=x0, ymax=x100),fill="#56B4E9", alpha=0.6)+
  geom_ribbon(aes(x=year, ymin=x25, ymax=x75),fill= "#0072B2", alpha=0.8)+
  geom_line(aes(x=year, y=avg),colour="#0072B2", size=1.2)+
  theme_minimal(base_size = 22)+
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank())+
  ylim(0,180)
ggsave("BAUlongMBF2.png")


#####################RIP PERCENT#################################################
rip_buff <- rip_buff[c(1,5:6)]
rip_buff_m<-melt(rip_buff, id="parcel")

ggplot2.density(data=rip_buff_m, xName='value', groupName='variable',
                groupColors=c('#999999','#E69F00'),
                fillGroupDensity=TRUE, alpha=0.5,
                legendPosition="top")

ggplot2.histogram(data=rip_buff_m, xName='value', groupName='variable',
                  legendPosition="top", binwidth = 3,
                  groupColors=c('#999999','#E69F00'), alpha=0.5,
                  addMeanLine=TRUE, meanLineColor="black",
                  meanLineType="dashed", meanLineSize=1)+
  scale_x_continuous(breaks = c(0, 10, 20, 30, 40, 50))+
  xlab("Riparian Buffer Percent")+
  ylab("Stand Count")
ggsave("rip_buff.png")
################################################################################

close(con2)

