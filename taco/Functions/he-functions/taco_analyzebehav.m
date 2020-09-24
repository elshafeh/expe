function taco_analyzebehav(data)

list_cue    = {'pre','rtr'};
list_task   = {'1st','2nd'};

for ncue = 1:2
    for ntask = 1:2
        
        ix      = data(data.cue == ncue & data.attend == ntask,:); 
        a       = cell2mat(ix.repCorrect);
        corr    = sum(a) ./ length(a);
        
        fprintf('%3s %3s: %.2f\n',list_cue{ncue},list_task{ntask},corr*100)
        
    end
end