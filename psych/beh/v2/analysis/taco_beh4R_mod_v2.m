clear;clc;

flist                                 	= dir('../Logfiles/p*');
suj_list                              	= {};
% automatically count subjects
for nf = 1:length(flist)
    sujname                           	= strsplit(flist(nf).name,'-bpilot'); 
    suj_list{end+1}                   	= sujname{1}; clear sujname;
end

suj_list                              	= unique(suj_list);

i                                       = 0;

for nsuj = 1:length(suj_list)
    
    %load log file
    subjectname                         = suj_list{nsuj};
    filename                            = ['../Logfiles/' subjectname '/' subjectname '_taco_v2_block_Logfile.mat'];
    fprintf('loading %s\n',filename);
    load(filename);
    
    Info                                = taco_cleaninfo(Info);%% remove empty trials
    Info                                = Info.TrialInfo;
    
    stim_used                           = unique([Info.samp1(:,2) ; Info.samp2(:,2) ; Info.target(:,2)]);
    stim_diff                           = stim_used(end) - stim_used(1);
    
    list_block                          = {'early' 'late' 'jittered'};
    list_new_block                      = list_block;
    list_cue                            = {'pre' 'retro'};
    list_attend                         = {'first' 'second'};
    
    for ntrial = 1:height(Info)
        
        i                               = i + 1;
        
        behav_summary(i).suj            = subjectname;
        
        
        tmp                             = find(strcmp(list_block,Info(ntrial,:).bloctype{:}));
        behav_summary(i).bloc           = list_new_block{tmp}; clear tmp;
        behav_summary(i).StimDiff    	= stim_diff;
        behav_summary(i).cue            = list_cue{Info(ntrial,:).cue};
        behav_summary(i).attend         = list_attend{Info(ntrial,:).attend};
        behav_summary(i).correct        = Info(ntrial,:).repCorrect{:};
        behav_summary(i).rt             = Info(ntrial,:).repRT{:};
        
    end
    
    clear Info;
    
end

keep behav_summary

behav_summary                           = struct2table(behav_summary);
writetable(behav_summary,'taco_v2_behavpilot_singletrial.txt');