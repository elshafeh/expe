clear;

% load log file
subjectname             = 'p002';
filename                = ['../Logfiles/' subjectname '/' subjectname '_taco_block_Logfile.mat'];
load(filename);

i                       = 0;

for nbloc = 1:3
    
    flg                     = find(Info.TrialInfo.nbloc == nbloc);
    blocinfo                = Info.TrialInfo(flg,:);
    all_isi                 = [];
    
    for nt = 1:height(blocinfo)-1
        
        % c c c g g g g g g c  c  c  g  g  g
        % 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
        trialtiming         = cell2mat(blocinfo(nt,:).trigtime);
        
        st_cue_onset        = trialtiming(2);
        st_smp_onset        = trialtiming(5);
        nd_smp_onset        = trialtiming(8);
        nd_cue_onset        = trialtiming(11);
        probe_onset         = trialtiming(14);
        
        tmp                 = [st_smp_onset nd_smp_onset nd_cue_onset probe_onset];
        tmp                 = tmp - st_cue_onset;
        
        all_isi             = [all_isi; tmp]; clear tmp *_onset
        
    end
    
    nrow    = 3;
    ncol    = 1;
    
    i = i + 1;
    subplot(nrow,ncol,i)
    histogram(all_isi,'BinWidth',0.04);
    xlabel('Time (s)');
    title(['ISI Bloc' num2str(nbloc)]);
    xlim([0 9]);
    xticks([0:0.5:9]);
    
end