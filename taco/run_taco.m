% = % Set Environment

sca;
clear ;

addpath(genpath('Functions/'));

global wPtr scr stim ctl Info el useEyetrack

Info.name                     	= 'test01'; % input('Subject name                 	: ','s'); % example sub001
Info.runtype                  	= 'train'; % input('Session (train, block)          : ','s'); % training , main experiment or localizer
Info.difficulty              	= 1; %input('[1-4] [easy-difficult]          : '); % Target contrast

Info.debug                   	= 'yes' ; % if yes: you open smaller window (for debugging)
Info.MotorResponse            	= 'no'; % if no: you disable bitsi responses (for debugging)

switch Info.runtype
    case 'block'
        Info.track            	= 'n'; %input('Launch eye-tracking  [y/n]     : ','s'); % launch eye_tracking
        if strcmp(Info.track,'y')
            Info.tracknumber  	= input('tracking session number       	: ','s'); % keep tracking of how many training sessions
            Info.eyefile      	= [Info.name(4:end) '00' Info.tracknumber];
        end
        Info.blocklength       	= 64;
        
    case 'train'
        Info.runnumber       	= '1'; % input('training session number      	: ','s'); % keep tracking of how many training sessions
        Info.track           	= 'n';
        Info.blocklength     	= 16;
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

% = % Load In / Create Targets beforehand to save time
[AllStim,AllMask]      	= taco_CreateAllTargets;

% = % Loop Through Trials

if strcmp(Info.debug,'no')
    HideCursor;
end

if IsLinux
    scr.b.clearResponses;
end

% just in case during one of the blocks , an error happened and the
% experiment needed to be restarded : this script will make sure to restart
% from the block with the missing trials
strt                                    = taco_check_start(Info);

for ntrial = strt:height(Info.TrialInfo)
    
    ix                                  = ntrial;
    nw_b_flg                            = h_chk_if_new_block(Info,ix);
    
    fprintf('\nTrial no %3d \n\n',ix);
    
    if nw_b_flg == 1
        %         if ~strcmp(Info.runtype,'train')
        %             taco_headlocaliserbreak;
        %         end
        taco_BlockStart;
    end
    
    if IsLinux
        scr.b.clearResponses;
    end
    
    %% fixed parameters
    CueInfo.dur                     	= stim.dur.cue;
    CueInfo.type                        = 2; %Info.TrialInfo(ix,:).cue;
    CueInfo.attend                      = 2; %Info.TrialInfo(ix,:).attend;
    
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
    stim.order                        	= 1;
    stim.code                          	= 10 + Info.TrialInfo(ix,:).samp1Class;
    stim.t_offset                       = tcue3;
    stim.t_wait                         = (stim.dur.ISI-CueInfo.dur);
    [t1,t2,t3]                        	= taco_drawstim(AllStim{ntrial,stim.order},AllMask{ntrial,stim.order});
    
    Info.TrialInfo.trigtime{ix}         = [Info.TrialInfo.trigtime{ix};tcue1;tcue2;tcue3;t1;t2;t3];
        
    %% Draw 2nd sample
    stim.order                       	= 2;
    stim.code                          	= 20 + Info.TrialInfo(ix,:).samp2Class;
    stim.t_offset                       = t3;
    stim.t_wait                         = stim.dur.ISI-stim.dur.target-stim.dur.mask;
    [t1,t2,t3]                        	= taco_drawstim(AllStim{ntrial,stim.order},AllMask{ntrial,stim.order});
    
    Info.TrialInfo.trigtime{ix}      	= [Info.TrialInfo.trigtime{ix};t1;t2;t3]; 
    
    %% Draw the second cue    
    CueInfo.order                       = 2;
    CueInfo.t_wait                      = stim.dur.ISI-stim.dur.target-stim.dur.mask;
    CueInfo.t_offset                    = t3;
    CueInfo.code                        = (CueInfo.order*100) + (CueInfo.type*10) + (CueInfo.attend);
    [tcue1,tcue2,tcue3]               	= taco_drawcue(CueInfo);
    
    Info.TrialInfo.trigtime{ix}       	= [Info.TrialInfo.trigtime{ix};tcue1;tcue2;tcue3;t1;t2;t3]; clear tcue1 tcue2 t1 t2 t3
    
    %% Draw probe
    stim.order                       	= 3;
    stim.code                          	= 30 + Info.TrialInfo(ix,:).samp2Class;
    stim.t_offset                       = tcue3;
    stim.t_wait                         = (Info.TrialInfo(ix,:).crit_soa - CueInfo.dur);
    [t1,t2,t3]                        	= taco_drawstim(AllStim{ntrial,stim.order},AllMask{ntrial,stim.order});
    
    Info.TrialInfo.trigtime{ix}      	= [Info.TrialInfo.trigtime{ix};t1;t2;t3];
    
    %% Get Response
    if strcmp(Info.MotorResponse,'yes')
        ctl.t_offset                    = t3; clear t1 t2 t3
        ctl.t_wait                      = stim.dur.ISI-stim.dur.target-stim.dur.mask;
        [repRT,repButton,repCorrect]  	= taco_getResponse;
    else
        repRT                         	= 50;
        repButton                      	= 51;
        repCorrect                    	= 52;
    end
    
    Info.TrialInfo.repRT{ix}          	= repRT;
    Info.TrialInfo.repButton{ix}       	= repButton;
    Info.TrialInfo.repCorrect{ix}     	= repCorrect;
    ctl.correct                       	= repCorrect; % to display the feedback :)
    
    clear repRT repButton repCorrect
    
    % = % End Trial
    tfin                             	= taco_endTrial;
    
    if IsLinux
        scr.b.clearResponses;
    end
    
    % this will end block and save the block information ;
    % after each block it will do that in the background just in case an
    % error occurs.
    
    if strcmp(Info.runtype,'train') && ntrial == height(Info.TrialInfo)
        taco_BlockEnd(1:Info.blocklength);
        save(Info.logfilename,'Info','-v7.3');
    else
        if Info.TrialInfo(ix,:).nbloc ~= Info.TrialInfo(ix+1,:).nbloc
            taco_BlockEnd(ntrial - Info.blocklength-1 : ntrial);
            save(Info.logfilename,'Info','-v7.3');
        end
    end
    
    if IsLinux
        scr.b.clearResponses;
    end
    
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