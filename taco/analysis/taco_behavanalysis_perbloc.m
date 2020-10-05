clear;clc;

suj_list    = {'p001' 'p002' 'p003'};

for nsuj = 1:length(suj_list)
    
    % load log file
    subjectname                 = suj_list{nsuj};
    filename                    = ['../Logfiles/' subjectname '/' subjectname '_taco_block_Logfile.mat'];
    load(filename);
    
    list_block                  = {'fixed-fixed' 'fixed-jittered' 'jitterd'};
    
    for nbloc = 1:length(list_block)
        
       flg                      = find(strcmp([Info.TrialInfo.bloctype],list_block{nbloc}));
       blocinfo                 = Info.TrialInfo(flg,:); 
       
       nb_correct_trials        = sum(cell2mat([blocinfo.repCorrect]));
       perc_correct(nsuj,nbloc) = nb_correct_trials ./ height(blocinfo);
       
       find_correct_trials      = find(cell2mat([blocinfo.repCorrect]) == 1);
       med_rt(nsuj,nbloc)     	= median(cell2mat(Info.TrialInfo(find_correct_trials,:).repRT)); 
       
    end
    
    list_block                  = {'fixed-fixed' 'fixed-jittered' 'jittered'};
    
    keep suj_list nsuj perc_correct med_rt list_block
    
end

subplot(2,2,1)
hold on;
plot(perc_correct','--s','LineWidth',2','MarkerSize',10);
plot([1.1 2.1 3.1],mean(perc_correct,1),'-ks','LineWidth',2','MarkerSize',10);
xlim([0 4]);xticks([1 2 3]);xticklabels(list_block);legend([suj_list 'avg'])
ylim([0.5 1]);grid;
set(gca,'FontSize',20,'FontName', 'Calibri','FontWeight','Light');
title('Accuracy')

subplot(2,2,2)
hold on;
plot(med_rt','--s','LineWidth',2','MarkerSize',10);
plot([1.1 2.1 3.1],mean(med_rt,1),'-ks','LineWidth',2','MarkerSize',10);
xlim([0 4]);xticks([1 2 3]);xticklabels(list_block);legend([suj_list 'avg'])
ylim([0.3 0.8]);grid;
set(gca,'FontSize',20,'FontName', 'Calibri','FontWeight','Light');
title('Median RT');