clear ; clc ; addpath(genpath('/dycog/Aurelie/DATA/MEG/fieldtrip-20151124/'));

[~,allsuj,~]    = xlsread('../documents/PrepAtt22_Matching4Matlab.xlsx','A:B');

suj_group{1}    = allsuj(2:15,1);
suj_group{2}    = allsuj(2:15,2);

lst_group       = {'Old','Young'};

for ngrp = 1:length(lst_group)
    
    suj_list = suj_group{ngrp};
    
    for sb = 1:length(suj_list)
        
        suj                     = suj_list{sb};
        cond_main               = 'CnD';
        list_cue               = {''};
        
        for ncue = 1:length(list_cue)
            
            fname_in                = ['../data/' suj '/field/' suj '.' list_cue{ncue} cond_main '.waveletPOW.10t60Hz.m1000p2000.10Mstep.AvgTrials.MinEvoked.mat'];
            
            fprintf('\nLoading %50s \n',fname_in);
            load(fname_in)
            
            if isfield(freq,'check_trialinfo')
                freq = rmfield(freq,'check_trialinfo');
            end
            
            cfg                         = [];
            cfg.baseline                = [-0.5 -0.2];
            cfg.baselinetype            = 'relchange';
            freq                        = ft_freqbaseline(cfg,freq);
            
            %             cfg                         = [];
            %             cfg.frequency               = [5 12];
            %             cfg.latency                 = [-0.2 2];
            %             freq                        = ft_selectdata(cfg,freq);
            %
            %             t_win                       = 0.1;
            %             freq                        = h_timeSmooth(freq,t_win);
            
            allsuj_data{ngrp}{sb,ncue}   = freq; clear freq ;
            
        end
        
    end
end

clearvars -except allsuj_data

for ngroup = 1:2
    for ncue = 1
        gavg{ngroup,ncue} = ft_freqgrandaverage([],allsuj_data{ngroup}{:,ncue});
    end
end

i = 0 ;

for ncue = 1:size(gavg,2)
    for ngroup = 1:size(gavg,1)
        
        i = i  + 1;
        
        subplot(2,2,i)
        cfg         = [];
        cfg.layout  = 'CTF275.lay';
        cfg.ylim    = [20 30];
        cfg.xlim    = [0.8 1.1];
        cfg.zlim    = [-0.3 0.3];
        cfg.marker  = 'off';
        ft_topoplotER(cfg,gavg{ngroup,ncue});
        
        i = i  + 1;
        
        subplot(2,2,i)
        cfg         = [];
        cfg.layout  = 'CTF275.lay';
        cfg.ylim    = [20 30];
        cfg.xlim    = [1.2 1.6]; 
        cfg.zlim    = [-0.3 0.3];
        cfg.marker  = 'off';
        ft_topoplotER(cfg,gavg{ngroup,ncue});
        
    end
end