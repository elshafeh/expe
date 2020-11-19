clear ; clc ; addpath(genpath('/dycog/Aurelie/DATA/MEG/fieldtrip-20151124/'));

[~,suj_list,~]      = xlsread('../documents/PrepAtt22_PreProcessingIndex.xlsx','B:B');
suj_list            = suj_list(2:22);

clearvars -except suj_list

for sb = 1:length(suj_list)
    
    suj             = suj_list{sb};
    
    list_time       = {'m200m0','p0p200','p200p400','p400p600','p600p800','p800p1000','p1000p1200'};
    list_lo_freq    = {'8t16Hz'};
    list_hi_freq    = {'60t100Hz'};
    list_cnd_cue    = {'RCnD','LCnD','NCnD'};
    ext_bsl         = 'm400m200';
    
    for ncue = 1:length(list_cnd_cue)
        for nhigh = 1:length(list_hi_freq)
            for nlow = 1:length(list_lo_freq)
                
                ext_source      = '.OriginalPCCHanningMinEvoked0.5cm.mat';
                fname           = ['../data/' suj '/field/' suj '.' list_cnd_cue{ncue} '.' ext_bsl '.' list_lo_freq{nlow} 'and' list_hi_freq{nhigh} ext_source];
                fprintf('Loading %s\n',fname)
                load(fname);
                
                source_bsl      = source_MI ; clear source_MI ;
                
                for ntime = 1:length(list_time)
                    
                    fname           = ['../data/' suj '/field/' suj '.' list_cnd_cue{ncue} '.' list_time{ntime} '.' list_lo_freq{nlow} 'and' list_hi_freq{nhigh} ext_source];
                    
                    fprintf('Loading %s\n',fname)
                    load(fname);
                    
                    source_act                                  = source_MI ; clear source_MI ;
                    
                    pow                                         = (source_act.pow - source_bsl.pow) ./ source_bsl.pow ;
                   
                    source_avg{sb,ncue,nhigh,nlow,ntime}        = source_act;
                    source_avg{sb,ncue,nhigh,nlow,ntime}.pow    = pow;
                    
                    clear source_act
                    
                end
            end
        end
    end
end

clearvars -except suj_list list* source_avg

list_test   = [1 2; 1 3; 2 3];

for ncue = 1:length(list_test)
    for nhigh = 1:length(list_hi_freq)
        for nlow = 1:length(list_lo_freq)
            for ntime = 1:length(list_time)
                
                cfg                                =   [];
                cfg.dim                            =   source_avg{1}.dim;
                cfg.method                         =   'montecarlo';
                cfg.statistic                      =   'depsamplesT';
                cfg.parameter                      =   'pow';
                
                cfg.correctm                       =   'fdr';
                
                cfg.clusteralpha                   =   0.05;
                
                cfg.clusterstatistic               =   'maxsum';
                cfg.numrandomization               =   1000;
                cfg.alpha                          =   0.025;
                cfg.tail                           =   0;
                cfg.clustertail                    =   0;
                
                nsuj                               =   length([source_avg{:,ncue,nhigh,nlow,1}]);
                cfg.design(1,:)                    =   [1:nsuj 1:nsuj];
                cfg.design(2,:)                    =   [ones(1,nsuj) ones(1,nsuj)*2];
                
                cfg.uvar                           =   1;
                cfg.ivar                           =   2;
                stat{ncue,nhigh,nlow,ntime}        =   ft_sourcestatistics(cfg,source_avg{:,list_test(ncue,1),nhigh,nlow,ntime},source_avg{:,list_test(ncue,2),nhigh,nlow,ntime});
                
            end
        end
    end
end

clearvars -except suj_list list* source_avg stat ;

for ncue = 1:length(list_cnd_cue)
    for nhigh = 1:length(list_hi_freq)
        for nlow = 1:length(list_lo_freq)
            for ntime = 1:length(list_time)
                
                [min_p(ncue,nhigh,nlow,ntime) , p_val{ncue,nhigh,nlow,ntime}] = h_pValSort(stat{ncue,nhigh,nlow,ntime});
                
            end
        end
    end
end

clearvars -except suj_list list* source_avg stat min_p p_val ;

p_limit                                 = 0.05;

list_test                               = {'RmL','RmN','LmN'};

for ncue = 3 %:length(list_cnd_cue)
    for nhigh = 1:length(list_hi_freq)
        for nlow = 1:length(list_lo_freq)
            for ntime = 1:length(list_time)
                
                if min_p(ncue,nhigh,nlow,ntime) < p_limit
                    
                    for iside = [1 2]
                        
                        lst_side                                    = {'left','right','both'};
                        lst_view                                    = [-95 1;95 1;0 50];
                        
                        z_lim                                       = 5;
                        
                        clear source ;
                        
                        stat_to_plot                                = stat{ncue,nhigh,nlow,ntime};
                        stat_to_plot.mask                           = stat_to_plot.prob < p_limit;
                        
                        source.pos                                  = stat_to_plot.pos ;
                        source.dim                                  = stat_to_plot.dim ;
                        tpower                                      = stat_to_plot.stat .* stat_to_plot.mask;
                        
                        tpower(tpower == 0)                         = NaN;
                        source.pow                                  = tpower ; clear tpower;
                        
                        cfg                                         =   [];
                        cfg.funcolormap                             = 'jet';
                        cfg.method                                  =   'surface';
                        cfg.funparameter                            =   'pow';
                        cfg.funcolorlim                             =   [-z_lim z_lim];
                        cfg.opacitylim                              =   [-z_lim z_lim];
                        cfg.opacitymap                              =   'rampup';
                        cfg.colorbar                                =   'off';
                        cfg.camlight                                =   'no';
                        cfg.projmethod                              =   'nearest';
                        cfg.surffile                                =   ['surface_white_' lst_side{iside} '.mat'];
                        cfg.surfinflated                            =   ['surface_inflated_' lst_side{iside} '_caret.mat'];
                        ft_sourceplot(cfg, source);
                        view(lst_view(iside,:))
                        
                        title([list_test{ncue} '.' list_time{ntime} '.' list_lo_freq{nlow} 'and' list_hi_freq{nhigh} ' ' num2str(min_p(ncue,nhigh,nlow,ntime))]);
                        
                    end
                end
            end
        end
    end
end