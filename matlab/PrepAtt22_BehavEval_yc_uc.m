clear ; clc ; close all;

dataDir = '/dycog/Aurelie/DATA/MEG/PAT_EXPE22/';
addpath([dataDir 'scripts.m']);

suj_group{2}    = {'yc1' 'yc2' 'yc3' 'yc4' 'yc5' 'yc6' 'yc7' 'yc8' 'yc9' 'yc10'...
    'yc11' 'yc12' 'yc13' 'yc14' 'yc15' 'yc16' 'yc17' 'yc18' 'yc19' 'yc20' 'yc21'};
suj_group{1}    = {'uc1' 'uc2' 'uc3' 'uc4' 'uc5' 'uc6' 'uc7' 'uc8' 'uc9' 'uc10'};
lst_group       = {'Migraine','Controls'};

behav_summary   = [];

for ngrp = 1:length(suj_group)
    
    suj_list = suj_group{ngrp};
    
    for sb = 1:length(suj_list)
        
        suj                 = suj_list{sb};
        
        load([ dataDir 'data/' suj '/res/' suj '_final_ds_list.mat']);
        
        for nbloc = 1:size(final_ds_list,1)
            
            fprintf('Handling %s\n',[suj ' b' num2str(nbloc)])
            
            pos_single                = load([ dataDir 'data/' suj '/pos/' final_ds_list{nbloc,1} '.code.pos']);
            pos_single                = PrepAtt22_funk_pos_prepare(pos_single,sb,nbloc,ngrp);
            pos_single                = PrepAtt22_funk_pos_recode(pos_single);
            [~,behav_single,~]        = PrepAtt22_funk_pos_summary(pos_single);
            
            behav_summary             = [behav_summary;behav_single];
            
            clear behav_single pos_single
            
        end
        
    end
end

clearvars -except behav_summary lst_group dataDir; clc ; close all ;

behav_table                   = array2table(behav_summary(:,1:end-1),'VariableNames',{'sub_idx' ;'nbloc'; 'ntrl_blc'; 'code'; 'CUE' ;'DIS' ...
    ;'TAR'; 'XP' ;'REP';'CORR' ;'RT' ;'ERROR' ;'cue_idx'; 'CT' ;'DT' ;'cueON' ; ...
    'disON';'tarON';'CLASS';'idx_group'});

writetable(behav_table,[dataDir 'Comportement/yc_uc/PrepAtt22_behav_table4R_yc_uc.csv'],'Delimiter',';')

% for ngroup = unique(behav_table.idx_group)'
%     
%     group_table = behav_table(behav_table.idx_group==ngroup,:);
%     
%     for sb = unique(group_table.sub_idx)'
%         
%         for cue = 1:4
%             
%             for dis = 1:3
%                 
%                 
%                 
%                 %                 if cue ==1
%                 %                     suj_table         = group_table(mod(group_table.TAR,2) ~=0 & group_table.sub_idx ==sb & group_table.CUE ==0 & group_table.DIS==dis-1 & group_table.CORR==1,11);
%                 %                 elseif cue == 2
%                 %                     suj_table         = group_table(mod(group_table.TAR,2) ==0 & group_table.sub_idx ==sb & group_table.CUE ==0 & group_table.DIS==dis-1 & group_table.CORR==1,11);
%                 %                 else
%                 %                     suj_table         = group_table(group_table.sub_idx ==sb & group_table.CUE ==cue-2 & group_table.DIS==dis-1 & group_table.CORR==1,11);
%                 %                 end
%                 
%                 new_data                            = PrepAtt22_calc_tukey(suj_table.RT);
%                 new_data                            = new_data(new_data(:,2) ==0,1);
%                 mtrx(1,ngroup,sb,cue,dis)           = median(suj_table.RT);
%                 mtrx(2,ngroup,sb,cue,dis)           = median(new_data);
% 
%                 %                 for j = 2:size(mtrx,1)
%                 %                     mtrx(j,ngroup,sb,cue,dis) = (mtrx(j,ngroup,sb,cue,dis)/mtrx(1,ngroup,sb,cue,dis))*100;
%                 %                 end
%                 
%             end
%             
%         end
%         
%     end
%     
% end
%  
% clearvars -except behav_summary behav_table lst_group mtrx ; close all;
% 
% lst_error = {'miss','false alarm','incorrect'};
% lst_cue   = {'NL','NR','L','R'};
% lst_dis   = {'D0','D1','D2'};
% 
% i = 0;
% 
% for err = 1:size(mtrx,1)
%     
% %         figure ;
%     
%     for xi = 1:4
%         
%                 i = i + 1;
%         
%         %         ncue            = squeeze(mtrx(err,xi,:,1,1));
%         %         lcue            = squeeze(mtrx(err,xi,:,2,1));
%         %         rcue            = squeeze(mtrx(err,xi,:,3,1));
%         %
%         %         data1           = ncue;
%         %         data2           = lcue;
%         %         data3           = rcue;
%         %
%         %         [h,p_1(xi,err)] = ttest(data1,data2);
%         %         [h,p_2(xi,err)] = ttest(data1,data3);
%         %         [h,p_3(xi,err)] = ttest(data2,data3);
%         
%         subplot(2,4,i)
%         
%         hold on 
%         
%         for cue = 1:4
%             
%             data        = squeeze(mtrx(err,xi,:,cue,:));
%             avg         = squeeze(mean(data,1));
%             stndrd      = squeeze(std(data,1));
%             sem         = stndrd/sqrt(14);
%             
%             errorbar(avg',sem','LineWidth',2)
%             
%         end
%         
%         title([lst_group{xi}])
%         legend(lst_cue,'Location', 'Northeast')
%         
%         %         legend({'Ncue','LCue','Rcue'},'Location', 'Northeast')
%         %         legend({'Vcue','Ncue'});
%         
%         set(gca,'Xtick',0:1:5)
%         xlim([0 4])
%         ylim([200 700])
%         set(gca,'Xtick',0:5,'XTickLabel', {'','NoDis','DIS1','DIS2',''})
%         
%         clear data avg sem stndrd
%         
%     end
%     
% end