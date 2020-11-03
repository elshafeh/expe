function Info = taco_cleaninfo(Info)

% cleans empty trials

chk                         = [];
for nt = 1:height(Info.TrialInfo)
    if ~isempty(cell2mat(Info.TrialInfo(nt,:).repRT))
        chk             	= [chk;nt];
    end
end

Info.TrialInfo              = Info.TrialInfo(chk,:); clear chk nt