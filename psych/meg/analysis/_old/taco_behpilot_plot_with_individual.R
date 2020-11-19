# Initiate Libraries ####

library(dae); library(nlme);library(effects);library(psych);library(interplot);
library(plyr);library(devtools);library(ez)
library(Rmisc);library(wesanderson);library(lme4);library(lsmeans)
library(plotly);library(ggplot2);library(ggpubr);library(dplyr);library(scales)
library(ggthemes);library(readr);library(tidyr);library(Hmisc);library(broom)
library(plyr);library(RColorBrewer);library(reshape2);library(tidyverse)

rm(list=ls())

pd                  <- position_dodge(0.2)
data_table          <- read.table("/Users/heshamelshafei/Documents/GitHub/me/expe/taco/analysis/taco_behavpilot.txt",sep = ',',header=T)
data_table$bloc     <- factor(data_table$bloc , levels = c("fixed-fixed","jittered-fixed","jittered"))

lim_perc = c(0.4,1)
lim_rt    = c(0.5,1.5)

###  Plot across blocks
id <- data_table %>% 
  group_by(suj,bloc) %>% 
  summarise(perc_correct = mean(perc_correct),
            med_rt  = mean(med_rt))

gd <- id %>% 
  group_by(bloc) %>% 
  summarise(perc_correct = mean(perc_correct),
            med_rt  = mean(med_rt))

p1 <- ggplot(id, aes(x = bloc, y = perc_correct, color = bloc, shape = bloc)) +
  geom_line(data = gd,group=1,color='black',alpha=0.6)+
  geom_jitter(alpha = .4, width = .05) +
  geom_point(data = gd, size = 4) +
  theme_bw() +
  guides(color = guide_legend("bloc"),  shape = guide_legend("bloc")) +
  ylim(lim_perc)+
  labs(title = "Ratio of Correct Responses",y = "",x = "")

p2 <- ggplot(id, aes(x = bloc, y = med_rt, color = bloc, shape = bloc)) +
  geom_line(data = gd,group=1,color='black',alpha=0.6)+
  geom_jitter(alpha = .4, width = .05) +
  geom_point(data = gd, size = 4) +
  theme_bw() +
  guides(color = guide_legend("bloc"),  shape = guide_legend("bloc")) +
  ylim(lim_rt)+
  labs(title = "Median RT",y = "",x = "")

### Plot across blocks and cues
id <- data_table %>% 
  group_by(suj,bloc,cue) %>% 
  summarise(perc_correct = mean(perc_correct),
            med_rt  = mean(med_rt))

gd <- id %>% 
  group_by(cue,bloc) %>% 
  summarise(perc_correct = mean(perc_correct),
            med_rt  = mean(med_rt))

p3 <- ggplot(id, aes(x = cue, y = perc_correct, group=bloc,color = bloc, shape = bloc)) +
  geom_line(data = gd,color='black',alpha=0.6)+
  geom_jitter(alpha = .4, width = .05) +
  geom_point(data = gd, size = 4) +
  theme_bw() +
  guides(color = guide_legend("bloc"),  shape = guide_legend("bloc")) +
  ylim(lim_perc)+
  labs(title = "Ratio of Correct Responses",y = "",x = "")

p4 <- ggplot(id, aes(x = cue, y = perc_correct, group=bloc,color = bloc, shape = bloc)) +
  geom_line(data = gd,group=1,color='black',alpha=0.6)+
  geom_jitter(alpha = .4, width = .05) +
  geom_point(data = gd, size = 4) +
  theme_bw() +
  guides(color = guide_legend("bloc"),  shape = guide_legend("bloc")) +
  ylim(lim_rt)+
  labs(title = "Median RT",y = "",x = "")

### Plot across blocks and position
id <- data_table %>% 
  group_by(suj,bloc,attend) %>% 
  summarise(perc_correct = mean(perc_correct),
            med_rt  = mean(med_rt))

gd <- id %>% 
  group_by(attend,bloc) %>% 
  summarise(perc_correct = mean(perc_correct),
            med_rt  = mean(med_rt))

p5 <- ggplot(id, aes(x = attend, y = perc_correct, group=bloc,color = bloc, shape = bloc)) +
  geom_line(data = gd,color='black',alpha=0.6)+
  geom_jitter(alpha = .4, width = .05) +
  geom_point(data = gd, size = 4) +
  theme_bw() +
  guides(color = guide_legend("bloc"),  shape = guide_legend("bloc")) +
  ylim(lim_perc)+
  labs(title = "Ratio of Correct Responses",y = "",x = "")

p6 <- ggplot(id, aes(x = attend, y = perc_correct, group=bloc,color = bloc, shape = bloc)) +
  geom_line(data = gd,group=1,color='black',alpha=0.6)+
  geom_jitter(alpha = .4, width = .05) +
  geom_point(data = gd, size = 4) +
  theme_bw() +
  guides(color = guide_legend("bloc"),  shape = guide_legend("bloc")) +
  ylim(lim_rt)+
  labs(title = "Median RT",y = "",x = "")


ggarrange(p1,p2,p3,p4,p5,p6,ncol = 2, nrow = 3)


#####

tgc_perc <- summarySE(data_table, measurevar="perc_correct", groupvars=c("bloc"), na.rm = TRUE)
tgc_rt  <- summarySE(data_table, measurevar="med_rt", groupvars=c("bloc"), na.rm = TRUE)

p1 <- ggplot(tgc_perc, aes(x=bloc, y=perc_correct)) + 
  geom_point(position=pd, size=2,group=1)+
  geom_line(position=pd,group=1) +
  geom_errorbar(aes(ymin=perc_correct-se, ymax=perc_correct+se), width=.1, position=pd) +
  ylim(lim_perc)+
  theme()+
  scale_fill_manual(values=cbPalette)+ 
  scale_colour_manual(values=cbPalette)

p2 <- ggplot(tgc_rt, aes(x=bloc, y=med_rt)) + 
  geom_point(position=pd, size=2,group=1)+
  geom_line(position=pd,group=1) +
  geom_errorbar(aes(ymin=med_rt-se, ymax=med_rt+se), width=.1, position=pd) +
  ylim(lim_rt)+
  theme()+
  scale_fill_manual(values=cbPalette)+ 
  scale_colour_manual(values=cbPalette)





tgc_perc <- summarySE(data_table, measurevar="perc_correct", groupvars=c("attend","bloc"), na.rm = TRUE)
tgc_rt  <- summarySE(data_table, measurevar="med_rt", groupvars=c("attend","bloc"), na.rm = TRUE)

p3 <- ggplot(tgc_perc, aes(x=bloc, y=perc_correct,color=attend,group=attend)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=perc_correct-se, ymax=perc_correct+se), width=.1, position=pd) +
  ylim(lim_perc)+
  theme()

p4 <- ggplot(tgc_rt, aes(x=bloc, y=med_rt,color=attend,group=attend)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=med_rt-se, ymax=med_rt+se), width=.1, position=pd) +
  ylim(lim_rt)+
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
