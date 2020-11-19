clear;clc;

suj_list                                = {'p006' 'p007' 'p008' 'p009' 'p011' 'p012' , ...
                                            'p013' 'p014' 'p015' 'p016' 'p017'}; % 'p010' 
i                                       = 0;

for nsuj = 1:length(suj_list)
    
    %load log file
    subjectname                         = suj_list{nsuj};
    filename                            = ['../Logfiles/' subjectname '/' subjectname '_taco_block_Logfile.mat'];
    fprintf('loading %s\n',filename);
    load(filename);
    
    Info                                = taco_cleaninfo(Info);%% remove empty trials
    Info                                = taco_fixlog(subjectname,Info);%% fix subjects
    Info                                = Info.TrialInfo;
    
    list_block                          = {'fixed-fixed' 'fixed-jittered' 'jitterd'};
    list_new_block                      = {'fix-fix' 'jit-fix' 'fix-jit'};
    list_cue                            = {'pre' 'retro'};
    list_attend                         = {'first' 'second'};
    
    for ntrial = 1:height(Info)
        
        i                               = i + 1;
        
        behav_summary(i).suj            = subjectname;
        
        
        tmp                             = find(strcmp(list_block,Info(ntrial,:).bloctype{:}));
        behav_summary(i).bloc           = list_new_block{tmp}; clear tmp;
        
        behav_summary(i).cue            = list_cue{Info(ntrial,:).cue};
        behav_summary(i).attend         = list_attend{Info(ntrial,:).attend};
        behav_summary(i).correct        = Info(ntrial,:).repCorrect{:};
        behav_summary(i).rt             = Info(ntrial,:).repRT{:};
        
    end
    
    clear Info;
    
end

keep behav_summary

behav_summary                           = struct2table(behav_summary);
writetable(behav_summary,'taco_behavpilot_singletrial.txt');