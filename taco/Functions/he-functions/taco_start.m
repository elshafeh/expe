function taco_start

global scr ctl Info

Info.logfolder          = ['Logfiles' filesep  Info.name];
if ~exist(Info.logfolder)
    mkdir(Info.logfolder);
end

if strcmp(Info.runtype,'block')
    fname_out           = [Info.logfolder filesep  Info.name '_taco_' Info.runtype];
else
    fname_out           = [Info.logfolder filesep  Info.name '_taco_' Info.runtype '_' Info.runnumber];
end

Info.logfilename        = [fname_out '_Logfile.mat'];

if strcmp(Info.track,'y')
    Info.eyefolder    	= ['EyeData' filesep  Info.name];
    mkdir(Info.eyefolder);
end

scr.Pausetext           = 'Follow The Instructions After Each Trial \n\nPlease Fixate To The Center of The Screen\n\n\nPress Any Key To Continue';

% -- open bisti up
if IsLinux
    try
        scr.b   = Bitsi('/dev/ttyS0');
    catch
        fclose(instrfind);
        scr.b   = Bitsi('/dev/ttyS0');
    end
end

% Create Trials array
% if a sudden exit has occured ; this load the previous one before the
% crash and build up on

if exist(Info.logfilename)
    tmp                	= load(Info.logfilename);
    Info.TrialInfo     	= tmp.Info.TrialInfo; clear tmp;
else
    Info.TrialInfo     	= taco_CreateAllTrials;
end

Info.resp_map{1}       	= [1 1;2 0];
Info.resp_map{2}       	= [1 0;2 1];