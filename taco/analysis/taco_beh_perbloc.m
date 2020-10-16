clear;clc;

suj_list                        = {'p001' 'p002' 'p003' 'p004' 'p005' 'p006'}; % 

for nsuj = 1:length(suj_list)
    
    %load log file
    subjectname                 = suj_list{nsuj};
    filename                    = ['../Logfiles/' subjectname '/' subjectname '_taco_block_Logfile.mat'];
    load(filename);
    
    Info                        = taco_cleaninfo(Info);%% remove empty trials
    Info                        = taco_fixlog(subjectname,Info);%% fix subjects
    
    list_block                  = {'fixed-fixed' 'fixed-jittered' 'jitterd'};
    
    for nbloc = 1:length(list_block)
        
        flg                      = find(strcmp([Info.TrialInfo.bloctype],list_block{nbloc}));
        blocinfo                 = Info.TrialInfo(flg,:);
        
        nb_correct_trials        = sum(cell2mat([blocinfo.repCorrect]));
        perc_correct(nsuj,nbloc) = nb_correct_trials ./ height(blocinfo);
        
        find_correct_trials      = find(cell2mat([blocinfo.repCorrect]) == 1);
        med_rt(nsuj,nbloc)       = median(cell2mat(blocinfo(find_correct_trials,:).repRT));
        
        clear flg blocinfo nb_correct_trials find_correct_trials
        
    end
    
    list_block                  = {'fixed-fixed' 'jittered-fixed' 'jittered'};
    
    keep suj_list nsuj perc_correct med_rt list_block
    
end

perc_correct(perc_correct == 0)     = NaN;

subplot(2,2,1)
mean_data                           = nanmean(perc_correct,1);
bounds                              = nanstd(perc_correct, [], 1);
bounds_sem                          = bounds ./ sqrt(size(perc_correct,1));
errorbar(1:3,mean_data,bounds_sem,'CapSize',18);

xlim([0 4]);xticks([1 2 3]);xticklabels(list_block);
ylim([0.5 1]);grid;
set(gca,'FontSize',20,'FontName', 'Calibri','FontWeight','Light');
title('Accuracy')

subplot(2,2,2)
mean_data                           = nanmean(med_rt,1);
bounds                              = nanstd(med_rt, [], 1);
bounds_sem                          = bounds ./ sqrt(size(med_rt,1));
errorbar(1:3,mean_data,bounds_sem,'CapSize',18);
xlim([0 4]);xticks([1 2 3]);xticklabels(list_block);
ylim([0.3 0.7]);grid;
set(gca,'FontSize',20,'FontName', 'Calibri','FontWeight','Light');
title('Median RT');

clear bounds*