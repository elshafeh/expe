function bloc_structure = taco_CreateAllTrials

global Info

possibStim              = [];

for possib1 = 1:2 % high or low
    for possib2 = 1:2 % high or low
        for possib3 = 1:2 % high or low
            for possib4 = 1:2 % match first or second
                for possib5 = 1:2 % pre or retro
                    possibStim  = [possibStim; possib1 possib2 possib3 possib4 possib5];
                end
            end
        end
    end
end

clear possib1 possib2 possib3 possib4 possib5;

StimDeg             = 90;

% adapt difference between frequenceies
% aka poor man's staircase

difficulty_levels   = [0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49];
StimCyc             = [difficulty_levels(Info.difficulty) 0.5];

jitternames     	= {'early' 'late' 'jittered'};
possibMatch         = [1 0]; % {'yes','no'};
bloc_structure      = [];

% we need to loop through
% [1] Jitter conditions
% [2] cues: pre and retro
% [3] match: first or second

% define jitter
% subsample for training blocks
if strcmp(Info.runtype,'block')
    
    % create latin square for block order ; here 4 and 3 are jittered
    % thus 50:50 fixed:jittered
    
    possibBlock     = [3	4	2	3	2	1	1	4
                        4	1	3	2	1	4	3	2
                        4	1	1	4	3	3	2	2
                        1	2	3	4	1	2	4	3
                        1	4	2	2	3	3	1	4
                        2	3	1	1	4	2	4	3
                        3	2	4	1	2	4	3	1
                        2	3	4	3	4	1	2	1];
                    
    possibJitter    = repmat(possibBlock,7,1); clear possibBlock;
    
    subject_prefix      = 'sub';
    tmp                 = strsplit(Info.name,subject_prefix);tmp = str2double(tmp{end});
    
    if isnan(tmp) || tmp == 0
        tmp             = randi(length(possibJitter));
        possibJitter	= possibJitter(tmp,:); clear tmp;
    else
        possibJitter   	= possibJitter(tmp,:); clear tmp;
    end
    
    possibRepeat    = 1;
    
elseif strcmp(Info.runtype,'train')
    
    possibJitter   	= 1; % fixed (early) ; 1 block
    shuffle_vector  = randperm(length(possibStim));
    possibStim      = possibStim(shuffle_vector(1:16),:); % choose only 16 trials
    possibRepeat    = 1;
    
end

% to make it easier for loops later :)
possibJitter(possibJitter == 4) = 3;

for njitter = 1:length(possibJitter)
    
    trial_idx       = 0;
    det_jitter      = possibJitter(njitter);
    
    for nrepeat = 1:possibRepeat
        for ncombi = 1:length(possibStim)
            
            trial_idx                             	= trial_idx + 1;
            
            samp1_type                            	= possibStim(ncombi,1);
            samp2_type                             	= possibStim(ncombi,2);
            probe_type                             	= possibStim(ncombi,3);
            
            nfocus                                 	= possibStim(ncombi,4);
            ncuetype                               	= possibStim(ncombi,5);
            
            trial_structure(trial_idx).samp1       	= [StimDeg StimCyc(samp1_type)];
            trial_structure(trial_idx).samp2       	= [StimDeg StimCyc(samp2_type)];
            trial_structure(trial_idx).cue        	= ncuetype;
            trial_structure(trial_idx).target     	= [StimDeg StimCyc(probe_type)];
            
            
            trial_structure(trial_idx).attend     	= nfocus;
            if nfocus == 1
                trial_structure(trial_idx).ismatch 	= possibMatch(length(unique([samp1_type probe_type])));
            else
                trial_structure(trial_idx).ismatch 	= possibMatch(length(unique([samp2_type probe_type])));
            end
            
            % for info
            % 1frame    6frame    7frame 8frame 9frame
            % [0.0167    0.1000    0.1167 0.1333]
            
            trial_structure(trial_idx).MaskCon    	= 0.6; % fixed
            
            trial_structure(trial_idx).nbloc       	= det_jitter;
            
            trial_structure(trial_idx).repRT       	= [];
            trial_structure(trial_idx).repButton   	= [];
            trial_structure(trial_idx).repCorrect  	= [];
            
            trial_structure(trial_idx).nmbr      	= trial_idx;
            
            % -- useful for coding later on
            trial_structure(trial_idx).samp1Class  	= samp1_type;
            trial_structure(trial_idx).samp2Class  	= samp2_type;
            trial_structure(trial_idx).probeClass  	= probe_type;
            % --
            
            trial_structure(trial_idx).bloctype    	= jitternames{det_jitter};
            
            trial_structure(trial_idx).trigtime   	= [];
            
        end
    end
    
    % assign response mapping
    trial_structure                                 = h_assignmapping(trial_structure);
    % Shuffle
    trial_structure                                 = trial_structure(Shuffle(1:length(trial_structure)));
    
    % add jittered ITI AND critical SOA here
    
    min_soa                                         = 1.5;
    max_soa                                         = 3.5;
    possibITI                                       = linspace(2,2.5,length(trial_structure));
    
    % matrix of isi
    if strcmp(Info.runtype,'block')
        switch det_jitter
            case 1
                % fixed-early
                possibISI                           = repmat(1.5,length(trial_structure),3); % cue-1st 1st-2nd 2nd-cue
                
                for nt = 1:length(trial_structure)
                    trial_structure(nt).crit_soa    = min_soa; % cue-probe
                    trial_structure(nt).ITI         = possibITI(nt);
                    trial_structure(nt).ISI     	= possibISI(nt,:);
                    
                end
                
            case 2
                % fixed-late
                possibISI                           = repmat(1.5,length(trial_structure),3); % cue-1st 1st-2nd 2nd-cue
                
                for nt = 1:length(trial_structure)
                    trial_structure(nt).crit_soa    = max_soa;
                    trial_structure(nt).ITI         = possibITI(nt);
                    trial_structure(nt).ISI     	= possibISI(nt,:);
                end
                
            case 3
                % fixed-jittered
                possibSOA                           = linspace(1.5,3.5,length(trial_structure)/2);
                possibSOA                           = repmat(possibSOA,[1 2]);
                possibISI                           = repmat(1.5,length(trial_structure),3); % cue-1st 1st-2nd 2nd-cue
                
                for nt = 1:length(trial_structure)
                    trial_structure(nt).crit_soa    = possibSOA(nt);
                    trial_structure(nt).ITI         = possibITI(nt);
                    trial_structure(nt).ISI     	= possibISI(nt,:);
                end
                
        end
    else
        % for practice trials
        for nt = 1:length(trial_structure)
            trial_structure(nt).crit_soa            = min_soa;
            trial_structure(nt).ITI                 = possibITI(nt);
            trial_structure(nt).ISI                 = [min_soa min_soa min_soa];
        end
    end
    
    bloc_structure                                  = [bloc_structure trial_structure(Shuffle(1:length(trial_structure)))];
    
end

clearvars -except bloc_structure

bloc_structure                                      = struct2table(bloc_structure);