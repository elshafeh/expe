function gen_sequence(nb_dis,block_type)

fprintf('\n')

% 4 arcehtype trials
list_cue                        = {{'arrow_left','arrow_stay'},{'arrow_left','arrow_switch'},{'arrow_right','arrow_stay'},{'arrow_right','arrow_switch'}};

% create all possible DIS trials
list_stim                       = {'arrow_left','arrow_stay','arrow_right','arrow_switch'};
list_indx                       = [];
cntr                            = 0;

for dis1 = 1:length(list_stim)
    for dis2 = 1:length(list_stim)
        for dis3 = 1:length(list_stim)
            
            cntr                = cntr + 1;
            
            if nb_dis == 4
                
                for dis4 = 1:length(list_stim)
                    
                    list_dis{cntr,1}    = list_stim{dis1};
                    list_dis{cntr,2}    = list_stim{dis2};
                    list_dis{cntr,3}    = list_stim{dis3};
                    list_dis{cntr,4}    = list_stim{dis3};
                    
                    list_indx           = [list_indx;cntr dis4];
                    
                end
                
            else
                
                list_dis{cntr,1}    = list_stim{dis1};
                list_dis{cntr,2}    = list_stim{dis2};
                list_dis{cntr,3}    = list_stim{dis3};
                list_indx           = [list_indx;cntr dis3];
                
            end
        end
    end
end

clearvars -except list_* nb_dis block_type;

% create no-dis trials
cntr                            = 0;

for ntype = 1:4
    
    if strcmp(block_type,'train')
        tot_nb_repeat                   = 4;
    else
        tot_nb_repeat                   = 24;
    end
    
    for nr = 1:tot_nb_repeat
        
        cntr                            = cntr + 1;
        list_trial{cntr,1}              = list_cue{ntype}{1};
        list_trial{cntr,2}              = list_cue{ntype}{2};
        
        for ix = 1:nb_dis % number of dis
            list_trial{cntr,2+ix}       = 'cross_default';
        end
        
    end
end

for ntype = 1:4
    
    % for each type create (nb_trial=6) trials for each distractor-set
    % ending (4)
    
    if strcmp(block_type,'train')
        nb_trial    = 1;
    else
        nb_trial    = 6;
    end
    
    for nb_dis_end = 1:4
        
        flg                                 = Shuffle(list_indx(list_indx(:,2) == nb_dis_end,1));
        flg                                 = flg(1:nb_trial);
        
        for iy = 1:nb_trial % how many trials per permutation
            
            cntr                            = cntr + 1;
            list_trial{cntr,1}              = list_cue{ntype}{1};
            list_trial{cntr,2}              = list_cue{ntype}{2};
            
            for ix = 1:nb_dis % number of dis
                list_trial{cntr,2+ix}       = list_dis{flg(iy),ix};
            end
        end
        
    end
end

clearvars -except list_trial nb_dis

for nt = 1:size(list_trial,1)
    
    if strcmp(list_trial{nt,1},'arrow_left')
        
        if strcmp(list_trial{nt,2},'arrow_stay')
            list_trial{nt,nb_dis+3}    = 1;
        else
            list_trial{nt,nb_dis+3}    = 2;
        end
        
    elseif strcmp(list_trial{nt,1},'arrow_right')
        
        if strcmp(list_trial{nt,2},'arrow_stay')
            list_trial{nt,nb_dis+3}    = 2;
        else
            list_trial{nt,nb_dis+3}    = 1;
        end
        
    end
end

clearvars -except list_trial 

for nt = 1:size(list_trial,1) % loop through trials
    for ns = 1:size(list_trial,2) % loop through stim
        
        if ns == size(list_trial,2)
            fprintf('%d;\n',list_trial{nt,ns});
        else
            fprintf('%s\t',list_trial{nt,ns});
            fprintf('%s\t',['"' list_trial{nt,ns} '"']);
            
        end
        
    end
end