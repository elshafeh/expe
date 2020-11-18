% = % Set Environment

sca;
clear ;

addpath(genpath('Functions/'));

global wPtr scr stim ctl Info el useEyetrack

Info.name                                   = input('Subject name                 	: ','s'); % example sub001
Info.runtype                                = input('Session (train, block or loca)  : ','s'); % training , main experiment or localizer
Info.difficulty                             = input('[1-4] [easy-difficult]          : '); % Target contrast

Info.debug                                  = 'yes' ; % if yes you open smaller window (for debugging)
Info.MotorResponse                          = 'yes'; % if no you disable bitsi responses (for debugging)

switch Info.runtype
    case 'block'
        
        Info.track                          = 'n'; %input('Launch eye-tracking  [y/n]     : ','s'); % launch eye_tracking
        if strcmp(Info.track,'y')
            Info.tracknumber              	= input('tracking session number       	: ','s'); % keep tracking of how many training sessions
            Info.eyefile                	= [Info.name(4:end) '00' Info.tracknumber];
        end
        Info.blocklength                    = 64;
        
    case 'train'
        
        Info.runnumber                     	= input('training session number      	: ','s'); % keep tracking of how many training sessions
        Info.track                         	= 'n';
        Info.blocklength                    = 16;
        
    case 'loca'
        Info.track                         	= 'n';
        Info.blocklength                    = 16;
        
end

taco_setParameters;
taco_start;

if strcmp(Info.track,'y')
    % = % Start Eyetracking
    [el,exitFlag]                           = rd_eyeLink('eyestart', wPtr, Info.eyefile);
    useEyetrack                             = 0;
    if exitFlag, return; end
    
    % = % Calibrate eye tracker
    [cal,exitFlag]                          = rd_eyeLink('calibrate', wPtr, el);
    if exitFlag, return; end
    
    % = % Start recording
    rd_eyeLink('startrecording',wPtr, el);
    useEyetrack                             = 1;
end

% = % Load In / Create Targets beforehand to save time
[AllStim,AllMask]                           = taco_CreateAllTargets;

% = % Loop Through Trials

if strcmp(Info.debug,'no')
    HideCursor;
end

ix                                          = 0;

if IsLinux
    scr.b.clearResponses;
end

% just in case during one of the blocks , an error happened and the
% experiment needed to be restarded : this script will make sure to restart
% from the block with the missing trials
strt                                        = taco_check_start(Info);

for ntrial = strt:height(Info.TrialInfo)
    
    ix                                      = ntrial;
    
    if ix > 1
        if Info.TrialInfo(ix,:).nbloc ~= Info.TrialInfo(ix-1,:).nbloc
            new_block_flag  	= 1;
        else
            new_block_flag	= 1;
        end
    else
        new_block_flag     	= 1;
    end
    
    fprintf('\nTrial no %3d \n\n',ix);
    
    % this to launch the block start instruction sheet
    % this will also launch a page where researcher will have the time to
    % ajust head positions
    
    if (ntrial == 1) || (new_block_flag == 1)
        bloc_number                         = Info.TrialInfo(ix,:).nbloc;
        %         if ~strcmp(Info.runtype,'train')
        %             taco_headlocaliserbreak;
        %         end
        taco_BlockStart;
    end
    
    if IsLinux
        scr.b.clearResponses;
    end
    
    % = define parameters
    stim.dur.target                         = round(Info.TrialInfo(ix,:).DurTar ./ scr.ifi) * scr.ifi;
    tmpSRMapping                            = Info.resp_map{Info.TrialInfo(ix,:).mapping}; % choose which mapping will be shown
    ctl.expectedRep                         = tmpSRMapping(tmpSRMapping(:,2) == Info.TrialInfo(ix,:).match,1);
    
    % = % Draw the first cue
    if ~strcmp(Info.runtype,'loca')
        
        CueInfo.CueOrder                   	= 1;
        CueInfo.CueType                     = Info.TrialInfo(ix,:).cue;
        CueInfo.CueDur                     	= round(Info.TrialInfo(ix,:).DurCue ./ scr.ifi) * scr.ifi;
        CueInfo.attend                      = Info.TrialInfo(ix,:).focus;
        
        if new_block_flag == 1
            CueInfo.time_before           	= Info.TrialInfo(ix,:).ITI;
        else
            CueInfo.time_before            	= Info.TrialInfo(ix,:).ITI;
            CueInfo.tfin                   	= tfin; clear tfin;
        end
        
        [tcue1,tcue2,tcue3]                	= taco_drawcue(CueInfo);
        CueInfo.tcue3                      	= tcue3;
        
        if isfield(CueInfo,'tfin')
            CueInfo                        	= rmfield(CueInfo,'tfin');
        end
    else
        CueInfo.tcue3                       = 0;
        CueInfo.CueDur                      = 0;
    end
    
    % = % Draw and Display first sample (same for main and loca)
    stim.order                              = 2;
    stim.patch.FixColor                     = stim.Fix.PossibColor{Info.TrialInfo(ix,:).color}; % this is fixed now
    stimCode                                = 100 + (10*Info.TrialInfo(ix,:).color) + Info.TrialInfo(ix,:).samp1Class;
    stim.dur.ISI                            = round(1.5 ./ scr.ifi) * scr.ifi;
    
    [t1,t2,t3]                              = taco_TrialFun(AllStim{ntrial,stim.order},AllMask{ntrial,stim.order},stimCode,CueInfo);
    
    if ~strcmp(Info.runtype,'loca')
        Info.TrialInfo.trigtime{ix}      	= [Info.TrialInfo.trigtime{ix};tcue1;tcue2;tcue3;t1;t2;t3];
    else
        Info.TrialInfo.trigtime{ix}      	= [Info.TrialInfo.trigtime{ix};t1;t2;t3];
    end
    
    clear tcue1 tcue2 tcue3 t1 t2
    
    % = % Draw Probe/Mask (for localizer) and 2nd sample for Main task
    if strcmp(Info.runtype,'loca')
        stimCode                          	= 200 + (10*Info.TrialInfo(ix,:).color) + Info.TrialInfo(ix,:).probeClass;
    else
        stimCode                          	= 200 + (10*Info.TrialInfo(ix,:).color) + Info.TrialInfo(ix,:).samp2Class;
    end
    
    CueInfo.tcue3                           = t3;
    CueInfo.CueDur                          = 0;
    [t1,t2,t3]                              = taco_TrialFun(AllStim{ntrial,stim.order},AllMask{ntrial,stim.order},stimCode,CueInfo);

    Info.TrialInfo.trigtime{ix}             = [Info.TrialInfo.trigtime{ix};t1;t2;t3];
    
    % = % Draw the second cue
    if ~strcmp(Info.runtype,'loca')
        CueInfo.time_before              	= stim.dur.ISI-stim.dur.target-stim.dur.mask;
        CueInfo.CueOrder                  	= 2;
        CueInfo.tfin                      	= t3;
        [tcue1,tcue2,tcue3]                	= taco_drawcue(CueInfo);
        CueInfo.tcue3                     	= tcue3;
        
        if isfield(CueInfo,'tfin')
            CueInfo                      	= rmfield(CueInfo,'tfin');
        end
    end
    
    clear tcue1 tcue2 tcue3 t1 t2 t3
    
    
    
    % = % Get Response
    if strcmp(Info.MotorResponse,'yes')
        [repRT,repButton,repCorrect]        = taco_getResponse;
    else
        repRT                               = 50;
        repButton                           = 51;
        repCorrect                          = 52;
    end
    
    Info.TrialInfo.PresTarg{ix}             = 'ni'; % TargetStim{nblock,ntrial};
    Info.TrialInfo.PresProb{ix}             = 'ni'; % ProbeStim{nblock,ntrial};
    Info.TrialInfo.PresMask{ix}             = 'ni'; % bMask{nblock,ntrial};
    
    Info.TrialInfo.repRT{ix}                = repRT;
    Info.TrialInfo.repButton{ix}            = repButton;
    Info.TrialInfo.repCorrect{ix}           = repCorrect;
    
    ctl.correct                             = repCorrect;
    
    % = % End Trial
    tfin                                    = taco_endTrial;
    
    if IsLinux
        scr.b.clearResponses;
    end
    
    findvector                              = 64:64:512;
    findix                                  = find(findvector == ntrial);
    
    % this will end block and save the block information ;
    % after each block it will do that in the background just in case an
    % error occurs.
    
    if strcmp(Info.runtype,'train') && ntrial == height(Info.TrialInfo)
        taco_BlockEnd(1:Info.blocklength);
        save(Info.logfilename,'Info','-v7.3');
    else
        if ix > 1
            if Info.TrialInfo(ix,:).nbloc ~= Info.TrialInfo(ix-1,:).nbloc
                taco_BlockEnd(ntrial - Info.blocklength-1 : ntrial);
                save(Info.logfilename,'Info','-v7.3');
            end
        end
    end
    
    if IsLinux
        scr.b.clearResponses;
    end
    
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