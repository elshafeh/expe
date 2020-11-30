%% Set Environment

tic; sca;clear;

addpath(genpath('Functions/'));

global wPtr scr stim Info

%% get subject info

prev_sub              	= length(dir('Logfiles/sub*'));
nw_numb                	= prev_sub;
if nw_numb < 10
    Info.name          	= ['sub00' num2str(nw_numb)];
elseif nw_numb > 10
    Info.name        	= ['sub0' num2str(nw_numb)];
end

Info.runtype            = 'loca';

tmp                     = load(['Logfiles/' Info.name '/' Info.name '_taco_meg_block_Logfile.mat']);
Info.difficulty       	= tmp.Info.difficulty; clear tmp;

Info.gratingframes    	= 6;      	% 1frame: 0.0167    6frame: 0.1000    7frame: 0.1167 8frame: 0.1333
Info.debug            	= 'no' ; 	% if yes: you open smaller window (for debugging)
Info.MotorResponse    	= 'yes';     % if no: you disable bitsi responses (for debugging)

Info.track              = 'n';
Info.blocklength        = 200;

taco_setParameters;
Info.TrialInfo          = loca_createAllTrials;
[AllStim]            	= taco_CreateAllTargets;

if strcmp(Info.debug,'no')
    HideCursor;
    h_emptybitsi;
end

%% show instructions and go through trials
loca_instruct;
taco_headlocaliserbreak;

for ntrial = 1:height(Info.TrialInfo)
    
    ix                       	= ntrial;
    
    h_emptybitsi;
    
    if ntrial == 1
        taco_drawFixation;
        tstart               	= Screen('Flip', wPtr);
        taco_darkenBackground;
    else
        tstart               	= tfin;
    end
    
    stim.dur.ISI              	= Info.TrialInfo(ix,:).ISI(1);
    
    if Info.TrialInfo(ix,:).color == 1
        stim.patch.FixColor 	= scr.black;
    else
        stim.patch.FixColor 	= scr.white;
    end
    
    stim.code                 	= 70 + Info.TrialInfo(ix,:).sampClass;
    stim.t_offset             	= tstart;
    stim.t_wait               	= (stim.dur.ISI-stim.dur.target);
    
    [t1,t2]                   	= taco_drawstim(AllStim{ntrial,1});
    Info.TrialInfo.trigtime{ix}	= [Info.TrialInfo.trigtime{ix};tstart;t1;t2];
    
    tfin                       	= taco_endTrial;
    h_emptybitsi;
    
end

%% end , save and clean-up

loca_end;

save(Info.logfilename,'Info','-v7.3');
h_emptybitsi;

sca;
ShowCursor;