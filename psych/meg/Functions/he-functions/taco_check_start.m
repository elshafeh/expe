function strt = taco_check_start(Info)

strt                = 1;
tmp                 = [];

for nt = 1:height(Info.TrialInfo)
    chk             = cell2mat(Info.TrialInfo(nt,:).repRT);
    if isempty(chk)
        tmp         = [tmp;nt];
    end
end

if ~isempty(tmp)
    strt            = tmp(1);
end

% i = 0;
% for nb = 1:10
%     for nt = 1:Info.blocklength
%         i                       = i + 1;
%         nbloc_vector(nt,nb)     = i;
%     end
% end
% clear i nb nt
