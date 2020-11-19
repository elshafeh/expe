function taco_timing_checkorder

global info

figure;
suj_list                                = info.suj_list;

i                                       = 0;

bloc_order                              = [];

for nsuj = 1:length(suj_list)
    
    %load log file
    subjectname                         = suj_list{nsuj};
    filename                            = ['../Logfiles/' subjectname '/' subjectname '_taco_v2_block_Logfile.mat'];
    load(filename);
    
    Info                                = taco_cleaninfo(Info);%% remove empty trials
    Info                                = taco_fixlog(subjectname,Info);%% fix subjects
    
    list_block                          = {'early' 'late' 'jittered'};
    list_cue                            = {'pre' 'retro'};
    list_attend                         = {'first' 'second'};
    
    for nbloc = 1:length(list_block)
        
        flg                             = find(strcmp([Info.TrialInfo.bloctype],list_block{nbloc}));
        flg                             = flg(1);
        
        if flg == 1
            bloc_order(nsuj,nbloc)   	= 1;
        elseif flg == 65
            bloc_order(nsuj,nbloc)   	= 2;
        elseif flg == 129
            bloc_order(nsuj,nbloc)      = 3;
        end
        
    end
end

keep bloc_order list_block

%%

subplot(2,1,1)
hold on
for n = 1:3
    scatter(bloc_order(:,n),repmat(n,size(bloc_order,1),1));
end
ylim([0 length(bloc_order)+1]);
xlim([0 4])
xticks([1 2 3])
xticklabels(list_block);
yticks([0 length(bloc_order)+1]);

subplot(2,1,2)
plot(bloc_order','LineWidth',1)
ylim([0 4])
yticks([0 4])
xlim([0 4])
xticks([1 2 3])
xticklabels(list_block);