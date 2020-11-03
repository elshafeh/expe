# Initiate Libraries ####

library(dae); library(nlme);library(effects);library(psych);library(interplot);
library(plyr);library(devtools);library(ez)
library(Rmisc);library(wesanderson);library(lme4);library(lsmeans)
library(plotly);library(ggplot2);library(ggpubr);library(dplyr);library(scales)
library(ggthemes);library(readr);library(tidyr);library(Hmisc);library(broom)
library(plyr);library(RColorBrewer);library(reshape2);library(tidyverse)

rm(list=ls())

cbPalette_1         <- c("#FC4E07","#00AFBB") 
cbPalette_2         <-c("#CC6666", "#66CC99") 

pd                  <- position_dodge(0.2)

data_table          <- read.table("/Users/heshamelshafei/Documents/GitHub/me/expe/taco/analysis/taco_behavpilot.txt",sep = ',',header=T)
data_table$bloc     <- factor(data_table$bloc , levels = c("fixed-fixed","jittered-fixed","jittered"))

lim_perc = c(0.7,1)
lim_rt    = c(0.45,0.6)

## check subjects
# compute and plot avg accuracy
sum_table   <- data_table %>%
  group_by(suj) %>%
  mutate(tot= length(perc_correct), len= sum(perc_correct),percent = len/tot)%>%
  summarise(max(perc_correct))

col_names = colnames(sum_table)
col_names[length((col_names))] = "percent"
names(sum_table) <- col_names

rej_limit = 0.55
ggplot(sum_table, aes(x=suj, y=percent, label=suj)) +
  geom_point(show.legend = FALSE,size=3)+
  geom_hline(yintercept=rej_limit, linetype="dashed",
             color = "black", size=1)+
  geom_text(aes(label=ifelse(percent<rej_limit,as.character(suj),'')),hjust=1,vjust=1.5,color = "red")+
  theme(axis.ticks= element_blank(),
        axis.text.x=element_blank())+
  ylim(c(0,1))+
  theme(axis.title.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank())

# compute and plot rt
sum_table   <- data_table %>%
  group_by(suj,cue,bloc,attend) %>%
  mutate(tot= median(tuk_rt))%>%
  summarise(max(tot))

col_names = colnames(sum_table)
col_names[length((col_names))] = "rt"
names(sum_table) <- col_names

ggplot(sum_table, aes(x=suj, y=rt, label=suj)) +
  geom_point(show.legend = FALSE,size=3)+
  ylim(0,2)

###  Plot across blocks
tgc_perc <- summarySE(data_table, measurevar="perc_correct", groupvars=c("bloc"), na.rm = TRUE)
tgc_rt  <- summarySE(data_table, measurevar="med_rt", groupvars=c("bloc"), na.rm = TRUE)

p1 <- ggplot(tgc_perc, aes(x=bloc, y=perc_correct)) + 
  geom_point(position=pd, size=2,group=1)+
  geom_line(position=pd,group=1) +
  geom_errorbar(aes(ymin=perc_correct-se, ymax=perc_correct+se), width=.1, position=pd) +
  ylim(lim_perc)+
  theme()

p2 <- ggplot(tgc_rt, aes(x=bloc, y=med_rt)) + 
  geom_point(position=pd, size=2,group=1)+
  geom_line(position=pd,group=1) +
  geom_errorbar(aes(ymin=med_rt-se, ymax=med_rt+se), width=.1, position=pd) +
  ylim(lim_rt)+
  theme()

tgc_perc <- summarySE(data_table, measurevar="perc_correct", groupvars=c("attend","bloc"), na.rm = TRUE)
tgc_rt  <- summarySE(data_table, measurevar="med_rt", groupvars=c("attend","bloc"), na.rm = TRUE)

p3 <- ggplot(tgc_perc, aes(x=bloc, y=perc_correct,color=attend,group=attend)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=perc_correct-se, ymax=perc_correct+se), width=.1, position=pd) +
  ylim(lim_perc)+
  theme()+
  scale_colour_manual(values = cbPalette_1)+
  scale_fill_manual(values = cbPalette_1)

p4 <- ggplot(tgc_rt, aes(x=bloc, y=med_rt,color=attend,group=attend)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=med_rt-se, ymax=med_rt+se), width=.1, position=pd) +
  ylim(lim_rt)+
  theme()+
  scale_colour_manual(values = cbPalette_1)+
  scale_fill_manual(values = cbPalette_1)


tgc_perc <- summarySE(data_table, measurevar="perc_correct", groupvars=c("cue","bloc"), na.rm = TRUE)
tgc_rt  <- summarySE(data_table, measurevar="med_rt", groupvars=c("cue","bloc"), na.rm = TRUE)

p5 <- ggplot(tgc_perc, aes(x=bloc, y=perc_correct,color=cue,group=cue)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=perc_correct-se, ymax=perc_correct+se), width=.1, position=pd) +
  ylim(lim_perc)+
  theme()+
  scale_colour_manual(values = cbPalette_2)+
  scale_fill_manual(values = cbPalette_2)

p6 <- ggplot(tgc_rt, aes(x=bloc, y=med_rt,color=cue,group=cue)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=med_rt-se, ymax=med_rt+se), width=.1, position=pd) +
  ylim(lim_rt)+
  theme()+  scale_colour_manual(values = cbPalette_2)+
  scale_fill_manual(values = cbPalette_2)

ggarrange(p1,p2,p3,p4,p5,p6,ncol = 2, nrow = 3)

rm(tgc_perc,tgc_rt)

## all factors
tgc_perc <- summarySE(data_table, measurevar="perc_correct", groupvars=c("cue","bloc","attend"), na.rm = TRUE)
tgc_rt  <- summarySE(data_table, measurevar="med_rt", groupvars=c("cue","bloc","attend"), na.rm = TRUE)
p1 <- ggplot(tgc_perc, aes(x=bloc, y=perc_correct,color=cue,group=cue)) +
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=perc_correct-se, ymax=perc_correct+se), width=.1, position=pd) +
  ylim(lim_perc)+
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  facet_wrap(~attend)+
  scale_colour_manual(values = cbPalette_2)+
  scale_fill_manual(values = cbPalette_2)


p2 <- ggplot(tgc_rt, aes(x=bloc, y=med_rt,color=cue,group=cue)) +
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=med_rt-se, ymax=med_rt+se), width=.1, position=pd) +
  ylim(lim_rt)+
  theme()+
  facet_wrap(~attend)+
  scale_colour_manual(values = cbPalette_2)+
  scale_fill_manual(values = cbPalette_2)

ggarrange(p1,p2,ncol = 1, nrow = 2)
