clear;clc;


big_list{1}                          	= {'p006' 'p007' 'p008' 'p009' 'p011' 'p012' , ...
    'p013' 'p014' 'p015' 'p016' 'p017'};

big_list{2}                          	= {'p001' 'p002' 'p003' 'p004' 'p005' 'p006' , ...
    'p007' 'p008'};


i                                           = 0;

for ii = 1:2
    
    if ii == 1
        dir_data = '../v1/Logfiles/';
    else
        dir_data = '../v2/Logfiles/';
    end
    
    suj_list                                = big_list{ii};
    
    for nsuj = 1:length(suj_list)
        
        %load log file
        subjectname                         = suj_list{nsuj};
        filename                            = dir([dir_data subjectname '/' subjectname '_taco*block_Logfile.mat']);
        filename                            = [filename(1).folder filesep filename(1).name];
        fprintf('loading %s\n',filename);
        load(filename);
        
        Info                                = taco_cleaninfo(Info);%% remove empty trials
        Info                                = Info.TrialInfo;
        
        stim_used                           = unique([Info.samp1(:,2) ; Info.samp2(:,2) ; Info.target(:,2)]);
        stim_diff                           = stim_used(end) - stim_used(1);
        
        if ii == 1
            list_block                    	= {'fixed-fixed' 'jitterd'};
        else
            list_block                    	= {'early' 'jittered'};
        end
        
        list_new_block                      = {'fixed' 'jittered'};
        list_cue                            = {'pre' 'retro'};
        list_attend                         = {'first' 'second'};
        
        for ntrial = 1:height(Info)
            
            tmp                             = find(strcmp(list_block,Info(ntrial,:).bloctype{:}));
            
            if ~isempty(tmp)
                i                         	= i + 1;
                behav_summary(i).suj       	= ['v' num2str(ii) '-' subjectname(2:end)];
                behav_summary(i).bloc      	= list_new_block{tmp}; clear tmp;
                behav_summary(i).StimDiff  	= stim_diff;
                behav_summary(i).cue       	= list_cue{Info(ntrial,:).cue};
                behav_summary(i).attend    	= list_attend{Info(ntrial,:).attend};
                behav_summary(i).correct  	= Info(ntrial,:).repCorrect{:};
                behav_summary(i).rt        	= Info(ntrial,:).repRT{:};
            end
            
        end
        
        clear Info;
        
    end
end

keep behav_summary

behav_summary                           = struct2table(behav_summary);
writetable(behav_summary,'taco_behavpilot_combined.txt');