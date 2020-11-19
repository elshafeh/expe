clear ; clc ;

suj  ='yc1' ;

cond = 'RCnD' ;

for prt = 1:3
    
    load(['../data/' suj '/source/' suj '.pt' num2str(prt) '.' cond '.tfResolved.5t15Hz.m700p2000ms.mat']);
    
    bsl = squeeze(nanmean(tResolvedAvg.pow(:,:,2:6),3));
    bsl = repmat(bsl,1,1,size(tResolvedAvg.pow,3));
    
    tconcat{prt} = (tResolvedAvg.pow - bsl) ./ bsl ;
    
    %     tconcat{prt} = tResolvedAvg.pow;
    
end

tm_list = tResolvedAvg.time ;
fq_list = tResolvedAvg.freq ;

clearvars -except tconcat tm_list fq_list

tResolvedAvg = cat(4,tconcat{:}); 
tResolvedAvg = squeeze(nanmean(tResolvedAvg,4)); clear tconcat ;

for fq = 6:3:15
    
    for t = 0.6
        
        x = find(fq_list == fq);
        y = find(round(tm_list,2) == round(t,2));
        z = y ;
        %         z = find(round(tm_list,2) == round(t+0.2,2));
        
        load  ../data/template/source_struct_template_MNIpos.mat
        
        s2plot.pow = squeeze(nanmean(tResolvedAvg(:,x,y:z),3));
        s2plot.pos = source.pos ;
        s2plot.dim = source.dim ;
        
        inter = h_interpolate(s2plot);
        
        cfg                     = [];
        cfg.method              = 'slice';
        cfg.funparameter        = 'pow';
        cfg.nslices             = 16;
        cfg.slicerange          = [70 84];
        cfg.funcolorlim         = [-1 1];
        ft_sourceplot(cfg,inter);clc;
       
        clear source inter s2plot
        
    end
    
end