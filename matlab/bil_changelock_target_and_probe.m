function bil_changelock_target_and_probe(subjectName)

if isunix
    subject_folder = ['/project/3015079.01/data/' subjectName '/preproc/']; 
else
    subject_folder = ['P:/3015079.01/data/' subjectName '/preproc/'];
end

chk                                         = dir([subject_folder  subjectName '_gratinglock_dwnsample100Hz.mat']);

if isempty(chk)
    
    % load original data
    fname                                   = [subject_folder subjectName '_firstCueLock_ICAlean_finalrej.mat'];
    fprintf('\nloading %s\n',fname);
    load(fname);
    
    trial_struct                            = bil_CutEventsIntoTrials(subjectName);
    
    if strcmp(subjectName,'sub004') % some triggers were missing for these trials
        cfg                                 = [];
        cfg.trials                          = [1:380 383:length(dataPostICA_clean.trial)];
        dataPostICA_clean                   = ft_selectdata(cfg,dataPostICA_clean);
    elseif strcmp(subjectName,'sub023') % one trigger was missing for these trials
        cfg                                 = [];
        cfg.trials                          = [1:280 282:length(dataPostICA_clean.trial)];
        dataPostICA_clean                   = ft_selectdata(cfg,dataPostICA_clean);
    end
    
    trial_struct                            = trial_struct(dataPostICA_clean.trialinfo(:,18),:);
    
    % make sure that trials are matching across the board
    fnd                                     = dataPostICA_clean.trialinfo(:,1) - [trial_struct.first_cue_code];
    chk                                     = unique(fnd);
    
    if length(chk) > 1
        error('something wrong..');
    end
    
    [offset,code]                       	= h_adjustrial(dataPostICA_clean,trial_struct);
    
    cfg                                     = [];
    cfg.window                              = 1;
    
    cfg.begsample                           = offset.target;
    newdata{1}                              = h_redefinetrial(cfg,dataPostICA_clean);
    newdata{1}.trialinfo                    = [newdata{1}.trialinfo repmat(1,length(newdata{1}.trialinfo),1) code.target];
    
    cfg.begsample                           = offset.probe;
    newdata{2}                              = h_redefinetrial(cfg,dataPostICA_clean);
    newdata{2}.trialinfo                    = [newdata{2}.trialinfo repmat(2,length(newdata{2}.trialinfo),1) code.probe];
    
    newdata{3}                              = ft_appenddata([],newdata{:});
    
    for nd = 3 %1:length(newdata)
        
        data                                = newdata{nd};
        
        cfg                                 = [];
        cfg.resamplefs                      = 100;
        cfg.detrend                         = 'no';
        cfg.demean                          = 'yes';
        data                                = ft_resampledata(cfg, data);
        data                                = rmfield(data,'cfg');
        
        list_name                           = {'targetlock','probelock','gratinglock'};
        
        fname                               = [subject_folder subjectName '_' list_name{nd} '_dwnsample100Hz.mat'];
        fprintf('Saving %s\n',fname);
        tic;save(fname,'data','-v7.3');toc;
        
        index                               = data.trialinfo;
        fname                               = [subject_folder subjectName '_' list_name{nd} '_trialinfo.mat'];
        fprintf('Saving %s\n',fname);
        tic;save(fname,'index');toc;
        
    end
    
    clear newdata;
    
end