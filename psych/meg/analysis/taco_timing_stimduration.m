function taco_timing_stimduration

global info

figure;
suj_list          	= info.suj_list;

if length(suj_list) == 1
    nrow = 2;
else
    nrow                       	= length(suj_list);
end

ncol              	= 5;
i                	= 0;

for nsuj = 1:length(suj_list)
    
    % load log file
    subjectname   	= suj_list{nsuj};
    filename      	= ['../Logfiles/' subjectname '/' subjectname '_taco_meg_block_Logfile.mat'];
    fprintf('loading %s\n',filename);
    load(filename);
    
    Info         	= taco_cleaninfo(Info); % remove empty trials
    
    blocinfo     	= Info.TrialInfo;
    
    cue_duration  	= [];
    gab_duration   	= [];
    
    for nt = 1:height(blocinfo)
        
        trialtiming         = cell2mat(blocinfo(nt,:).trigtime);
        
        % c c c g g g g c c c  g  g
        % 1 2 3 4 5 6 7 8 9 10 11 12
        cue_duration        = [cue_duration; trialtiming(3)-trialtiming(2) trialtiming(10)-trialtiming(9)];
        gab_duration        = [gab_duration; trialtiming(5)-trialtiming(4) trialtiming(7)-trialtiming(6) trialtiming(12)-trialtiming(11)];
        
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
    
    %     for nmask = 1:3
    %         i = i + 1;
    %         subplot(nrow,ncol,i)
    %         histogram(mask_duration(:,nmask)*1000,'BinWidth',0.5);
    %         xlabel('Time (ms)');
    %         title(['Mask ' num2str(nmask) 'onset-offset - ' subjectname]);
    %         xlim([95 105]);
    %         ylim([0 50]);
    %     end
    
end

clc;