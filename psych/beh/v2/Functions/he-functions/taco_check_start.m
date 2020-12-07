function strt = taco_check_start(Info)

i = 0;
for nb = 1:10
    for nt = 1:Info.blocklength
        i                       = i + 1;
        nbloc_vector(nt,nb)     = i;
    end
end
clear i nb nt 

strt                = 1;

for nt = 1:height(Info.TrialInfo)
    chk             = cell2mat(Info.TrialInfo(nt,:).repRT);
    if isempty(chk)
        [x strt]  	= find(nbloc_vector == nt);
    end
end