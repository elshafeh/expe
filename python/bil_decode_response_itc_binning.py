#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Sep 29 09:44:35 2019

@author: heshamelshafei
"""

import os
if os.name != 'nt':
    os.chdir('/home/mrphys/hesels/.conda/envs/mne_final/lib/python3.5/site-packages/')

import mne
import numpy as np
from mne.decoding import (SlidingEstimator, LinearModel, cross_val_multiscore)

if os.name != 'nt':
    os.chdir('/home/mrphys/hesels/.conda/envs/mne_final/lib/python3.5/')

from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from scipy.io import (savemat,loadmat)

#

suj_list                                        = list(["sub001","sub003","sub004","sub006","sub008","sub009","sub010","sub011","sub012",
                                                        "sub013","sub014","sub015","sub016","sub017",
                                            "sub018","sub019","sub020","sub021","sub022","sub023","sub024",
                                            "sub025","sub026","sub027","sub028","sub029","sub031","sub032",
                                            "sub033","sub034","sub035","sub036","sub037"])


dcd_list                                        = list(["button","match","correct"])
freq_list                                       = list(["theta.minus1f","alpha.minus1f","beta.minus1f","broadband"])


for isub in range(len(suj_list)):

    suj                                         = suj_list[isub]
    dir_data_out                                = 'D:/Dropbox/project_me/data/bil/decode/'
    dir_data_in                                 = 'P:/3015079.01/data/' + suj + '/preproc/'
    
    for ifreq in range(len(freq_list)):
        
        ext_name                                = '.1stcue.lock.'+freq_list[ifreq]+'.centered'
    
        fname                                   = dir_data_in + suj + ext_name + '.mat'
        print('\nHandling '+ fname+'\n')
        eventName                               = dir_data_in + suj + ext_name + '.trialinfo.mat'
    
        epochs                                  = mne.read_epochs_fieldtrip(fname, None, data_name='data', trialinfo_column=0)
        epochs                                  = epochs.apply_baseline(baseline=(-0.4,-0.2))
        
        broad_events                            = loadmat(eventName)['index']
        broad_data                              = epochs.get_data() #Get all epochs as a 3D array.
        broad_data[np.where(np.isnan(broad_data))]  = 0
        time_axis                               = epochs.times
                    
        fname_bin                               = 'P:/3015079.01/data/' + suj + '/tf/' + suj + '.itc.incorrect.index.mat'
        print('\nLoading '+ fname_bin+'\n')
        bin_index                               = loadmat(fname_bin)['bin_index']
        
        for ibin in [0,4]:
            
            find_bin                            = bin_index[:,ibin]-1
            alldata                             = np.squeeze(broad_data[find_bin,:,:])
            allevents                           = np.squeeze(broad_events[find_bin,:])
            
            del(find_bin)
        
            for ifeat in [1]:
                
                x                           = alldata
                mini_sub                    = allevents
    
                if ifeat == 0:
                    # button 1 vs button 2
                    find_trials             = np.where((mini_sub[:,15] <2))
                    y                       = np.zeros((len(mini_sub)))
                    y[np.where((mini_sub[:,19] == 1) )]                          = 1
        
                elif ifeat == 1:
                    # match vs no-match
                    find_trials             = np.where((mini_sub[:,15] <2))
                    y                       = np.squeeze(mini_sub[find_trials,5])
        
                elif ifeat == 2:
                    # correct vs incorrect
                    find_trials             = np.where((mini_sub[:,15] <2))
                    y                       = mini_sub[:,15]
                    
                fname_out                   = dir_data_out + suj + '.decodingrep' +ext_name
                fname_out                   = fname_out +'.itcorrect.bin' + str(ibin+1) + '.' + dcd_list[ifeat] + '.all.bsl.auc.mat'
    
                if not os.path.exists(fname_out):
                    x                       = np.squeeze(x[find_trials,:,:])
    
                    # increased no. iterations cause for some reason it wasn't "congerging"
                    clf                     = make_pipeline(StandardScaler(),
                                                            LinearModel(LogisticRegression(solver='lbfgs',max_iter=250))) # define model
                    time_decod              = SlidingEstimator(clf, n_jobs=1, scoring = 'roc_auc')
                    
                    if np.shape(np.where(y == 0))[1] < 3:
                        scores              = cross_val_multiscore(time_decod, x, y, cv = 2, n_jobs = 1) # crossvalidate
                    else:
                        scores              = cross_val_multiscore(time_decod, x, y, cv = 3, n_jobs = 1) # crossvalidate
    
                    scores                  = np.mean(scores, axis=0) # Mean scores across cross-validation splits
    
                    print('\nsaving '+fname_out)
                    savemat(fname_out, mdict={'scores': scores,'time_axis':time_axis})
    
                    # clean up
                    del(scores,x,y,time_decod,fname_out)