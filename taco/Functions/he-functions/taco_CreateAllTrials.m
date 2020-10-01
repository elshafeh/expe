function bloc_structure = taco_CreateAllTrials

global Info

possibStim              = [];

if strcmp(Info.runtype,'loca')
    for possib1 = 1:2 % high or low
        for possib2 = 1:2 % high or low
            possibStim      = [possibStim; possib1 possib2];
        end
    end
else
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
end

clear possib1 possib2 possib3 possib4 possib5;

StimDeg             = 90;

% adapt difference between frequenceies
% aka poor man's staircase

switch Info.difficulty
    case 1
        StimCyc  	= [0.2;0.6];
    case 2
        StimCyc  	= [0.3;0.6];
    case 3
        StimCyc  	= [0.3;0.5];
    case 4
        StimCyc  	= [0.4;0.5];
end

jitternames     	= {'fixed-fixed' 'fixed-jittered' 'jitterd'};
possibMatch         = [1 0]; % {'yes','no'};
bloc_structure      = [];

% we need to loop through
% [1] fixed-fixed [2] fixed-jittered [3] jitterd
% [2] cues: pre and retro
% [3] mapping: A and B
% [4] match: first or second

% define jitter
% subsample for training blocks
if strcmp(Info.runtype,'block')
    possibJitter   	= [1 2 3]; % 
    possibJitter   	= possibJitter(randperm(length(possibJitter))); % 
    possibRepeat    = 1;
elseif strcmp(Info.runtype,'train')
    possibJitter   	= 1; % fixed (early) ; 1 block
    possibStim      = possibStim([1 5 8 12 16 20 24 29],:);
    possibRepeat    = 1;
elseif strcmp(Info.runtype,'loca')
    possibJitter   	= ones(1,3); % fixed (early) ; 3 blocks
    possibRepeat    = 5;
end

for njitter = 1:length(possibJitter)
    
    trial_idx       = 0;
    
    for nrepeat = 1:possibRepeat
        for nmapping = 1:2
            for ncombi = 1:length(possibStim)
                
                trial_idx                                       = trial_idx + 1;
                
                samp1_type                                      = possibStim(ncombi,1);
                
                if strcmp(Info.runtype,'loca')
                    probe_type                               	= possibStim(ncombi,2);
                else
                    samp2_type                                  = possibStim(ncombi,2);
                    probe_type                               	= possibStim(ncombi,3);
                    nfocus                                      = possibStim(ncombi,4);
                    ncuetype                                    = possibStim(ncombi,5);
                end
                
                trial_structure(trial_idx).samp1                = [StimDeg StimCyc(samp1_type)];
                if ~strcmp(Info.runtype,'loca')
                    trial_structure(trial_idx).samp2          	= [StimDeg StimCyc(samp2_type)];
                    trial_structure(trial_idx).cue            	= ncuetype;
                end
                trial_structure(trial_idx).target            	= [StimDeg StimCyc(probe_type)];
                
                
                if strcmp(Info.runtype,'loca')
                    trial_structure(trial_idx).ismatch         	= possibMatch(length(unique([samp1_type probe_type])));
                else
                    trial_structure(trial_idx).attend         	= nfocus;
                    if nfocus == 1
                        trial_structure(trial_idx).ismatch    	= possibMatch(length(unique([samp1_type probe_type])));
                    else
                        trial_structure(trial_idx).ismatch    	= possibMatch(length(unique([samp2_type probe_type])));
                    end
                end
                
                % for info
                % 1frame    6frame    7frame 8frame 9frame
                % [0.0167    0.1000    0.1167 0.1333]
                
                frame_length                                    = 1/60;
                trial_structure(trial_idx).MaskCon              = 0.6; % fixed                
                
                trial_structure(trial_idx).nbloc                = njitter;
                trial_structure(trial_idx).mapping            	= nmapping;
                
                trial_structure(trial_idx).repRT                = [];
                trial_structure(trial_idx).repButton            = [];
                trial_structure(trial_idx).repCorrect           = [];
                
                trial_structure(trial_idx).nmbr                 = trial_idx;
                
                % -- useful for coding later on
                trial_structure(trial_idx).samp1Class         	= samp1_type;
                if ~strcmp(Info.runtype,'loca')
                    trial_structure(trial_idx).samp2Class     	= samp2_type;
                end
                trial_structure(trial_idx).probeClass         	= probe_type;
                % -- 
                
                trial_structure(trial_idx).bloctype             = jitternames{njitter};
                
                trial_structure(trial_idx).trigtime             = [];
                
            end
        end
    end
    
    % Shuffle 
    trial_structure                             = trial_structure(Shuffle(1:length(trial_structure)));
    
    % add jittered ITI AND critical SOA here
    
    min_soa                                     = 1.5;
    max_soa                                     = 3.5;
    possibITI                                   = linspace(2,2.5,length(trial_structure));
    
    % matrix of isi 
    
    
    if strcmp(Info.runtype,'block')
        switch njitter
            case 1
                % fixed-fixed
                possibISI                           = repmat(1.5,length(trial_structure),3); % cue-1st 1st-2nd 2nd-cue
                
                for nt = 1:length(trial_structure)
                    trial_structure(nt).crit_soa    = min_soa; % cue-probe
                    trial_structure(nt).ITI         = possibITI(nt);
                    trial_structure(nt).ISI     	= possibISI(nt,:);

                end
                
        case 2 
            % fixed-jittered
            possibISI                   = [linspace(1.4,1.6,length(trial_structure))]';
            possibISI                   = [possibISI(randperm(length(possibISI))) possibISI(randperm(length(possibISI))) possibISI(randperm(length(possibISI)))]; % cue-1st 1st-2nd 2nd-cue
            for nt = 1:length(trial_structure)
                trial_structure(nt).crit_soa    = min_soa;
                trial_structure(nt).ITI         = possibITI(nt);
                trial_structure(nt).ISI     	= possibISI(nt,:);
            end
            
        case 3 
            % jittered
            possibSOA       = linspace(1.5,3.5,length(trial_structure));
            possibISI    	= repmat(1.5,length(trial_structure),3); % cue-1st 1st-2nd 2nd-cue
            
            for nt = 1:length(trial_structure)
                trial_structure(nt).crit_soa    = possibSOA(nt);
                trial_structure(nt).ITI         = possibITI(nt);
                trial_structure(nt).ISI     	= possibISI(nt,:);
            end
                        
        end
    else
        % for practice trials
        for nt = 1:length(trial_structure)
            trial_structure(nt).crit_soa    	= min_soa;
            trial_structure(nt).ITI             = possibITI(nt);
        end
    end

    bloc_structure          = [bloc_structure trial_structure(Shuffle(1:length(trial_structure)))];
    
end


clearvars -except bloc_structure

bloc_structure              = struct2table(bloc_structure);