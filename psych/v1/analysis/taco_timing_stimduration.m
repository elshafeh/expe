function taco_timing_stimduration

global info

figure;
suj_list          	= info.suj_list;

nrow              	= length(suj_list);
ncol              	= 8;
i                	= 0;

for nsuj = 1:length(suj_list)
    
    % load log file
    subjectname   	= suj_list{nsuj};
    filename      	= ['../Logfiles/' subjectname '/' subjectname '_taco_block_Logfile.mat'];
    fprintf('loading %s\n',filename);
    load(filename);
    
    Info         	= taco_cleaninfo(Info); % remove empty trials
    Info          	= taco_fixlog(subjectname,Info);  % fix subjects
    
    blocinfo     	= Info.TrialInfo;
    
    cue_duration  	= [];
    gab_duration   	= [];
    mask_duration  	= [];
    
    for nt = 1:height(blocinfo)
        
        % c c c g g g g g g c  c  c  g  g  g
        % 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
        trialtiming         = cell2mat(blocinfo(nt,:).trigtime);
        cue_duration        = [cue_duration; trialtiming(3)-trialtiming(2) trialtiming(12)-trialtiming(11)];
        gab_duration        = [gab_duration; trialtiming(5)-trialtiming(4) trialtiming(8)-trialtiming(7) trialtiming(14)-trialtiming(13)];
        mask_duration       = [mask_duration; trialtiming(6)-trialtiming(5) trialtiming(9)-trialtiming(8) trialtiming(15)-trialtiming(14)];
        
    end
    
    for ncue = 1:2
        i = i + 1;
        subplot(nrow,ncol,i)
        histogram(cue_duration(:,ncue)*1000,'BinWidth',0.5);
        xlabel('Time (ms)');
        title(['Cue ' num2str(ncue) 'onset-offset - ' subjectname]);
        xlim([295 305]);
        ylim([0 50]);
    end
    
    for ngab = 1:3
        i = i + 1;
        subplot(nrow,ncol,i)
        histogram(gab_duration(:,ngab)*1000,'BinWidth',0.5);
        xlabel('Time (ms)');
        title(['Gab ' num2str(ngab) 'onset-offset - ' subjectname]);
        xlim([95 105]);
        ylim([0 50]);
    end
    
    for nmask = 1:3
        i = i + 1;
        subplot(nrow,ncol,i)
        histogram(mask_duration(:,nmask)*1000,'BinWidth',0.5);
        xlabel('Time (ms)');
        title(['Mask ' num2str(nmask) 'onset-offset - ' subjectname]);
        xlim([95 105]);
        ylim([0 50]);
    end
    
end

clc;