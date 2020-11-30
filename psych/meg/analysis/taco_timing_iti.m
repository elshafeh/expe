function taco_timing_iti

global info

figure;
suj_list                    = info.suj_list;

if length(suj_list) == 1
    nrow = 2;
else
    nrow                       	= length(suj_list);
end

ncol                        = 3;
i                           = 0;

for nsuj = 1:length(suj_list)
    
    % load log file
    subjectname                 = suj_list{nsuj};
    filename                    = ['../Logfiles/' subjectname '/' subjectname '_taco_v2_block_Logfile.mat'];
    fprintf('loading %s\n',filename);
    load(filename);
        
    Info                        = taco_cleaninfo(Info); % remove empty trials
    
    list_block                  = {'early' 'late' 'jittered'};
    
    for nbloc = 1:3
        
        flg                   	= find(strcmp([Info.TrialInfo.bloctype],list_block{nbloc}));
        blocinfo                = Info.TrialInfo(flg,:);
        
        all_iti          	= [];
        
        for nt = 1:height(blocinfo)-1
            
            % c c c g g g g c c c  g  g
            % 1 2 3 4 5 6 7 8 9 10 11 12
            trialtiming   	= cell2mat(blocinfo(nt,:).trigtime);
            probe_onset   	= trialtiming(11);
            trialtiming   	= cell2mat(blocinfo(nt+1,:).trigtime);
            next_cue_onset	= trialtiming(2);
            
            rt              = cell2mat(blocinfo(nt,:).repRT);
            
            all_iti       	= [all_iti; (next_cue_onset-probe_onset)-rt]; clear next_cue_onset probe_onset trialtiming
            
        end
        
        i = i + 1;
        subplot(nrow,ncol,i)
        histogram(all_iti,'BinWidth',0.1);
        xlabel('Time (s)');
        title([subjectname ' iti: Gab2NextCue ' list_block{nbloc}]);
        xlim([3 4.5]);
        ylim([0 30]);
        
    end
end

clc;