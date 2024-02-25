library(lme4)
library(lmerTest)
library(effects)
library(sjPlot)
library(jtools)
library(tidyverse)

# default data folder
main_dir = "D:/research/TPerception/TPerception-Tibet"


# input data
infile<-paste(main_dir, "/data/out/tperception_tibet.csv", sep='')
df <- read.csv(infile)

# response 二值化
df$y1_b<-0 # 温度变化感知
df$y1_b[which(df$y1_c=='warming')]<-1

df$y2_b<-0 # 降水变化感知
df$y2_b[which(df$y2_c=='increased')]<-1

df$y7_b<-0 # 适应能力
df$y7_b[which(df$y7_c=='good' | df$y7_c=='very good')]<-1

df$y8_b<-0 # 气候变化对生产生活影响
df$y8_b[which(df$y8_c=='huge' | df$y8_c=='great')]<-1

df$y10_b<-0 # 生态补偿等措施对缓解气候变化影响
df$y10_b[which(df$y10_c=='huge' | df$y10_c=='great')]<-1

df$y11_b<-0 # 未来气候变化趋势的观点
df$y11_b[which(df$y11_c=='become better')]<-1

# transform trend data unit
trend_var_list<-c('Pt_5a','Pt_10a','Pt_20a','Pt_30a',
                 'Tt_5a','Tt_10a','Tt_20a','Tt_30a',
                 'TXDt_5a','TXDt_10a','TXDt_20a','TXDt_30a',
                 'PTDt_5a','PTDt_10a','PTDt_20a','PTDt_30a')
for(var in trend_var_list){
  colname<-paste('k_',var,sep='')
  df[,colname]<-df[,colname]*10 # °C/decade
  colname<-paste('c_',var,sep='')
  df[,colname]<-df[,colname]*10 # °C/decade
  colname<-paste('p_',var,sep='')
  df[,colname]<-df[,colname]*10 # °C/decade
}

# remove null data
df1<-df[complete.cases(df[ , c('x_gender','x_age','x_ethnic','x_edu','x_pincome')]),]
df2<-df[complete.cases(df[ , c('x_gender','x_age','x_ethnic','x_edu','x_pincome',
                               'x_wateracc','x_mediabelief','x_credit','x_farminc')]),]

# Bayesian regression
library(rstanarm)
options(mc.cores = parallel::detectCores())

clim_var_list<-c('P_5a','P_10a','P_20a','P_30a',
                 'Pt_5a','Pt_10a','Pt_20a','Pt_30a',
                 'T_5a','T_10a','T_20a','T_30a',
                 'Tt_5a','Tt_10a','Tt_20a','Tt_30a',
                 'TXDt_5a','TXDt_10a','TXDt_20a','TXDt_30a',
                 'PTDt_5a','PTDt_10a','PTDt_20a','PTDt_30a')
responses<-c('temperature','precipitation','adaptation','impact','mitigation','future')

##### individual level models #####
ind<-"1+scale(elev)+x_gender+x_edu+scale(x_age)+scale(x_pincome)+x_wateracc+x_mediabelief+x_credit+scale(x_dist2county)+scale(x_farminc)"
#temperature perception
reg_raw<-paste("y1_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,sep='')
  fit<-stan_glm(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/temperature/BI_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}


#precipitation perception
reg_raw<-paste("y2_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,sep='')
  fit<-stan_glm(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/precipitation/BI_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}


#adaptive capability
reg_raw<-paste("y7_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,sep='')
  fit<-stan_glm(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/adaptation/BI_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

#impact perception
reg_raw<-paste("y8_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,sep='')
  fit<-stan_glm(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/impact/BI_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

#mitigation effect
reg_raw<-paste("y10_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,sep='')
  fit<-stan_glm(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/mitigation/BI_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

#future trend
reg_raw<-paste("y11_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,sep='')
  fit<-stan_glm(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/future/BI_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

#### multi-level models ####
#by livelihood zones
reg_raw<-paste("y1_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,'+(1|z_vtype)',sep='')
  fit<-stan_glmer(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/temperature/BL_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

reg_raw<-paste("y2_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,'+(1|z_vtype)',sep='')
  fit<-stan_glmer(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/precipitation/BL_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

reg_raw<-paste("y7_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,'+(1|z_vtype)',sep='')
  fit<-stan_glmer(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/adaptation/BL_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

reg_raw<-paste("y8_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,'+(1|z_vtype)',sep='')
  fit<-stan_glmer(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/impact/BL_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

reg_raw<-paste("y10_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,'+(1|z_vtype)',sep='')
  fit<-stan_glmer(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/mitigation/BL_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

reg_raw<-paste("y11_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,'+(1|z_vtype)',sep='')
  fit<-stan_glmer(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/future/BL_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

#by prefectures
ind<-"1+scale(elev)+x_gender+x_edu+scale(x_age)+scale(x_pincome)+x_wateracc+x_mediabelief+x_credit+scale(x_dist2county)+scale(x_farminc)+p_flood+p_drought+p_blizzard+p_hail"
reg_raw<-paste("y1_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,'+(1|z_prefecture)',sep='')
  fit<-stan_glmer(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/temperature/BP_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

reg_raw<-paste("y2_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,'+(1|z_prefecture)',sep='')
  fit<-stan_glmer(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/precipitation/BP_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

reg_raw<-paste("y7_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,'+(1|z_prefecture)',sep='')
  fit<-stan_glmer(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/adaptation/BP_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

reg_raw<-paste("y8_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,'+(1|z_prefecture)',sep='')
  fit<-stan_glmer(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/impact/BP_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

reg_raw<-paste("y10_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,'+(1|z_prefecture)',sep='')
  fit<-stan_glmer(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/mitigation/BP_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

reg_raw<-paste("y11_b~",ind,"+",sep='')
for(var in clim_var_list) {
  clim_var<-paste('k_',var,sep='')
  reg<-paste(reg_raw,clim_var,'+(1|z_prefecture)',sep='')
  fit<-stan_glmer(reg,data=df2, family = binomial("logit"),seed = 618)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/future/BP_",var,".rds", sep='')
  saveRDS(fit,file = outfile)
}

#### compute the mean coefficient of each predictor ####
# individual models
for(res in responses){
  df_list <- list()
  for (i in seq(length(clim_var_list))) {
    infile<-paste(main_dir, "/code/figure/fig4/Bayesian/",res,"/BI_",clim_var_list[i],'.rds', sep='')
    fit<-readRDS(infile)
    fac<-names(fit$coefficients)[-1] # remove intercept
    coef<-fit$stan_summary[fac,c("2.5%","50%","97.5%")] # 95% credit intervals
    colnames(coef)<-c('lower','median','upper')
    df_list[[clim_var_list[i]]]<-coef
  }
  df_out<-do.call(what = rbind, args = df_list)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/",res,"/BI_effect.csv", sep='')
  write.csv(df_out,outfile)
}

# multi-level models
for(res in responses){
  df_list <- list()
  for (i in seq(length(clim_var_list))) {
    infile<-paste(main_dir, "/code/figure/fig4/Bayesian/",res,"/BL_",clim_var_list[i],'.rds', sep='')
    fit<-readRDS(infile)
    fac<-names(fit$coefficients)[-1] # remove intercept
    coef<-fit$stan_summary[fac,c("2.5%","50%","97.5%")] # 95% credit intervals
    colnames(coef)<-c('lower','median','upper')
    df_list[[clim_var_list[i]]]<-coef
  }
  df_out<-do.call(what = rbind, args = df_list)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/",res,"/BL_effect.csv", sep='')
  write.csv(df_out,outfile)
}

for(res in responses){
  df_list <- list()
  for (i in seq(length(clim_var_list))) {
    infile<-paste(main_dir, "/code/figure/fig4/Bayesian/",res,"/BP_",clim_var_list[i],'.rds', sep='')
    fit<-readRDS(infile)
    fac<-names(fit$coefficients)[-1] # remove intercept
    coef<-fit$stan_summary[fac,c("2.5%","50%","97.5%")] # 95% credit intervals
    colnames(coef)<-c('lower','median','upper')
    df_list[[clim_var_list[i]]]<-coef
  }
  df_out<-do.call(what = rbind, args = df_list)
  outfile <- paste(main_dir, "/code/figure/fig4/Bayesian/",res,"/BP_effect.csv", sep='')
  write.csv(df_out,outfile)
}
