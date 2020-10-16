# Initiate Libraries ####

library(dae); library(nlme);library(effects);library(psych);library(interplot);
library(plyr);library(devtools);library(ez)
library(Rmisc);library(wesanderson);library(lme4);library(lsmeans)
library(plotly);library(ggplot2);library(ggpubr);library(dplyr);library(scales)
library(ggthemes);library(readr);library(tidyr);library(Hmisc);library(broom)
library(plyr);library(RColorBrewer);library(reshape2);library(tidyverse)

rm(list=ls())

##Plot Accuracy

# The palette with grey:
cbPalette <- c( "#56B4E9", "#009E73")

pd                  <- position_dodge(0.2)
data_table          <- read.table("/Users/heshamelshafei/Documents/GitHub/me/expe/taco/analysis/taco_behavpilot.txt",sep = ',',header=T)

data_table$bloc <- factor(data_table$bloc , levels = c("fixed-fixed","jittered-fixed","jittered"))

## cue and attend

tgc_perc <- summarySE(data_table, measurevar="perc_correct", groupvars=c("cue","bloc"), na.rm = TRUE)
tgc_rt  <- summarySE(data_table, measurevar="med_rt", groupvars=c("cue","bloc"), na.rm = TRUE)

p1 <- ggplot(tgc_perc, aes(x=bloc, y=perc_correct,color=cue,group=cue)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=perc_correct-se, ymax=perc_correct+se), width=.1, position=pd) +
  ylim(0.65,1)+
  theme()+
  scale_fill_manual(values=cbPalette)+ 
  scale_colour_manual(values=cbPalette)

p2 <- ggplot(tgc_rt, aes(x=bloc, y=med_rt,color=cue,group=cue)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=med_rt-se, ymax=med_rt+se), width=.1, position=pd) +
  ylim(0.4,0.7)+
  theme()+
  scale_fill_manual(values=cbPalette)+ 
  scale_colour_manual(values=cbPalette)

tgc_perc <- summarySE(data_table, measurevar="perc_correct", groupvars=c("attend","bloc"), na.rm = TRUE)
tgc_rt  <- summarySE(data_table, measurevar="med_rt", groupvars=c("attend","bloc"), na.rm = TRUE)

p3 <- ggplot(tgc_perc, aes(x=bloc, y=perc_correct,color=attend,group=attend)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=perc_correct-se, ymax=perc_correct+se), width=.1, position=pd) +
  ylim(0.65,1)+
  theme()

p4 <- ggplot(tgc_rt, aes(x=bloc, y=med_rt,color=attend,group=attend)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=med_rt-se, ymax=med_rt+se), width=.1, position=pd) +
  ylim(0.4,0.7)+
  theme()

ggarrange(p1,p2,p3,p4,ncol = 2, nrow = 2)


## all factors

tgc_perc <- summarySE(data_table, measurevar="perc_correct", groupvars=c("cue","bloc","attend"), na.rm = TRUE)
tgc_rt  <- summarySE(data_table, measurevar="med_rt", groupvars=c("cue","bloc","attend"), na.rm = TRUE)

p1 <- ggplot(tgc_perc, aes(x=bloc, y=perc_correct,color=cue,group=cue)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=perc_correct-se, ymax=perc_correct+se), width=.1, position=pd) +
  ylim(0.65,1)+
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  scale_fill_manual(values=cbPalette)+ 
  scale_colour_manual(values=cbPalette)+
  facet_wrap(~attend)

p2 <- ggplot(tgc_rt, aes(x=bloc, y=med_rt,color=cue,group=cue)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=med_rt-se, ymax=med_rt+se), width=.1, position=pd) +
  ylim(0.4,0.7)+
  theme()+
  scale_fill_manual(values=cbPalette)+ 
  scale_colour_manual(values=cbPalette)+
  facet_wrap(~attend)

ggarrange(p1,p2,ncol = 1, nrow = 2)
