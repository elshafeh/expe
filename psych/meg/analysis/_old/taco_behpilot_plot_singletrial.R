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

data_table          <- read.table("/Users/heshamelshafei/Documents/GitHub/me/expe/taco/analysis/taco_behavpilot_singletrial.txt",sep = ',',header=T)
data_table$bloc     <- factor(data_table$bloc , levels = c("fix-fix","jit-fix","jit"))
data_table_correct  <- data_table[data_table$correct==1,]

lim_perc = c(0.7,1)
lim_rt    = c(0.4,0.65)

## check subjects
###  Plot accruacy across subjects ----------------------------------------------------------------------------
sum_table   <- data_table %>%
  group_by(suj) %>%
  mutate(tot= length(correct), len= sum(correct),percent = len/tot)%>%
  summarise(max(percent))

col_names = colnames(sum_table)
col_names[length((col_names))] = "perc_correct"
names(sum_table) <- col_names

ggplot(sum_table, aes(x=suj, y=perc_correct, label=suj)) +
  geom_point(show.legend = FALSE,size=3)+
  geom_hline(yintercept=0.5, linetype="dashed",color = "red", size=0.1)+
  ylim(c(0,1))

###  Plot RT across subjects ----------------------------------------------------------------------------
sum_table   <- data_table_correct %>%
  group_by(suj) %>%
  mutate(tot= median(rt))%>%
  summarise(max(tot))

col_names = colnames(sum_table)
col_names[length((col_names))] = "rt"
names(sum_table) <- col_names

ggplot(sum_table, aes(x=suj, y=rt, label=suj)) +
  geom_point(show.legend = FALSE,size=3)+
  geom_hline(yintercept=mean(sum_table$rt), linetype="dashed",color = "black", size=0.1)+
  ylim(0,2)

###  Plot accruacy across blocks ----------------------------------------------------------------------------
sum_table   <- data_table %>%
  group_by(suj,bloc) %>%
  mutate(tot= length(correct), len= sum(correct),percent = len/tot)%>%
  summarise(max(percent))

col_names = colnames(sum_table)
col_names[length((col_names))] = "perc_correct"
names(sum_table) <- col_names

tgc_perc <- summarySE(sum_table, measurevar="perc_correct", groupvars=c("bloc"), na.rm = TRUE)

ggplot(tgc_perc, aes(x=bloc, y=perc_correct)) + 
  geom_point(data=sum_table,alpha=0.4)+
  geom_point(position=pd, size=2,group=1)+
  geom_line(position=pd,group=1) +
  geom_errorbar(aes(ymin=perc_correct-se, ymax=perc_correct+se), width=.1, position=pd) +
  ylim(lim_perc)+
  theme()

###  Plot RT across blocks ----------------------------------------------------------------------------
sum_table   <- data_table_correct %>%
  group_by(suj,bloc) %>%
  mutate(tot= median(rt))%>%
  summarise(max(tot))

col_names = colnames(sum_table)
col_names[length((col_names))] = "rt"
names(sum_table) <- col_names

tgc_rt  <- summarySE(sum_table, measurevar="rt", groupvars=c("bloc"), na.rm = TRUE)

ggplot(tgc_rt, aes(x=bloc, y=rt)) + 
  geom_point(data=sum_table,alpha=0.2)+
  geom_line(data=sum_table,aes(group=suj),alpha=0.2)+
  geom_point(position=pd, size=2,group=1)+
  geom_line(position=pd,group=1) +
  geom_errorbar(aes(ymin=rt-se, ymax=rt+se), width=.1, position=pd) +
  ylim(lim_rt)+
  theme()

###  Plot accruacy across blocks and cues ----------------------------------------------------------------------------
sum_table   <- data_table %>%
  group_by(suj,bloc,cue) %>%
  mutate(tot= length(correct), len= sum(correct),percent = len/tot)%>%
  summarise(max(percent))

col_names = colnames(sum_table)
col_names[length((col_names))] = "perc_correct"
names(sum_table) <- col_names

tgc_perc <- summarySE(sum_table, measurevar="perc_correct", groupvars=c("cue","bloc"), na.rm = TRUE)

ggplot(tgc_perc, aes(x=bloc, y=perc_correct,color=cue,group=cue)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=perc_correct-se, ymax=perc_correct+se), width=.1, position=pd) +
  ylim(lim_perc)+
  theme()+
  scale_colour_manual(values = cbPalette_1)+
  scale_fill_manual(values = cbPalette_1)

###  Plot RT across blocks and cues ----------------------------------------------------------------------------
sum_table   <- data_table_correct %>%
  group_by(suj,bloc,cue) %>%
  mutate(tot= median(rt))%>%
  summarise(max(tot))

col_names = colnames(sum_table)
col_names[length((col_names))] = "rt"
names(sum_table) <- col_names

tgc_rt  <- summarySE(sum_table, measurevar="rt", groupvars=c("bloc","cue"), na.rm = TRUE)

ggplot(tgc_rt, aes(x=bloc, y=rt,color=cue,group=cue)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=rt-se, ymax=rt+se), width=.1, position=pd) +
  ylim(lim_rt)+
  theme()+
  scale_colour_manual(values = cbPalette_1)+
  scale_fill_manual(values = cbPalette_1)


###  Plot accruacy across blocks and cues ----------------------------------------------------------------------------
sum_table   <- data_table %>%
  group_by(suj,bloc,attend) %>%
  mutate(tot= length(correct), len= sum(correct),percent = len/tot)%>%
  summarise(max(percent))

col_names = colnames(sum_table)
col_names[length((col_names))] = "perc_correct"
names(sum_table) <- col_names

tgc_perc <- summarySE(sum_table, measurevar="perc_correct", groupvars=c("attend","bloc"), na.rm = TRUE)

ggplot(tgc_perc, aes(x=bloc, y=perc_correct,color=attend,group=attend)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=perc_correct-se, ymax=perc_correct+se), width=.1, position=pd) +
  ylim(lim_perc)+
  theme()+
  scale_colour_manual(values = cbPalette_2)+
  scale_fill_manual(values = cbPalette_2)

###  Plot RT across blocks and attend ----------------------------------------------------------------------------
sum_table   <- data_table_correct %>%
  group_by(suj,bloc,attend) %>%
  mutate(tot= median(rt))%>%
  summarise(max(tot))

col_names = colnames(sum_table)
col_names[length((col_names))] = "rt"
names(sum_table) <- col_names

tgc_rt  <- summarySE(sum_table, measurevar="rt", groupvars=c("bloc","attend"), na.rm = TRUE)

ggplot(tgc_rt, aes(x=bloc, y=rt,color=attend,group=attend)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=rt-se, ymax=rt+se), width=.1, position=pd) +
  ylim(lim_rt)+
  theme()+
  scale_colour_manual(values = cbPalette_2)+
  scale_fill_manual(values = cbPalette_2)

###  Plot accruacy across all factors ----------------------------------------------------------------------------
sum_table   <- data_table %>%
  group_by(suj,bloc,attend,cue) %>%
  mutate(tot= length(correct), len= sum(correct),percent = len/tot)%>%
  summarise(max(percent))

col_names = colnames(sum_table)
col_names[length((col_names))] = "perc_correct"
names(sum_table) <- col_names

tgc_perc <- summarySE(sum_table, measurevar="perc_correct", groupvars=c("attend","bloc","cue"), na.rm = TRUE)

ggplot(tgc_perc, aes(x=bloc, y=perc_correct,color=cue,group=cue)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=perc_correct-se, ymax=perc_correct+se), width=.1, position=pd) +
  ylim(lim_perc)+
  theme()+
  scale_colour_manual(values = cbPalette_1)+
  scale_fill_manual(values = cbPalette_1)+facet_wrap(~attend)

###  Plot RT across all factors ----------------------------------------------------------------------------
sum_table   <- data_table_correct %>%
  group_by(suj,bloc,attend,cue) %>%
  mutate(tot= median(rt))%>%
  summarise(max(tot))

col_names = colnames(sum_table)
col_names[length((col_names))] = "rt"
names(sum_table) <- col_names

tgc_rt  <- summarySE(sum_table, measurevar="rt", groupvars=c("bloc","attend","cue"), na.rm = TRUE)

ggplot(tgc_rt, aes(x=bloc, y=rt,color=cue,group=cue)) + 
  geom_point(position=pd, size=2)+
  geom_line(position=pd) +
  geom_errorbar(aes(ymin=rt-se, ymax=rt+se), width=.1, position=pd) +
  ylim(lim_rt)+
  theme()+
  scale_colour_manual(values = cbPalette_1)+
  scale_fill_manual(values = cbPalette_1)+facet_wrap(~attend)