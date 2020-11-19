function [med_rt,mean_rt,perc_corr,ntrial,strial_rt,perc_miss,perc_fa,per_incorr] = h_behav_eval(suj,list_cue,list_dis,list_tar)


load(['~/Dropbox/project_me/data/pat/res/' suj '_final_ds_list.mat']);

behav_summary                   = [];

for nbloc = 1:size(final_ds_list,1)

    pos_single                  = load(['~/Dropbox/project_me/data/pat/pos/' final_ds_list{nbloc,1} '.code.pos']);
    pos_single                  = PrepAtt22_funk_pos_prepare(pos_single,1,nbloc,1);
    pos_single                  = PrepAtt22_funk_pos_recode(pos_single);
    [~,behav_single,~]          = PrepAtt22_funk_pos_summary(pos_single);

    behav_summary               = [behav_summary;behav_single];

    clear behav_single pos_single

end

clearvars -except behav_summary suj list_*

behav_table                   = array2table(behav_summary,'VariableNames',{'sub_idx' ;'nbloc'; 'ntrl_blc'; 'code'; 'CUE' ;'DIS';'TAR'; 'XP' ;'REP';'CORR' ;'RT' ;'ERROR' ;'cue_idx'; 'CT' ;'DT' ;'cueON';'disON';'tarON';'CLASS';'idx_group'; 'CD'});

subset_behav                  = [];

for ncue = 1:length(list_cue)
    for ndis = 1:length(list_dis)
        for ntar = 1:length(list_tar)
            subset_behav = [subset_behav;behav_table(behav_table.CUE==list_cue(ncue) & behav_table.DIS==list_dis(ndis) & behav_table.TAR==list_tar(ntar),:)];
        end
    end
end

trls_miss           = subset_behav(subset_behav.ERROR ==1,:);
perc_miss           = length(trls_miss.RT)/length(subset_behav.RT) * 100;
trls_fa             = subset_behav(subset_behav.ERROR ==3,:);
perc_fa             = length(trls_fa.RT)/length(subset_behav.RT) * 100;
trl_incorrr         = subset_behav(subset_behav.CORR==-1,:);

per_incorr          = length(trl_incorrr.RT)/length(subset_behav.RT) * 100;

final_behav         = subset_behav(subset_behav.ERROR ==0 & subset_behav.CORR==1,:);
strial_rt           = final_behav.RT;
med_rt              = median(final_behav.RT);
mean_rt             = mean(final_behav.RT);
perc_corr           = length(final_behav.RT)/length(subset_behav.RT) * 100;

ntrial              = length(final_behav.RT);
