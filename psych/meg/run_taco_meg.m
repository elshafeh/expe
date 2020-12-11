%% Set Environment

tic; sca;clear;

addpath(genpath('Functions/'));

global wPtr scr stim ctl Info el useEyetrack

taco_sessioninfo;
taco_setParameters;
taco_start;

%% setup eyetracker
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
    useEyetrack             = 1;
end

%% Load In / Create Targets beforehand to save time
[AllStim]                   = taco_CreateAllTargets;

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
strt                                    = taco_check_start(Info);

for ntrial = strt:height(Info.TrialInfo)

    ix                                  = ntrial;
    nw_b_flg                            = h_chk_if_new_block(Info,ix);

    fprintf('Trial no %3d \n',ix);

    if nw_b_flg == 1
        h_emptybitsi;
        if ~strcmp(Info.runtype,'train')
            taco_headlocaliserbreak;
        end
        taco_BlockStart;
        h_emptybitsi;
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
        if exist('tfin','var')
            fprintf('previous cue offset found\n');
            CueInfo.t_offset          	= tfin; clear tfin;
        end
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
    stim.code                          	= 30 + Info.TrialInfo(ix,:).probeClass;
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
        if ntrial == height(Info.TrialInfo)
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

% make sure that performances are saved
save(Info.logfilename,'Info','-v7.3');

% to give idea on behavioral peformances
taco_analyzebehav(Info.TrialInfo);

%% run localizer

if strcmp(Info.runtype,'block')

    Info                    = rmfield(Info,'TrialInfo');
    Info.runtype            = 'loca';
    Info.blocklength        = 300;

    Info.logfilename        = [Info.logfolder filesep  Info.name '_taco_meg_' Info.runtype '.mat'];

    Info.TrialInfo          = loca_createAllTrials;
    [AllStim]            	= taco_CreateAllTargets;

    if strcmp(Info.debug,'no')
        h_emptybitsi;
    end

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


        fprintf('Trial no %3d \n',ix);

        stim.dur.ISI              	= Info.TrialInfo(ix,:).ISI(1);

        %         if Info.TrialInfo(ix,:).color == 1
        %             stim.patch.FixColor 	= scr.black;
        %         else
        %             stim.patch.FixColor 	= scr.white;
        %         end

        stim.patch.FixColor         = scr.gray/2;

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

end

%% end experiment and save data (including eye tracking)
if useEyetrack, rd_eyeLink('eyestop', wPtr, {Info.eyefile, Info.eyefolder}); end

sca;
ShowCursor;

clearvars -except Info;

toc;
