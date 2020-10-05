clear;

% load log file
subjectname             = 'test04';
filename                = ['../Logfiles/' subjectname '/' subjectname '_taco_block_Logfile.mat'];
load(filename);

i                       = 0;

for nbloc = 1:3
    
    flg                     = find(Info.TrialInfo.nbloc == nbloc);
    blocinfo                = Info.TrialInfo(flg,:);
    all_iti                 = [];
    
    for nt = 1:height(blocinfo)-1
        
        % c c c g g g g g g c  c  c  g  g  g
        % 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
        trialtiming         = cell2mat(blocinfo(nt,:).trigtime);
        probe_onset         = trialtiming(14);
        trialtiming         = cell2mat(blocinfo(nt+1,:).trigtime);
        next_cue_onset  	= trialtiming(2);
        
        all_iti             = [all_iti; next_cue_onset-probe_onset]; clear next_cue_onset probe_onset trialtiming
        
    end
    
    nrow    = 2;
    ncol    = 3;
    
    i = i + 1;
    subplot(nrow,ncol,i)
    histogram(all_iti,'BinWidth',0.005);
    xlabel('Time (s)');
    title(['iti: Gab to Next Cue Bloc' num2str(nbloc)]);
    xlim([2 2.7]);
    ylim([0 2.5]);
    
end