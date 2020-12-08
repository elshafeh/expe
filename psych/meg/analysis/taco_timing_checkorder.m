function taco_timing_checkorder

global info

clc;
suj_list                                = info.suj_list;

fprintf('\n');
fprintf('%8s\t%8s\t%8s\t%8s\t%8s\t%8s\t%8s\t%8s\t%8s\t%8s\n','sub','bloc1','bloc2','bloc3','bloc4','bloc5','bloc6','bloc7','bloc8');
fprintf('     -------------------------------------------------------------------\n');

for nsuj = 1:length(suj_list)
    
    %load log file
    subjectname                         = suj_list{nsuj};
    filename                            = ['../Logfiles/' subjectname '/' subjectname '_taco_meg_block_Logfile.mat'];
    load(filename);
    
    Info                                = taco_cleaninfo(Info);%% remove empty trials    
    bloc_size                           = 32;
    
    fprintf('%8s\t',subjectname);
    
    for nt = 1:bloc_size:256
        fprintf('%8s\t',Info.TrialInfo(nt,:).bloctype{:});
    end
    
    fprintf('\n');
    
end

keep bloc_order list_block

fprintf('\n');