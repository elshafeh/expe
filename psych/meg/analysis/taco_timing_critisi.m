function taco_timing_critisi

global info

figure;
suj_list                        = info.suj_list;
if length(suj_list) == 1
    nrow = 2;
else
    nrow                       	= length(suj_list);
end
ncol                            = 3;
i                               = 0;

for nsuj = 1:length(suj_list)
    
    % load log file
    subjectname                 = suj_list{nsuj};
    filename                    = ['../Logfiles/' subjectname '/' subjectname '_taco_meg_block_Logfile.mat'];
    fprintf('loading %s\n',filename);
    load(filename);
    
    Info                        = taco_cleaninfo(Info); % remove empty trials
    
    list_block                  = {'early' 'late' 'jittered'};
    
    for nbloc = 1:3
        
        flg                   	= find(strcmp([Info.TrialInfo.bloctype],list_block{nbloc}));
        blocinfo                = Info.TrialInfo(flg,:);
        
        rt                      = cell2mat([blocinfo.repRT]);
        i = i + 1;
        
        if ~isempty(rt)
            
            all_isi                 = [];
            
            for nt = 1:height(blocinfo)-1
                
                % c c c g g g g c c c  g  g
                % 1 2 3 4 5 6 7 8 9 10 11 12
                trialtiming         = cell2mat(blocinfo(nt,:).trigtime);
                
                nd_cue_onset        = trialtiming(9);
                probe_onset         = trialtiming(12);
                
                tmp                 = probe_onset - nd_cue_onset;
                all_isi             = [all_isi; tmp]; clear tmp *_onset
                
            end
            
            subplot(nrow,ncol,i)
            histogram(all_isi,'BinWidth',0.04);
            xlabel('Time (s)');
            title([subjectname ' ISI ' list_block{nbloc}]);
            xlim([0 4]);
            xticks([0:0.5:4]);
            
        end
    end
end

clc;