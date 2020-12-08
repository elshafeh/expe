function taco_sessioninfo

global Info

subject_prefix                  = 'sub';

clc;fprintf('\n');
isnew                           = input('Start a new session?    [y/n]    : ','s');
prev_sub                        = length(dir(['Logfiles/' subject_prefix '*']));

switch isnew
    case 'y'
        
        nw_numb                 = prev_sub+1;
        if nw_numb < 10
            Info.name           = [subject_prefix '00' num2str(nw_numb)];
        elseif nw_numb > 10
            Info.name           = [subject_prefix '0' num2str(nw_numb)];
        end
        
        Info.runtype            = 'train';
        Info.difficulty         = 1;
        

    case 'n'
        
        nw_numb                 = prev_sub;
        if nw_numb < 10
            Info.name           = [subject_prefix '00' num2str(nw_numb)];
        elseif nw_numb > 10
            Info.name           = [subject_prefix '0' num2str(nw_numb)];
        end
        
        runanswer               = input('Training or main block? [t/b]    : ','s');
        nb_train                = length(dir(['Logfiles/' Info.name '/' Info.name '_taco_meg_train_*_Logfile.mat']));
        tmp                     = load(['Logfiles/' Info.name '/' Info.name '_taco_meg_train_' num2str(nb_train) '_Logfile.mat']);
        difflevel               = tmp.Info.difficulty;
        accu                    = (sum(cell2mat(tmp.Info.TrialInfo.repCorrect)) ./ height(tmp.Info.TrialInfo)) * 100;
        fprintf('\n previous diff level was %.2f with %.2f accuracy\n\n',difflevel,accu);
        
        switch runanswer
            case 't'
                Info.runtype  	= 'train';
            case 'b'
                Info.runtype  	= 'block';
        end
        
        Info.difficulty       	= input('[1 - 20] [easy-difficult]        : '); % Target contrast

        
end


Info.gratingframes              = 6; % 1frame: 0.0167    6frame: 0.1000    7frame: 0.1167 8frame: 0.1333
Info.debug                      = 'no' ; % if yes: you open smaller window (for debugging)
Info.MotorResponse              = 'yes'; % if no: you disable bitsi responses (for debugging)

switch Info.runtype
    case 'block'
        Info.track              = input('Launch eye-tracking  [y/n]       : ','s'); % launch eye_tracking
        if strcmp(Info.track,'y')
            Info.tracknumber  	= input('tracking session number       	 : ','s'); % keep tracking of how many training sessions
            Info.eyefile        = [Info.name(4:end) '00' Info.tracknumber];
        end
        Info.blocklength        = 32;
        
    case 'train'
        Info.runnumber          = num2str(length(dir(['Logfiles' filesep Info.name filesep '*train*']))+1);
        Info.track              = 'n';
        Info.blocklength        = 16;
end