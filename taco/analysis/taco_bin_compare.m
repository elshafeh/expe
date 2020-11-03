clear;clc;

suj_list                                = {'p006' 'p007' 'p008' 'p009' 'p011' 'p012'}; % 'p010' 
i                                       = 0;

for nsuj = 1:length(suj_list)
    
    %load log file
    subjectname                         = suj_list{nsuj};
    filename                            = ['../Logfiles/' subjectname '/' subjectname '_taco_block_Logfile.mat'];
    fprintf('loading %s\n',filename);
    load(filename);
    
    Info                                = taco_cleaninfo(Info);%% remove empty trials
    Info                                = taco_fixlog(subjectname,Info);%% fix subjects
    
    list_block                          = {'fixed-fixed' 'fixed-jittered' 'jitterd'};
    
    for nc = 1:length(list_block)
        
        flg                             = find(strcmp([Info.TrialInfo.bloctype],list_block{nc}));
        all_rt                          = cell2mat(Info.TrialInfo(flg,:).repRT);
        all_rt                          = [all_rt cell2mat(Info.TrialInfo(flg,:).repCorrect)];
        
        all_rt                         	= sortrows(all_rt,1);
        
        [indx]                        	= calc_tukey(all_rt(:,1));
        all_rt                        	= all_rt(indx,:);
        
        nb_bin                          = 5;
        bin_size                     	= floor(length(all_rt)/nb_bin);
        
        for nb = 1:nb_bin
            lm1                       	= 1+bin_size*(nb-1);
            lm2                     	= bin_size*nb;
            mean_rt(nsuj,nc,nb)       	= mean(all_rt(lm1:lm2,1)); 
            mean_pc(nsuj,nc,nb)       	= sum(all_rt(lm1:lm2,2)) ./ length(all_rt(lm1:lm2,2)); clear lm1 lm2
        end
        
        clear bin_size all_rt flg 
        
    end
end

keep mean_rt mean_pc
clc;

%%

list_block          = {'fix-fix' 'jit-fix' 'jit'};

figure;
subplot(2,2,1)
hold on;

list_color          = {'blue' 'magenta' 'red'};
list_addon          = [0 0.1 0.2];

for nc = 1:size(mean_rt,2)
    
    tmp         	= squeeze(mean_rt(:,nc,:));
    mean_data    	= mean(tmp,1);
    bounds       	= std(tmp, [], 1);
    bounds_sem     	= bounds ./ sqrt(size(tmp,1));
    
    x             	= [1:size(tmp,2)] + list_addon(nc);
    y             	= mean_data;
    errorbar(x,y,bounds_sem,['-' list_color{nc}(1) 's'],'LineWidth',2,'MarkerSize',10,'MarkerEdgeColor',list_color{nc},'MarkerFaceColor',list_color{nc});
    
end

xlim([0 size(mean_rt,3)+1])
xticks([1 3 5]);
xticklabels({'Fastest' 'Median' 'Slowest'});
ylim([0.2 0.9]);
yticks([0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9]);
grid on;

ylabel('RT')
xlabel('RT Bins')
legend(list_block);

set(gca,'FontSize',16,'FontName', 'Calibri','FontWeight','Light');

%%

subplot(2,2,2)
hold on;

list_color          = {'blue' 'magenta' 'red'};
list_addon          = [0 0.1 0.2];

for nc = 1:size(mean_pc,2)
    
    tmp         	= squeeze(mean_pc(:,nc,:));
    mean_data    	= mean(tmp,1);
    bounds       	= std(tmp, [], 1);
    bounds_sem     	= bounds ./ sqrt(size(tmp,1));
    
    x             	= [1:size(tmp,2)] + list_addon(nc);
    y             	= mean_data;
    errorbar(x,y,bounds_sem,['-' list_color{nc}(1) 's'],'LineWidth',2,'MarkerSize',10,'MarkerEdgeColor',list_color{nc},'MarkerFaceColor',list_color{nc});
    
end

xlim([0 size(mean_pc,3)+1])
xticks([1 3 5]);
xticklabels({'Fastest' 'Median' 'Slowest'});
ylim([0.6 1]);
yticks([0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]);
grid on;

ylabel('% correct')
xlabel('RT Bins')
legend(list_block);

set(gca,'FontSize',16,'FontName', 'Calibri','FontWeight','Light');