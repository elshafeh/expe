function Info = taco_fixlog(subjectname,Info)

if strcmp(subjectname,'p004') || strcmp(subjectname,'p005')
    % change fix-jit to jittered
    flg                   	= find(strcmp([Info.TrialInfo.bloctype],'fixed-jittered'));
    for nt = 1:length(flg)
        Info.TrialInfo(flg(nt),:).bloctype   = {'jitterd'};
    end
    
    flg                   	= find(strcmp([Info.TrialInfo.bloctype],'fixed-fixed'));
    for nt = 1:length(flg)
        Info.TrialInfo(flg(nt),:).bloctype   = {'fixed-jittered'};
    end
    
elseif strcmp(subjectname,'p006')
    % change fix-jit to jittered
    flg                   	= find(strcmp([Info.TrialInfo.bloctype],'jitterd'));
    for nt = 1:length(flg)
        Info.TrialInfo(flg(nt),:).bloctype   = {'jitterd-jitterd'};
    end
    
    flg                   	= find(strcmp([Info.TrialInfo.bloctype],'fixed-fixed'));
    for nt = 1:length(flg)
        Info.TrialInfo(flg(nt),:).bloctype   = {'jitterd'};
    end
    
    flg                   	= find(strcmp([Info.TrialInfo.bloctype],'jitterd-jitterd'));
    for nt = 1:length(flg)
        Info.TrialInfo(flg(nt),:).bloctype   = {'fixed-fixed'};
    end
else
    Info = Info;
end