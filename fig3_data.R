library(dplyr)
library(tidyverse)

# default data folder
main_dir = "D:/research/TPerception/TPerception-Tibet"

# data processing
datafile<-paste(main_dir, "/data/out/tperception_tibet.csv", sep='')
df <- read.csv(datafile, encoding = 'UTF-8')
df$y1_b<-0 # 温度变化感知
df$y1_b[which(df$y1_c=='warming')]<-1
df <- df[c('y1_b','k_T_30a','k_Tt_30a','k_P_30a','k_Pt_30a','k_TXDt_30a','k_PTDt_30a')]

#divide by equal intervals
T30a_xlabels<-seq(-4, 22, by = 2)
df$T30a_bins<- cut(df$k_T_30a, breaks=T30a_xlabels,include.lowest=T)

Tt30a_xlabels<-seq(0.03, 0.13, by = 0.01)
df$Tt30a_bins<- cut(round(df$k_Tt_30a,2), breaks=Tt30a_xlabels,include.lowest=T)

T30a_xlabels<-seq(100, 1700, by = 200)
df$P30a_bins<- cut(df$k_P_30a, breaks=T30a_xlabels,include.lowest=T)

Pt30a_xlabels<-seq(-10, 6, by = 2)
df$Pt30a_bins<- cut(df$k_Pt_30a, breaks=Pt30a_xlabels,include.lowest=T)

TXDt30a_xlabels<-seq(0.7, 2.7, by = 0.2)
df$TXDt30a_bins<- cut(df$k_TXDt_30a, breaks=TXDt30a_xlabels,include.lowest=T)

PTDt30a_xlabels<-seq(-1.0, 1.2, by = 0.2)
df$PTDt30a_bins<- cut(df$k_PTDt_30a, breaks=PTDt30a_xlabels,include.lowest=T)

#统计分组中的warmer perception
df_T30a<-df %>% 
  group_by(T30a_bins) %>% 
  summarise(warmer = sum(y1_b), other=n()-sum(y1_b), total = n(),ratio=sum(y1_b)/n())%>%
  as.data.frame()
df_Tt30a<-df %>% 
  group_by(Tt30a_bins) %>% 
  summarise(warmer = sum(y1_b), other=n()-sum(y1_b), total = n(),ratio=sum(y1_b)/n())%>%
  as.data.frame()
df_P30a<-df %>% 
  group_by(P30a_bins) %>% 
  summarise(warmer = sum(y1_b), other=n()-sum(y1_b), total = n(),ratio=sum(y1_b)/n())%>%
  as.data.frame()
df_Pt30a<-df %>% 
  group_by(Pt30a_bins) %>% 
  summarise(warmer = sum(y1_b), other=n()-sum(y1_b), total = n(),ratio=sum(y1_b)/n())%>%
  as.data.frame()
df_TXDt30a<-df %>% 
  group_by(TXDt30a_bins) %>% 
  summarise(warmer = sum(y1_b), other=n()-sum(y1_b), total = n(),ratio=sum(y1_b)/n())%>%
  as.data.frame()
df_PTDt30a<-df %>% 
  group_by(PTDt30a_bins) %>% 
  summarise(warmer = sum(y1_b), other=n()-sum(y1_b), total = n(),ratio=sum(y1_b)/n())%>%
  as.data.frame()

# save data on local disk
outfile<-paste(main_dir, "/code/figure/fig3/fig3a_data.csv", sep='')
write.csv(df_T30a,outfile,row.names = FALSE)
outfile<-paste(main_dir, "/code/figure/fig3/fig3b_data.csv", sep='')
write.csv(df_Tt30a,outfile,row.names = FALSE)
outfile<-paste(main_dir, "/code/figure/fig3/fig3c_data.csv", sep='')
write.csv(df_P30a,outfile,row.names = FALSE)
outfile<-paste(main_dir, "/code/figure/fig3/fig3d_data.csv", sep='')
write.csv(df_Pt30a,outfile,row.names = FALSE)
outfile<-paste(main_dir, "/code/figure/fig3/fig3e_data.csv", sep='')
write.csv(df_TXDt30a,outfile,row.names = FALSE)
outfile<-paste(main_dir, "/code/figure/fig3/fig3f_data.csv", sep='')
write.csv(df_PTDt30a,outfile,row.names = FALSE)
