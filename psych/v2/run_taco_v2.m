%% Set Environment

tic;

sca;
clear;

addpath(genpath('Functions/'));

global wPtr scr stim ctl Info el useEyetrack

Info.name                 	= input('Subject name                 	: ','s'); % example sub001
Info.runtype               	= input('Session (train, block)          : ','s'); % training , main experiment or localizer
Info.difficulty            	= input('[1 - 10] [easy-difficult]       : '); % Target contrast
Info.gratingframes        	= 6; % 1frame: 0.0167    6frame: 0.1000    7frame: 0.1167 8frame: 0.1333

Info.debug                 	= 'no' ; % if yes: you open smaller window (for debugging)
Info.MotorResponse        	= 'yes'; % if no: you disable bitsi responses (for debugging)

switch Info.runtype
    case 'block'
        Info.track         	= 'n'; %input('Launch eye-tracking  [y/n]     : ','s'); % launch eye_tracking
        if strcmp(Info.track,'y')
            Info.tracknumber  	= input('tracking session number       	: ','s'); % keep tracking of how many training sessions
            Info.eyefile   	= [Info.name(4:end) '00' Info.tracknumber];
        end
        Info.blocklength   	= 32;
        
    case 'train'
        Info.runnumber     	= num2str(length(dir(['Logfiles' filesep Info.name filesep '*train*']))+1);
        Info.track        	= 'n';
        Info.blocklength   	= 16;
end

taco_setParameters;
taco_start;

if strcmp(Info.track,'y')
    % = % Start Eyetracking
    [el,exitFlag]        	= rd_eyeLink('eyestart', wPtr, Info.eyefile);
    useEyetrack            	= 0;
    if exitFlag, return; end
    
    % = % Calibrate eye tracker
    [cal,exitFlag]      	= rd_eyeLink('calibrate', wPtr, el);
    if exitFlag, return; end
    
    % = % Start recording
    rd_eyeLink('startrecording',wPtr, el);
    useEyetrack        	= 1;
end

%% Load In / Create Targets beforehand to save time
[AllStim]      	= taco_CreateAllTargets;

if strcmp(Info.debug,'no')
    HideCursor;
end

%% show stim for subject

for nstim = 1:2
    taco_instructstim(nstim);
    taco_playstim(stim.stock{nstim})
end

h_emptybitsi;
%% Loop Through Trials

% just in case during one of the blocks , an error happened and the
% experiment needed to be restarded : this script will make sure to restart
% from the block with the missing trials
strt                                    = 1; %taco_check_start(Info);

for ntrial = 1:height(Info.TrialInfo)
    
    ix                                  = ntrial;
    nw_b_flg                            = h_chk_if_new_block(Info,ix);
    
    fprintf('Trial no %3d \n',ix);
    
    %         if ~strcmp(Info.runtype,'train')
    %             taco_headlocaliserbreak;
    %         end
    
    if nw_b_flg == 1
        taco_BlockStart;
    end
    
    h_emptybitsi;
    
    %% fixed parameters
    CueInfo.dur                     	= stim.dur.cue;
    CueInfo.type                        = Info.TrialInfo(ix,:).cue;
    CueInfo.attend                      = Info.TrialInfo(ix,:).attend;
    
    % choose which mapping will be shown
    ctl.maptype                         = Info.TrialInfo(ix,:).mapping;
    ctl.tmpSRMapping                    = Info.resp_map{Info.TrialInfo(ix,:).mapping}; 
    ctl.expectedRep                     = ctl.tmpSRMapping(ctl.tmpSRMapping(:,2) == Info.TrialInfo(ix,:).ismatch,1);
    
    %% Draw the first cue
    CueInfo.order                   	= 1;
    CueInfo.t_wait                      = Info.TrialInfo(ix,:).ITI;
    CueInfo.code                        = (CueInfo.order*100) + (CueInfo.type*10) + (CueInfo.attend);
    if nw_b_flg ~= 1
        CueInfo.t_offset            	= tfin; clear tfin;
    end
    [tcue1,tcue2,tcue3]                	= taco_drawcue(CueInfo);
    
    %% Draw first sample
    stim.dur.ISI                        = Info.TrialInfo(ix,:).ISI(1); % 1st delay
    stim.order                        	= 1;
    stim.code                          	= 10 + Info.TrialInfo(ix,:).samp1Class;
    stim.t_offset                       = tcue3;
    stim.t_wait                         = (stim.dur.ISI-CueInfo.dur);
    [t1,t2]                             = taco_drawstim(AllStim{ntrial,stim.order});
    
    Info.TrialInfo.trigtime{ix}         = [Info.TrialInfo.trigtime{ix};tcue1;tcue2;tcue3;t1;t2];
        
    %% Draw 2nd sample
    stim.dur.ISI                        = Info.TrialInfo(ix,:).ISI(2); % 2nd delay
    stim.order                       	= 2;
    stim.code                          	= 20 + Info.TrialInfo(ix,:).samp2Class;
    stim.t_offset                       = t2;
    stim.t_wait                         = stim.dur.ISI-stim.dur.target;
    [t1,t2]                             = taco_drawstim(AllStim{ntrial,stim.order});
    
    Info.TrialInfo.trigtime{ix}      	= [Info.TrialInfo.trigtime{ix};t1;t2]; 
    
    %% Draw the second cue    
    stim.dur.ISI                        = Info.TrialInfo(ix,:).ISI(3); % 3rd delay
    CueInfo.order                       = 2;
    CueInfo.t_wait                      = stim.dur.ISI-stim.dur.target;
    CueInfo.t_offset                    = t2;
    CueInfo.code                        = (CueInfo.order*100) + (CueInfo.type*10) + (CueInfo.attend);
    [tcue1,tcue2,tcue3]               	= taco_drawcue(CueInfo);
    
    Info.TrialInfo.trigtime{ix}       	= [Info.TrialInfo.trigtime{ix};tcue1;tcue2;tcue3]; clear tcue1 tcue2 t1 t2 t3
    
    %% Draw probe
    stim.order                       	= 3;
    stim.code                          	= 30 + Info.TrialInfo(ix,:).samp2Class;
    stim.t_offset                       = tcue3;
    stim.t_wait                         = (Info.TrialInfo(ix,:).crit_soa - CueInfo.dur);
    [t1,t2]                             = taco_drawstim(AllStim{ntrial,stim.order});
    
    Info.TrialInfo.trigtime{ix}      	= [Info.TrialInfo.trigtime{ix};t1;t2];
    
    %% Get Response
    if strcmp(Info.MotorResponse,'yes')
        ctl.t_offset                    = t2; clear t1 t2 t3
        ctl.t_wait                      = stim.dur.ISI-stim.dur.target;
        [repRT,repButton,repCorrect,t_disp]  	= taco_getResponse;
        Info.TrialInfo.trigtime{ix}   	= [Info.TrialInfo.trigtime{ix};t_disp];
    else
        repRT                         	= 50;
        repButton                      	= 51;
        repCorrect                    	= [1 0]; repCorrect = repCorrect(randi(2));
    end
    
    Info.TrialInfo.repRT{ix}          	= repRT;
    Info.TrialInfo.repButton{ix}       	= repButton;
    Info.TrialInfo.repCorrect{ix}     	= repCorrect;
    ctl.correct                       	= repCorrect; % to display the feedback :)
    
    clear repRT repButton repCorrect
    
    %% End Trial
    tfin                             	= taco_endTrial;

    h_emptybitsi;
    
    %% End block
    % this will end block and save the block information ;
    % after each block it will do that in the background just in case an
    % error occurs.
    
    if strcmp(Info.runtype,'train') 
        if ntrial == Info.blocklength
            h_emptybitsi;
            taco_BlockEnd(1:Info.blocklength);toc;
            save(Info.logfilename,'Info','-v7.3');
        end
    else
        
        trl_full_break      = [Info.blocklength:Info.blocklength:Info.blocklength*20];
        fnd_full_break    	= find(trl_full_break == ntrial);
        
        if ~isempty(fnd_full_break)
            i1  = ntrial - (Info.blocklength-1);
            i2  = ntrial;
            h_emptybitsi;
            taco_BlockEnd([i1 i2]);toc;
            save(Info.logfilename,'Info','-v7.3');
        end
        
    end
    
    h_emptybitsi;

    clear CueInfo nw_b_flg
    
end

% = % end experiment and save data (including eye tracking)
if useEyetrack, rd_eyeLink('eyestop', wPtr, {Info.eyefile, Info.eyefolder}); end

sca;
ShowCursor;

clearvars -except Info;

% make sure that performances are saved
save(Info.logfilename,'Info','-v7.3');

% to give idea on behavioral peformances
taco_analyzebehav(Info.TrialInfo);

toc;