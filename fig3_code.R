library(ggplot2)
library(cowplot)
library(dplyr)
library(tidyverse)
library(ggprism)

# default data folder
main_dir = "D:/research/TPerception/TPerception-Tibet"

# Chisq.test and cramers'V for the binned data
datafile<-paste(main_dir, "/code/figure/fig3/fig3f_data.csv", sep='')
df<-read.csv(datafile, encoding = 'UTF-8')
df<-df[,c('warmer','other')]
chisq.test(df,correct = FALSE)
effectsize::cramers_v(df) #人工记录结果

# divide into two halves and perform proportion test
datafile<-paste(main_dir, "/data/out/tperception_tibet.csv", sep='')
df <- read.csv(datafile, encoding = 'UTF-8')
df$y1_b<-0 # 温度变化感知
df$y1_b[which(df$y1_c=='warming')]<-1
df <- df[c('y1_b','k_T_30a','k_Tt_30a','k_P_30a','k_Pt_30a','k_TXDt_30a','k_PTDt_30a')]

var<-df$k_Tt_30a
df$binary<- cut(var, breaks=2,include.lowest=T)
df_binary<-df %>% 
  group_by(binary) %>% 
  summarise(warmer = sum(y1_b), other=n()-sum(y1_b), total = n(),ratio=sum(y1_b)/n())%>%
  as.data.frame()
prop.test(x=df_binary[,'warmer'],n=df_binary[,'total'])

#Plot
cbPalette <- c("#56B4E9", "#009E73", "#E69F00", "#D55E00")
datafile<-paste(main_dir, "/code/figure/fig3/fig3a_data.csv", sep='')
df_a<-read.csv(datafile, encoding = 'UTF-8')
df_a$xlabels<-as.integer(substr(df_a[,1],2,str_locate(df_a[,1],"\\,")-1))
fig3a<-ggplot(df_a, aes(x=xlabels)) + 
  geom_bar(aes(y=total/1000),fill='lightgrey',stat="identity",position = position_nudge(x = 1))+
  geom_bar(aes(y=warmer/1000),fill=cbPalette[4],stat="identity",position = position_nudge(x = 1))
fig3a<-fig3a + theme_classic() + 
  labs(x = "Temperature (°C)") +
  labs(y = expression("Frequency (10"^3*")")) +
  scale_x_continuous(breaks = df_a$xlabels[seq(1,nrow(df_a),2)],
                     guide = 'prism_minor',
                     minor_breaks = df_a$xlabels[seq(2,nrow(df_a),2)]) +
  theme(axis.line = element_line(size = 0.25),
        axis.ticks = element_line(size = 0.25),
        legend.position = 'none',
        text=element_text(size=7,family="sans"))
fig3a
outfile<-paste(main_dir, "/code/figure/fig3/fig3a.tiff", sep='')
ggsave(
  outfile,
  width = 5,
  height = 4,
  units = "cm",
  dpi = 300
)

datafile<-paste(main_dir, "/code/figure/fig3/fig3b_data.csv", sep='')
df_b<-read.csv(datafile, encoding = 'UTF-8')
df_b$xlabels<-as.double(substr(df_b[,1],2,str_locate(df_b[,1],"\\,")-1))*10
fig3b<-ggplot(df_b, aes(x=xlabels)) + 
  geom_bar(aes(y=total/1000),fill='lightgrey',stat="identity",position = position_nudge(x = 0.05))+
  geom_bar(aes(y=warmer/1000),fill=cbPalette[4],stat="identity",position = position_nudge(x = 0.05))
fig3b<-fig3b + theme_classic() + 
  labs(x = "Temperature trend (°C/decade)") +
  labs(y = expression("Frequency (10"^3*")")) +
  scale_x_continuous(breaks = df_b$xlabels[seq(1,nrow(df_b),2)],
                     guide = 'prism_minor',
                     minor_breaks = df_b$xlabels[seq(2,nrow(df_b),2)]) +
  theme(axis.line = element_line(size = 0.25),
        axis.ticks = element_line(size = 0.25),
        legend.position = 'none',
        text=element_text(size=7,family="sans"))
fig3b
outfile<-paste(main_dir, "/code/figure/fig3/fig3b.tiff", sep='')
ggsave(
  outfile,
  width = 5,
  height = 4,
  units = "cm",
  dpi = 300
)

datafile<-paste(main_dir, "/code/figure/fig3/fig3c_data.csv", sep='')
df_c<-read.csv(datafile, encoding = 'UTF-8')
df_c$xlabels<-as.double(substr(df_c[,1],2,str_locate(df_c[,1],"\\,")-1))/100
fig3c<-ggplot(df_c, aes(x=xlabels)) + 
  geom_bar(aes(y=total/1000),fill='lightgrey',stat="identity",position = position_nudge(x = 1))+
  geom_bar(aes(y=warmer/1000),fill=cbPalette[4],stat="identity",position = position_nudge(x = 1))
fig3c<-fig3c + theme_classic() + 
  labs(x = "Precipitation (100 mm)") +
  labs(y = expression("Frequency (10"^3*")")) +
  scale_x_continuous(breaks = df_c$xlabels[seq(1,nrow(df_c),2)],
                     guide = 'prism_minor',
                     minor_breaks = df_c$xlabels[seq(2,nrow(df_c),2)]) +
  scale_y_continuous(breaks = seq(0,10,2)) +
  theme(axis.line = element_line(size = 0.25),
        axis.ticks = element_line(size = 0.25),
        legend.position = 'none',
        text=element_text(size=7,family="sans"))
fig3c
outfile<-paste(main_dir, "/code/figure/fig3/fig3c.tiff", sep='')
ggsave(
  outfile,
  width = 5,
  height = 4,
  units = "cm",
  dpi = 300
)

datafile<-paste(main_dir, "/code/figure/fig3/fig3d_data.csv", sep='')
df_d<-read.csv(datafile, encoding = 'UTF-8')
df_d$xlabels<-as.double(substr(df_d[,1],2,str_locate(df_d[,1],"\\,")-1))*10
fig3d<-ggplot(df_d, aes(x=xlabels)) + 
  geom_bar(aes(y=total/1000),fill='lightgrey',stat="identity",position = position_nudge(x = 10))+
  geom_bar(aes(y=warmer/1000),fill=cbPalette[4],stat="identity",position = position_nudge(x = 10))
fig3d<-fig3d + theme_classic() + 
  labs(x = "Precipitation trend (mm/decade)") +
  labs(y = expression("Frequency (10"^3*")")) +
  scale_x_continuous(breaks = df_d$xlabels[seq(1,nrow(df_d),2)],
                     guide = 'prism_minor',
                     minor_breaks = df_d$xlabels[seq(2,nrow(df_d),2)]) +
  scale_y_continuous(breaks = seq(0,10,2)) +
  theme(axis.line = element_line(size = 0.25),
        axis.ticks = element_line(size = 0.25),
        legend.position = 'none',
        text=element_text(size=7,family="sans"))
fig3d
outfile<-paste(main_dir, "/code/figure/fig3/fig3d.tiff", sep='')
ggsave(
  outfile,
  width = 5,
  height = 4,
  units = "cm",
  dpi = 300
)

datafile<-paste(main_dir, "/code/figure/fig3/fig3e_data.csv", sep='')
df_e<-read.csv(datafile, encoding = 'UTF-8')
df_e$xlabels<-as.double(substr(df_e[,1],2,str_locate(df_e[,1],"\\,")-1))*10
fig3e<-ggplot(df_e, aes(x=xlabels)) + 
  geom_bar(aes(y=total/1000),fill='lightgrey',stat="identity",position = position_nudge(x = 1))+
  geom_bar(aes(y=warmer/1000),fill=cbPalette[4],stat="identity",position = position_nudge(x = 1))
fig3e<-fig3e + theme_classic() + 
  labs(x = "TXDt (day/decade)") +
  labs(y = expression("Frequency (10"^3*")")) +
  scale_x_continuous(breaks = df_e$xlabels[seq(1,nrow(df_e),2)],
                     guide = 'prism_minor',
                     minor_breaks = df_e$xlabels[seq(2,nrow(df_e),2)]) +
  theme(axis.line = element_line(size = 0.25),
        axis.ticks = element_line(size = 0.25),
        legend.position = 'none',
        text=element_text(size=7,family="sans"))
fig3e
outfile<-paste(main_dir, "/code/figure/fig3/fig3e.tiff", sep='')
ggsave(
  outfile,
  width = 5,
  height = 4,
  units = "cm",
  dpi = 300
)

datafile<-paste(main_dir, "/code/figure/fig3/fig3f_data.csv", sep='')
df_f<-read.csv(datafile, encoding = 'UTF-8')
df_f$xlabels<-as.double(substr(df_f[,1],2,str_locate(df_f[,1],"\\,")-1))*10
fig3f<-ggplot(df_f, aes(x=xlabels)) + 
  geom_bar(aes(y=total/1000),fill='lightgrey',stat="identity",position = position_nudge(x = 1))+
  geom_bar(aes(y=warmer/1000),fill=cbPalette[4],stat="identity",position = position_nudge(x = 1))
fig3f<-fig3f + theme_classic() + 
  labs(x = "PTDt (day/decade)") +
  labs(y = expression("Frequency (10"^3*")")) +
  scale_x_continuous(breaks = df_f$xlabels[seq(1,nrow(df_f),2)],
                     guide = 'prism_minor',
                     minor_breaks = df_f$xlabels[seq(2,nrow(df_f),2)]) +
  theme(axis.line = element_line(size = 0.25),
        axis.ticks = element_line(size = 0.25),
        legend.position = 'none',
        text=element_text(size=7,family="sans"))
fig3f
outfile<-paste(main_dir, "/code/figure/fig3/fig3f.tiff", sep='')
ggsave(
  outfile,
  width = 5,
  height = 4,
  units = "cm",
  dpi = 300
)
