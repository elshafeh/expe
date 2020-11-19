clear;clc;
addpath('../toolbox/sigstar-master/');

load ../data/bil_goodsubjectlist.27feb20.mat

for nsuj = 1:length(suj_list)
    
    subjectName                     = suj_list{nsuj};
    
    frequency_list                  = {'theta' 'alpha' 'beta' 'gamma'};
    decoding_list                   = {'frequency' 'orientation'};
    
    for nfreq = 1:length(frequency_list)
        
        data                      	= [];
        
        for ndeco = 1:length(decoding_list)
            fname               	= ['F:/bil/decode/' subjectName '.2ndgab.lock.' frequency_list{nfreq} ...
                '.centered.decodinggabor.' decoding_list{ndeco}  '.correct.timegen.mat'];
            fprintf('loading %s\n',fname);
            load(fname);
            data(ndeco,:,:)      	= scores; clear scores;
        end
        
        data(data<0.5)                  = 0.5;
        
        freq                            = [];
        freq.powspctrm              	= data; clear tmp data;
        freq.time                       = time_axis;
        freq.freq                       = time_axis;
        freq.label                      = decoding_list;
        freq.dimord                  	= 'chan_freq_time';
        alldata{nsuj,nfreq}             = freq; clear avg;
        
    end
    
end

keep alldata *_list lock_focus

list_test                                = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];
i                                        = 0;

for ntest = 1:size(list_test,1)
    
    cfg                                  = [];
    cfg.statistic                        = 'ft_statfun_depsamplesT';
    cfg.method                           = 'montecarlo';
    cfg.correctm                         = 'cluster';
    cfg.clusteralpha                     = 0.05;
    
    cfg.latency                          = [-0.5 2];
    cfg.frequency                        = cfg.latency;
    
    cfg.clusterstatistic                 = 'maxsum';
    cfg.minnbchan                        = 0;
    cfg.tail                             = 0;
    cfg.clustertail                      = 0;
    cfg.alpha                            = 0.025;
    cfg.numrandomization                 = 1000;
    cfg.uvar                             = 1;
    cfg.ivar                             = 2;
    
    nbsuj                                = size(alldata,1);
    [design,neighbours]                  = h_create_design_neighbours(nbsuj,alldata{1,1},'gfp','t');
    
    cfg.design                           = design;
    cfg.neighbours                       = neighbours;
    
    stat{ntest}                          = ft_freqstatistics(cfg, alldata{:,list_test(ntest,1)}, alldata{:,list_test(ntest,2)});
    list_test_name{ntest}                = [frequency_list{list_test(ntest,1)} ' v ' frequency_list{list_test(ntest,2)}];
    [min_p(ntest),p_val{ntest}]         = h_pValSort(stat{ntest});
end

keep alldata *list* stat min_p p_val

i                                         	= 0;
nrow                                    	= 3;
ncol                                     	= 4;

plimit                                      = 0.1;

for ntest = 1:length(stat)
    for nchan = 1:length(stat{ntest}.label)

        stat{ntest}.mask                    = stat{ntest}.prob < plimit;
        
        tmp                               	= stat{ntest}.mask(nchan,:,:) .* stat{ntest}.stat(nchan,:,:);
        ix                                	= unique(tmp);
        ix                                	= ix(ix~=0);
        
        if ~isempty(ix)
            
            i                           	= i + 1;
            
            cfg                          	= [];
            cfg.colormap                	= brewermap(256, '*RdBu');
            cfg.channel                 	= nchan;
            cfg.parameter               	= 'stat';
            cfg.maskparameter             	= 'mask';
            cfg.maskstyle               	= 'outline';
            cfg.zlim                      	= [-10 10];
            cfg.colorbar                  	='yes';
            
            nme                           	= stat{ntest}.label{nchan};
            
            subplot(nrow,ncol,i)
            ft_singleplotTFR(cfg,stat{ntest});
            
            title({[list_test_name{ntest} ' p = ' num2str(round(min_p(ntest),3))],stat{ntest}.label{nchan}});
            
            c = colorbar;
            c.Ticks = cfg.zlim;
            
            %             ylabel('Training Time');
            %             xlabel('Testing Time');
            
            ylim(stat{ntest}.time([1 end]));
            xlim(stat{ntest}.time([1 end]));
            
            xticks([0 0.5 1 1.5 2]);
            yticks([0 0.5 1 1.5 2]);
            
            xticklabels({'g Onset' '0.5' '1' '1.5' '2'});
            yticklabels({'g Onset' '0.5' '1' '1.5' '2'});

            vline(0,'--k');
            hline(0,'--k');
            
            set(gca,'FontSize',10,'FontName', 'Calibri','FontWeight','normal');
            
            
        end
    end
end