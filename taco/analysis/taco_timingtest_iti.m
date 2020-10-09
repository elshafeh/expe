clear;clc;

suj_list    = {'p001' 'p002' 'p003' 'p006'};

nrow        = length(suj_list);
ncol        = 3;
i        	= 0;

for nsuj = 1:length(suj_list)
    
    % load log file
    subjectname             = suj_list{nsuj};
    filename                = ['../Logfiles/' subjectname '/' subjectname '_taco_block_Logfile.mat'];
    load(filename);
        
    for nbloc = 1:3
        
        flg             	= find(Info.TrialInfo.nbloc == nbloc);
        blocinfo          	= Info.TrialInfo(flg,:);
        
        
        
        all_iti          	= [];
        
        for nt = 1:height(blocinfo)-1
            
            % c c c g g g g g g c  c  c  g  g  g
            % 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
            trialtiming   	= cell2mat(blocinfo(nt,:).trigtime);
            probe_onset   	= trialtiming(14);
            trialtiming   	= cell2mat(blocinfo(nt+1,:).trigtime);
            next_cue_onset	= trialtiming(2);
            
            rt              = cell2mat(blocinfo(nt,:).repRT);
            
            all_iti       	= [all_iti; (next_cue_onset-probe_onset)-rt]; clear next_cue_onset probe_onset trialtiming
            
        end
        
        i = i + 1;
        subplot(nrow,ncol,i)
        histogram(all_iti,'BinWidth',0.1);
        xlabel('Time (s)');
        title([subjectname ' iti: Gab2NextCue Bloc' num2str(nbloc)]);
        xlim([3 4.5]);
        ylim([0 30]);
        
    end
end