clear;clc;

suj_list                                = {'p006' 'p007' 'p008' 'p009' 'p011' 'p012' , ...
    'p013' 'p014' 'p015' 'p016' 'p017'};

stim_used                               = [];

for nsuj = 1:length(suj_list)
    
    %load log file
    subjectname                         = suj_list{nsuj};
    filename                            = ['../Logfiles/' subjectname '/' subjectname '_taco_block_Logfile.mat'];
    fprintf('loading %s\n',filename);
    load(filename);
    
    tmp                                 = unique([Info.TrialInfo.samp1(:,2) ; Info.TrialInfo.samp2(:,2) ; Info.TrialInfo.samp2(:,2)]);
    stim_used(nsuj,1)                   = min(tmp);
    stim_used(nsuj,2)                   = max(tmp);
    stim_used(nsuj,3)                   = max(tmp) - min(tmp);
    
end

keep stim_used