clear ; clc ; close all;

addpath(genpath('../../fieldtrip-20151124/'));

% [~,suj_list,~]  = xlsread('../documents/New_PrepAtt22_Participant_Index_and_Preprocessing_Progress.xlsx','B:B');
% suj_list        = suj_list(2:end);

suj_list = {'oc6','mg19'};

load('../documents/pick_jump_ElanConcatFileToUse.mat'); summary = table2array(summary) ;

trialpot = [];

for sb = 1:length(suj_list)
    
    suj                     = suj_list{sb};
    flag                    = find(strcmp(summary(:,1),suj));
    dirConcatIn             = summary{flag,2};
    
    cd(['../data/' suj '/meeg/'])
    
    filt_chain = {'meeg.bs47t53.o3','meeg.bs97t103.o3','meeg.bs147t153.o3','meeg.bp0point1t40.o3','eeg.bp0point1t40.o3'};
    
    eeg_file_list = {};
    
    for nfilt = 1:length(filt_chain)
        
        bitsnpieces{nfilt} = strsplit(filt_chain{nfilt},'.');
        
        if nfilt == 1
            
            eegFileIN       = dirConcatIn;
            eegFileOUT      = [eegFileIN '.' bitsnpieces{nfilt}{2} '.' bitsnpieces{nfilt}{3}];
            
        elseif nfilt == 5
            
            eegFileIN       = eeg_file_list{nfilt-2,2};
            eegFileOUT      = [eegFileIN '.' bitsnpieces{nfilt}{2} '.' bitsnpieces{nfilt}{3} '.OnlyEEG'];
            
        else
            
            eegFileIN       = eeg_file_list{nfilt-1,2};
            eegFileOUT      = [eegFileIN '.' bitsnpieces{nfilt}{2} '.' bitsnpieces{nfilt}{3} ''];
            
        end
        
        eeg_file_list{nfilt,1} = eegFileIN;
        eeg_file_list{nfilt,2} = eegFileOUT;
        
    end
    
    for nfilt = 1:length(filt_chain)
        
        parFile             = ['../../../par/' filt_chain{nfilt} '.par'];
        
        ligne               = ['eegfiltfilt ' eeg_file_list{nfilt,1} '.eeg ' parFile ' ' eeg_file_list{nfilt,2} '.eeg'];
        
        system(ligne);
        
    end
    
    save(['../res/' suj '_eeg_file_list.mat'],'eeg_file_list')
    
    ligne = 'rm *bs47t53.o3.eeg*  *bs47t53.o3.bs97t103.o3.eeg* ';
    
    system(ligne);
    
    cd ../../../scripts.m/
    
end