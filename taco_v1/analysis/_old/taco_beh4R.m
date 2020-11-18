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
    list_cue                            = {'pre' 'retro'};
    list_attend                         = {'first' 'second'};
    
    for nbloc = 1:length(list_block)
        
        flg                             = find(strcmp([Info.TrialInfo.bloctype],list_block{nbloc}));
        blocinfo                        = Info.TrialInfo(flg,:);
        
        for ncue = 1:2
            for natt = 1:2
                                
                new_names             	= {'fixed-fixed' 'jittered-fixed' 'jittered'};

                
                mtrx_find               = [[blocinfo.cue] [blocinfo.attend]];
                flg                     = find(mtrx_find(:,1) == ncue & mtrx_find(:,2) == natt);
                
                condinfo                = blocinfo(flg,:);
                
                nb_correct_trials       = sum(cell2mat([condinfo.repCorrect]));
                perc_correct            = nb_correct_trials ./ height(condinfo);
                
                find_correct_trials    	= find(cell2mat([condinfo.repCorrect]) == 1);
                rt_vector               = cell2mat(condinfo(find_correct_trials,:).repRT);
                rt_no_outlier           = calc_tukey(rt_vector);
                
                med_rt                  = median(rt_vector);
                tuk_rt                  = median(rt_vector(rt_no_outlier));
                
                i                       = i + 1;
                
                behav_summary(i).suj    = subjectname;
                behav_summary(i).bloc 	= new_names{nbloc};
                behav_summary(i).cue    = list_cue{ncue};
                behav_summary(i).attend	= list_attend{natt};
                behav_summary(i).perc_correct	= perc_correct;
                behav_summary(i).med_rt	= med_rt;
                behav_summary(i).tuk_rt	= tuk_rt;
                
                clear condinfo mtrx_find flg nb_correct_trials perc_correct find_correct_trials med_rt tuk_rt
                
            end
        end
    end
end

keep behav_summary

writetable(struct2table(behav_summary),'taco_behavpilot.txt');