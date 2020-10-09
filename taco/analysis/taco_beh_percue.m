clear;clc;

suj_list                                = {'p004' 'p001' 'p002' 'p003' 'p005' 'p006'};

for nsuj = 1:length(suj_list)
    
    % load log file
    subjectname                         = suj_list{nsuj};
    filename                            = ['../Logfiles/' subjectname '/' subjectname '_taco_block_Logfile.mat'];
    load(filename);
    
    list_cue                            = {'pre' 'retro'};
    list_attend                         = {'first' 'second'};
    
    list_cond                           = {};
    ix                                  = 0;
    
    for ncue = 1:2
        for natt = 1:2
            
            ix                          = ix + 1;
            
            mtrx_find                   = [[Info.TrialInfo.cue] [Info.TrialInfo.attend]];
            flg                       	= find(mtrx_find(:,1) == ncue & mtrx_find(:,2) == natt);
            
            blocinfo                   	= Info.TrialInfo(flg,:);
            
            nb_correct_trials          	= sum(cell2mat([blocinfo.repCorrect]));
            perc_correct(nsuj,ix)   	= nb_correct_trials ./ height(blocinfo);
            
            find_correct_trials        	= find(cell2mat([blocinfo.repCorrect]) == 1);
            med_rt(nsuj,ix)             = median(cell2mat(blocinfo(find_correct_trials,:).repRT));
            
            list_cond{end+1}            = [list_cue{ncue} ' ' list_attend{natt}];
            
            clear blocinfo flg find_correct_trials nb_correct_trials mtrx_find
            
        end
    end
    
    clear filename suj ncond
    
end

keep med_rt perc_correct list_cond

perc_correct(perc_correct == 0)     = NaN;

subplot(2,2,3)
mean_data                           = nanmean(perc_correct,1);
bounds                              = nanstd(perc_correct, [], 1);
bounds_sem                          = bounds ./ sqrt(size(perc_correct,1));
errorbar(1:4,mean_data,bounds_sem,'CapSize',18);

xlim([0 5]);xticks([1 2 3 4]);xticklabels(list_cond);
ylim([0.5 1]);grid;
set(gca,'FontSize',20,'FontName', 'Calibri','FontWeight','Light');
% title('Accuracy')

subplot(2,2,4)
mean_data                           = nanmean(med_rt,1);
bounds                              = nanstd(med_rt, [], 1);
bounds_sem                          = bounds ./ sqrt(size(med_rt,1));
errorbar(1:4,mean_data,bounds_sem,'CapSize',18);
xlim([0 5]);xticks([1 2 3 4]);xticklabels(list_cond);
ylim([0.3 0.7]);grid;
set(gca,'FontSize',20,'FontName', 'Calibri','FontWeight','Light');
% title('Median RT');