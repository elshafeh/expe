clear ; clc ; addpath(genpath('/dycog/Aurelie/DATA/MEG/fieldtrip-20151124/'));

[~,allsuj,~]    = xlsread('../documents/PrepAtt22_Matching4Matlab.xlsx','A:B');

suj_group{1}    = allsuj(2:15,1);
suj_group{2}    = allsuj(2:15,2);

% [~,suj_group{1},~]  = xlsread('../documents/PrepAtt2_PreProcessingIndex.xlsx','B:B');
% suj_group{1}        = suj_group{1}(2:22);

lst_group       = {'old','young'};

for ngroup = 1:length(lst_group)
    
    suj_list = suj_group{ngroup};
    
    for sb = 1:length(suj_list)
        
        suj                     = suj_list{sb};
        cond_main               = 'CnD';
        
        ext_name1               = '1t20Hz';
        ext_name2               = 'NewHighAlphaAgeContrast.1t20Hz.m800p2000msCov.waveletPOW.1t19Hz.m3000p3000.KeepTrials';
        
        fname_in                = ['../data/' suj '/field/' suj '.' cond_main '.' ext_name2 '.mat'];
        
        fprintf('\nLoading %50s \n',fname_in);
        load(fname_in)
        
        if isfield(freq,'check_trialinfo')
            freq = rmfield(freq,'check_trialinfo');
        end
        
        list_ix_cue        = {2,1,0,0};
        list_ix_tar        = {[2 4],[1 3],[2 4],[1 3]};
        list_ix_dis        = {0,0,0,0};
        list_ix            = {'R','L','NR','NL'};
        
        load(['../data/' suj '/field/' suj '.CnD.AgeContrast80Slct.RLNRNL.mat']);
        
        for cnd = 1:length(list_ix_cue)
            
            cfg                         = [];
            cfg.trials                  = trial_array{cnd};% h_chooseTrial(freq,list_ix_cue{cnd},list_ix_dis{cnd},list_ix_tar{cnd}) ; 
            new_freq                    = ft_selectdata(cfg,freq);
            new_freq                    = ft_freqdescriptives([],new_freq);
            
            for nchan = 1:length(new_freq.label)
                allsuj_data{ngroup}{sb,cnd,nchan}            = new_freq;
                allsuj_data{ngroup}{sb,cnd,nchan}.powspctrm  = new_freq.powspctrm(nchan,:,:);
                allsuj_data{ngroup}{sb,cnd,nchan}.label      = new_freq.label(nchan);
            end
            
            clear new_freq cfg
            
        end
        
        for cnd =1:length(list_ix)
            for nchan = 1:size(allsuj_data{ngroup},3)
                
                cfg                                 = [];
                
                if strcmp(ext_name1,'20t50Hz')
                    cfg.baseline                        = [-0.4 -0.2];
                elseif strcmp(ext_name1,'1t20Hz')
                    cfg.baseline                        = [-0.6 -0.2];
                elseif strcmp(ext_name1,'50t120Hz')
                    cfg.baseline                        = [-0.2 -0.1];
                end
                
                cfg.baselinetype                    = 'relchange';
                allsuj_data{ngroup}{sb,cnd,nchan}   = ft_freqbaseline(cfg, allsuj_data{ngroup}{sb,cnd,nchan});
                
            end
        end
    end
end

%     big_freq{nf} = allsuj_data; clear allsuj_data ;
% end

clearvars -except allsuj_data big_freq

fOUT = '../documents/4R/NewAgeContrast_Alpha_AuditoryOccipital_80Slct_Modality_Hemisphere_FREQ_Divide.txt';
fid  = fopen(fOUT,'W+');
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','GROUP','SUB','CUE','CHAN','FREQ','TIME','POW','CUE_CAT','CUE_CONC','CUE_ORIG','MOD','HEMI','FREQ_CAT');

for ngroup = 1:length(allsuj_data)
    for sb = 1:size(allsuj_data{ngroup},1)
        for ncue = 1:size(allsuj_data{ngroup},2)
            for nchan = 1:size(allsuj_data{ngroup},3)
                
                frq_win  = 0;
                
                frq_list = 7:15;
                
                tim_wind = 0.1;
                
                tim_list = 0.5:tim_wind:1;
                
                for nfreq = 1:length(frq_list)
                    for ntime = 1:length(tim_list)
                        
                        ls_group            = {'old','young'};
                        
                        ls_cue              = {'R','L','R','L'};
                        ls_cue_cat          = {'informative','informative','uninformative','uninformative'};
                        ls_threewise        = {'RCue','LCue','NCue','NCue'};
                        original_cue_list   = {'R','L','NR','NL'};
                        
                        ls_chan  = allsuj_data{ngroup}{sb,ncue,nchan}.label;
                        
                        ls_time  = [num2str(tim_list(ntime)*1000) 'ms'];
                        
                        ls_freq  = [num2str(frq_list(nfreq)) 'Hz'];
                        
                        name_chan =  ls_chan{:};
                        
                        if strcmp(name_chan(1),'H') || strcmp(name_chan(1),'T')
                            chan_mod = 'Auditory';
                        else
                            chan_mod = 'Occipital';
                        end
                            
                        if frq_list(nfreq) < 11
                            freq_cat = 'high_cat';
                        elseif frq_list(nfreq) > 11
                            freq_cat = 'high_freq';
                        else
                            freq_cat = 'eleven';
                        end
                        
                        chn_prts = strsplit(name_chan,'_');
                        
                        x1       = find(round(allsuj_data{ngroup}{sb,ncue,nchan}.time,2)== round(tim_list(ntime),2));
                        x2       = find(round(allsuj_data{ngroup}{sb,ncue,nchan}.time,2)== round(tim_list(ntime)+tim_wind,2));
                        
                        y1       = find(round(allsuj_data{ngroup}{sb,ncue,nchan}.freq)== round(frq_list(nfreq)));
                        y2       = find(round(allsuj_data{ngroup}{sb,ncue,nchan}.freq)== round(frq_list(nfreq)+frq_win));
                        
                        if isempty(x1) || isempty(x2) || isempty(y1) || isempty(y2)
                            error('ahhhh')
                        else
                            pow      = mean(allsuj_data{ngroup}{sb,ncue,nchan}.powspctrm(1,y1:y2,x1:x2),3);
                            pow      = squeeze(mean(pow,2));
                            
                            if size(pow,1) > 1 || size(pow,2) > 1
                                error('oohhhhhhh')
                            else
                                
                                fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%.2f\t%s\t%s\t%s\t%s\t%s\t%s\n',ls_group{ngroup},[ls_group{ngroup} num2str(sb)],ls_cue{ncue},ls_chan{:},ls_freq,ls_time,pow,ls_cue_cat{ncue},original_cue_list{ncue},ls_threewise{ncue},chan_mod,chn_prts{end},freq_cat);
                                
                            end
                            
                        end
                    end
                end
            end
        end
    end
end

fclose(fid);

% save('../data_fieldtrip/grand_average/OldYoung_RLNRNL_virtual_auditory_alpha_beta_gamma.mat','allsuj_data','-v7.3');
%
% for ngroup = 1:length(big_freq{1})
%     for sb = 1:size(big_freq{1}{1},1)
%         for cnd = 1:size(big_freq{1}{1},2)
%             for nchan = 1:size(big_freq{1}{1},3)
%
%                 cfg             = [];
%                 cfg.parameter   = 'powspctrm';
%                 cfg.appendim    = 'freq';
%
%                 allsuj_data{ngroup}{sb,cnd,nchan} = ft_appendfreq(cfg,big_freq{1}{ngroup}{sb,cnd,nchan}, ...
%                     big_freq{2}{ngroup}{sb,cnd,nchan}, ...
%                     big_freq{3}{ngroup}{sb,cnd,nchan}) ;
%
%             end
%         end
%     end
% end

% clearvars -except allsuj_data
%
% for ngroup = 1:length(allsuj_data)
%     for nchan = 1:size(allsuj_data{ngroup},3)
%
%         list_test = [1 3; 2 4; 1 2];
%
%         nsuj           = size(allsuj_data{ngroup},1);
%         [design,~]     = h_create_design_neighbours(nsuj,allsuj_data{ngroup}{1},'virt','t'); clc;
%
%         for ntest = 1:size(list_test,1)
%
%             cfg                     = [];
%             cfg.clusterstatistic    = 'maxsum';
%             cfg.method              = 'montecarlo';
%             cfg.statistic           = 'depsamplesT';
%             cfg.correctm            = 'cluster';
%             cfg.latency             = [-0.2 2];
%             cfg.frequency           = [7 14];
%             cfg.clusteralpha        = 0.05;
%             cfg.alpha               = 0.025;
%             cfg.minnbchan           = 0;
%             cfg.tail                = 0;
%             cfg.clustertail         = 0;
%             cfg.numrandomization    = 1000;
%             cfg.design              = design;
%             cfg.uvar                = 1;
%             cfg.ivar                = 2;
%
%             stat{ngroup,nchan,ntest}      = ft_freqstatistics(cfg, allsuj_data{ngroup}{:,list_test(ntest,1),nchan},allsuj_data{ngroup}{:,list_test(ntest,2),nchan});
%             stat{ngroup,nchan,ntest}      = rmfield(stat{ngroup,nchan,ntest},'cfg');
%
%             list_ix            = {'RvNR','LvNL','RvL'};
%
%             stat{ngroup,nchan,ntest}.label = {[allsuj_data{ngroup}{1,1,nchan}.label{1} '.' list_ix{ntest}]};
%
%         end
%     end
% end
%
% clearvars -except allsuj_data stat ; close all ;
%
% for ngroup = 1:size(stat,1)
%     for nchan = 1:size(stat,2)
%         for ntest = 1:size(stat,3)
%             [min_p(ngroup,nchan,ntest), p_val{ngroup,nchan,ntest}]          = h_pValSort(stat{ngroup,nchan,ntest}) ;
%         end
%     end
% end
%
% clearvars -except allsuj_data stat min_p p_val; close all ;
%
% for ngroup = 1:size(stat,1)
%
%     figure;
%     i = 0;
%
%     for nchan = 1:size(stat,2)
%         for ntest = 1:size(stat,3)
%
%             stoplot         = stat{ngroup,nchan,ntest};
%             stoplot.mask    = stoplot.prob < 0.11;
%             i               = i + 1;
%
%             subplot(size(stat,2),size(stat,3),i)
%
%             cfg                 = [];
%             cfg.parameter       = 'stat';
%             cfg.maskparameter   = 'mask';
%             cfg.maskstyle       = 'outline';
%             cfg.zlim            = [-5 5];
%             ft_singleplotTFR(cfg,stoplot);
%             colormap('jet')
%             vline(0,'--k');
%             vline(1.2,'--k');
%
%         end
%     end
% end