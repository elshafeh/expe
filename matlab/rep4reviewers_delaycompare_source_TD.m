clear ; clc ; addpath(genpath('../fieldtrip-20151124/')); close all ;

[~,suj_group{1},~]  = xlsread('../documents/PrepAtt22_PreProcessingIndex.xlsx','B:B');
suj_group{1}        = suj_group{1}(2:22);

load ../data/template/template_grid_0.5cm.mat ;

for ngroup = 1:length(suj_group)
    
    suj_list = suj_group{ngroup};
    
    for sb = 1:length(suj_list)
        
        suj                 = suj_list{sb};
        
        list_cond_main      = {'V','N','V1','N1','V2','N2'};
        
        list_freq           = {'60t100Hz'};
        list_time           = {'p100p300'};
        
        for ntime = 1:length(list_time)
            for nfreq = 1:length(list_freq)
                for ncue = 1:length(list_cond_main)
                    
                    % for paper
                    ext_comp                                                    = 'dpssFixedCommonDicSourceMinEvoked0.5cm.mat';
                    dir_data                                                    = '../data/dis_rep4rev/';
                    fname                                                       = [dir_data suj '.fDIS'  list_cond_main{ncue} '.' list_freq{nfreq} '.' list_time{ntime} '.' ext_comp];
                    
                    fprintf('Loading %50s\n',fname);
                    load(fname);
                    
                    bsl_source                                                  = source; clear source
                    
                    fname                                                       = [dir_data suj '.DIS'   list_cond_main{ncue} '.' list_freq{nfreq} '.' list_time{ntime}    '.' ext_comp];
                    fprintf('Loading %50s\n',fname);
                    load(fname);
                    
                    act_source                                                  = source; clear source ;
                    
                    pow                                                         = act_source; % act_source-bsl_source; % (act_source-bsl_source)./bsl_source; % act_source-bsl_source ; % act_source; %  % act_source; %
                    pow(isnan(pow))                                             = 0;
                    
                    source_avg{ngroup}{sb,ncue,ntime,nfreq}.pow                 = pow;
                    source_avg{ngroup}{sb,ncue,ntime,nfreq}.pos                 = template_grid.pos ;
                    source_avg{ngroup}{sb,ncue,ntime,nfreq}.dim                 = template_grid.dim ;
                    source_avg{ngroup}{sb,ncue,ntime,nfreq}.inside              = template_grid.inside;
                    
                    clear act_source bsl_source pow
                    
                end
            end
        end
    end
end

clearvars -except source_avg list*;

for ngroup = 1:length(source_avg)
    
    ix_test                                        =   [1 2; 3 4; 5 6];
    
    for ntest = 1:size(ix_test,1)
        for ntime = 1:length(list_time)
            for nfreq = 1:length(list_freq)
                
                cfg                                =   [];
                cfg.dim                            =   source_avg{1}{1}.dim;
                cfg.method                         =   'montecarlo';
                cfg.statistic                      =   'depsamplesT';
                cfg.parameter                      =   'pow';
                
                cfg.correctm                       =   'cluster';       % 'bonferroni' 'cluster';
                
                cfg.clusteralpha                   =   0.05;             % First Threshold
                cfg.clusterstatistic               =   'maxsum';
                
                cfg.numrandomization               =   1000;
                cfg.alpha                          =   0.025;
                cfg.tail                           =   0;
                cfg.clustertail                    =   0;
                
                nsuj                               =   size(source_avg{ngroup},1);
                
                cfg.design(1,:)                    =   [1:nsuj 1:nsuj];
                cfg.design(2,:)                    =   [ones(1,nsuj) ones(1,nsuj)*2];
                cfg.uvar                           =   1;
                cfg.ivar                           =   2;
                
                stat{ngroup,ntest,ntime,nfreq}     =   ft_sourcestatistics(cfg, source_avg{ngroup}{:,ix_test(ntest,1),ntime,nfreq},source_avg{ngroup}{:,ix_test(ntest,2),ntime,nfreq});
                stat{ngroup,ntest,ntime,nfreq}     =   rmfield(stat{ngroup,ntest,ntime,nfreq},'cfg');
                
                
                list_test{ntest}                   =   [list_cond_main{ix_test(ntest,1)} 'v' list_cond_main{ix_test(ntest,2)}];
                
                
            end
        end
    end
    
end

clearvars -except source_avg list* stat;

for ngroup = 1:size(stat,1)
    for ntest = 1:size(stat,2)
        for ntime = 1:size(stat,3)
            for nfreq = 1:size(stat,4)
                [min_p(ngroup,ntest,ntime,nfreq),p_val{ngroup,ntest,ntime,nfreq}]      = h_pValSort(stat{ngroup,ntest,ntime,nfreq});
            end
        end
    end
end

p_limit     = 0.07;

i = 0 ; close all;

for ngroup = 1:size(stat,1)
    for ntest = 1:size(stat,2)
        for ntime = 1:size(stat,3)
            for nfreq = 1:size(stat,4)
                if min_p(ngroup,ntest,ntime,nfreq) < p_limit
                    
                    for iside = 1
                        
                        
                        lst_side                      = {'left','right','left','right'};
                        
                        
                        lst_view                      = [-119 6]; % [-95 1;95 1;0 50]; % [-128 11;128 11;-89 5; 89 5];
                        
                        z_lim                         = 3; clear source ;
                        
                        s2plot                        = stat{ngroup,ntest,ntime,nfreq};
                        
                        s2plot.mask                   = s2plot.prob < p_limit;
                        
                        source.pos                    = s2plot.pos ;
                        source.dim                    = s2plot.dim ;
                        tpower                        = s2plot.stat .* s2plot.mask;
                        
                        tpower(tpower == 0)           = NaN;
                        
                        source.pow                    = tpower ; clear tpower;
                        
                        cfg                           =   [];
                        cfg.method                    =   'surface';
                        cfg.funparameter              =   'pow';
                        cfg.funcolorlim               =   [-z_lim z_lim];
                        cfg.opacitylim                =   [-z_lim z_lim];
                        cfg.opacitymap                =   'rampup';
                        cfg.colorbar                  =   'off';
                        cfg.camlight                  =   'no';
                        cfg.projmethod                =   'nearest';
                        cfg.surffile                  =   ['surface_white_' lst_side{iside} '.mat'];
                        cfg.surfinflated              =   ['surface_inflated_' lst_side{iside} '_caret.mat'];
                        
                        ft_sourceplot(cfg, source);
                        
                        view(lst_view(iside,:));
                        
                        title([list_test{ntest} ' ' num2str(min_p(ngroup,ntest,ntime,nfreq))])
                        
                    end
                end
            end
        end
    end
end