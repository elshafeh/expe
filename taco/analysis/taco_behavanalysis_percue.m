clear;clc;

suj_list    = {'p001' 'p002' 'p003'};

for nsuj = 1:length(suj_list)
    
    % load log file
    subjectname                     = suj_list{nsuj};
    filename                        = ['../Logfiles/' subjectname '/' subjectname '_taco_block_Logfile.mat'];
    load(filename);
    
    for ncond = 1:2
       flg                          = find([Info.TrialInfo.cue] == ncond);
       blocinfo                     = Info.TrialInfo(flg,:); 
       
       nb_correct_trials            = sum(cell2mat([blocinfo.repCorrect]));
       pr_co_percue(nsuj,ncond)     = nb_correct_trials ./ height(blocinfo);
       
       find_correct_trials          = find(cell2mat([blocinfo.repCorrect]) == 1);
       med_rt_percue(nsuj,ncond)	= median(cell2mat(Info.TrialInfo(find_correct_trials,:).repRT)); 
       
       clear blocinfo flg find_correct_trials nb_correct_trials
    end
    
    
    for ncond = 1:2
        
       flg                          = find([Info.TrialInfo.attend] == ncond);
       blocinfo                     = Info.TrialInfo(flg,:); 
       
       nb_correct_trials            = sum(cell2mat([blocinfo.repCorrect]));
       pr_co_peratt(nsuj,ncond)     = nb_correct_trials ./ height(blocinfo);
       
       find_correct_trials          = find(cell2mat([blocinfo.repCorrect]) == 1);
       med_rt_peratt(nsuj,ncond)	= median(cell2mat(Info.TrialInfo(find_correct_trials,:).repRT)); 
       
       clear blocinfo flg find_correct_trials nb_correct_trials
    end
    
    clear filename suj ncond
    
end

keep *per* suj_list

list_cue         	= {'pre' 'retro'};
list_attend        	= {'first' 'second'};

subplot(2,2,1)
hold on;
plot(pr_co_percue','--s','LineWidth',2','MarkerSize',10);
xlim([0 3]);xticks([1 2]);xticklabels(list_cue);legend([suj_list])
ylim([0.5 1]);grid;
set(gca,'FontSize',20,'FontName', 'Calibri','FontWeight','Light');
title('Accuracy')

subplot(2,2,3)
hold on;
plot(pr_co_peratt','--s','LineWidth',2','MarkerSize',10);
xlim([0 3]);xticks([1 2]);xticklabels(list_attend);legend([suj_list])
ylim([0.5 1]);grid;
set(gca,'FontSize',20,'FontName', 'Calibri','FontWeight','Light');
title('Accuracy')

subplot(2,2,2)
hold on;
plot(med_rt_percue','--s','LineWidth',2','MarkerSize',10);
xlim([0 3]);xticks([1 2]);xticklabels(list_cue);legend([suj_list])
ylim([0.3 0.8]);grid;
set(gca,'FontSize',20,'FontName', 'Calibri','FontWeight','Light');
title('Med RT')

subplot(2,2,4)
hold on;
plot(med_rt_percue','--s','LineWidth',2','MarkerSize',10);
xlim([0 3]);xticks([1 2]);xticklabels(list_attend);legend([suj_list])
ylim([0.3 0.8]);grid;
set(gca,'FontSize',20,'FontName', 'Calibri','FontWeight','Light');
title('Med RT')