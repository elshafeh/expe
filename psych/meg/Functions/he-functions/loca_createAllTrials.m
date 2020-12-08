function bloc_structure = loca_createAllTrials

global Info

possibStim              = [];
i                       = 0 ;

for possib1 = 1:2 % low or high
    for possib2 = 1:2 % black or white fixation
        
        i           = i + 1;
        possibStim  = [possibStim; possib1 possib2 i];
    end
end

possibStim          = repmat(possibStim,[Info.blocklength/4 1]);

% add catach trials
possibDeg           = [repmat(90,Info.blocklength * 0.9,1);repmat(180,Info.blocklength * 0.1,1)];
possibDeg          	= possibDeg(randperm(length(possibDeg)));

clear possib1 possib2;


% adapt difference between frequenceies
% aka poor man's staircase

difficulty_levels   = [0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49];
StimCyc             = [difficulty_levels(Info.difficulty) 0.5];

bloc_structure      = [];

possibISI          	= linspace(1.48,1.52,10);
possibISI          	= possibISI(randperm(length(possibISI)))';
possibISI          	= repmat(possibISI,[length(possibStim)/10 1]);

for nt = 1:length(possibStim)
    
    samp_freq                    	= possibStim(nt,1);
    samp_fix                     	= possibStim(nt,2);
    
    StimDeg                         = possibDeg(nt);
    bloc_structure(nt).samp         = [StimDeg StimCyc(samp_freq)];
    bloc_structure(nt).color        = samp_fix;
    
    
    bloc_structure(nt).MaskCon  	= 0.6; % fixed
    
    bloc_structure(nt).nmbr      	= nt;
    bloc_structure(nt).trigtime  	= [];
    bloc_structure(nt).ISI          = possibISI(nt);
    
    if StimDeg == 90
        bloc_structure(nt).sampClass  	= possibStim(nt,3);
    else
        bloc_structure(nt).sampClass  	= possibStim(nt,5);
    end
    
end

clearvars -except bloc_structure

bloc_structure                      = struct2table(bloc_structure);