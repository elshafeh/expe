function trial_structure = h_assignmapping(trial_structure)

vct = [[trial_structure.cue]' [trial_structure.attend]' [trial_structure.ismatch]'];

for ncue = [1 2]
    for natt = [1 2]
        for nmat = [0 1]
            
            flg = find(vct(:,1) == ncue & vct(:,2) == natt & vct(:,3) == nmat);
            flg = flg(randperm(length(flg)));
            
            for nt = 1:length(flg)
                
                if mod(nt,2) == 0
                    trial_structure(flg(nt)).mapping  	= 1;
                else
                    trial_structure(flg(nt)).mapping  	= 2;
                end
                
            end
            
            clear nt flg
            
        end
    end
end

