# -*- coding: utf-8 -*-
"""
Created on Fri Feb 14 17:12:21 2020

@author: hesels
"""

import os
#os.chdir('/home/mrphys/hesels/.conda/envs/mne_final/lib/python3.5/site-packages/'
import mne
import numpy as np
from mne.decoding import (SlidingEstimator, cross_val_multiscore, LinearModel, get_coef,GeneralizingEstimator,Vectorizer)
from mne.decoding import (GeneralizingEstimator,SlidingEstimator, cross_val_multiscore, LinearModel, get_coef)
#os.chdir('/home/mrphys/hesels/.conda/envs/mne_final/lib/python3.5/')
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from scipy.io import (savemat,loadmat)



suj_list                                                    = [1,2,3,4,5,6,7,8,9,10,
                                                   11,12,13,14,15,16,17,18,19,20,
                                                   21,22,23,24,25,26,27,28,29,
                                                   30,31,32,33,35,36,38,39,40,
                                                   41,42,43,44,46,47,48,49,
                                                   50,51]


freq_list                                                   = ["alpha.peak.centered","beta.peak.centered"]

for isub in range(len(suj_list)):
    
    suj                                                     = suj_list[isub]    
    
    for ifreq in range(len(freq_list)):
        for ises in [1,2]:
            
            fname                                           = 'J:/nback/tf/sub' + str(suj)+'.sess'+str(ises) +'.orig.'+freq_list[ifreq]+'.mat'
            ename                                           = 'J:/nback/nback_' +str(ises) + '/data_sess' +str(ises) + '_s'+ str(suj)  + '_trialinfo.mat'
            print('Handling '+ fname)
                
            epochs_nback                                    = mne.read_epochs_fieldtrip(fname, None, data_name='data', trialinfo_column=0)
            
            # !! apply baseline !! #
            time_axis                                       = epochs_nback.times
            b1                                              = epochs_nback.times[np.squeeze(np.where(np.round(time_axis,2) == np.round(-0.5,2)))]
            b2                                              = epochs_nback.times[np.squeeze(np.where(np.round(time_axis,2) == np.round(0,2)))]
            epochs_nback                                    = epochs_nback.apply_baseline(baseline=(b1,b2))
            
            tmp_data                                        = epochs_nback.get_data()
            tmp_evnt                                        = loadmat(ename)['index'][:,[0,2,4,7]]  
            tmp_evnt[:,-1]                                   = np.squeeze(tmp_evnt[:,-1]-(np.floor(tmp_evnt[:,-1]/10)*10)) + 1
            
            # !! exclude motor !! #
            trl                                             = np.squeeze(np.where(tmp_evnt[:,2] ==0))
            # sub-select time window
            t1                                              = np.squeeze(np.where(np.round(time_axis,2) == np.round(-0.5,2)))
            t2                                              = np.squeeze(np.where(np.round(time_axis,2) == np.round(2,2)))
            
            tmp_data                                        = np.squeeze(tmp_data[trl,:,t1:t2])
            tmp_evnt                                        = np.squeeze(tmp_evnt[trl,:])
            time_axis                                       = np.squeeze(time_axis[t1:t2])
            
            if ises == 1:
                alldata                                     = tmp_data #Get all epochs as a 3D array
                allevents                                   = tmp_evnt
                del(tmp_data,tmp_evnt)
            else:
                alldata                                     = np.concatenate((alldata,tmp_data),axis=0)
                allevents                                   = np.concatenate((allevents,tmp_evnt),axis=0)
                del(tmp_data,tmp_evnt)
            
            del(fname,ename,epochs_nback,trl,b1,b2)

        
        for nstim in [1,2]:
            
            list_stim                                       = ["first","target","all","nonrand"]
            
            if nstim ==3:
                find_stim                                   = np.where(allevents[:,1] < 10)
            elif nstim == 4:
                find_stim                                   = np.where(allevents[:,1] > 0)
            else:
                find_stim                                   = np.where(allevents[:,1] == nstim)
            
            data_stim                                       = np.squeeze(alldata[find_stim,:,:])
            evnt_stim                                       = np.squeeze(allevents[find_stim,0])
            
            for nback in [1,2]:
                
                find_nback                                  = np.where(evnt_stim == nback+4)
                
                dir_out                                     = 'J:/nback/sens_level_auc/coef/'
                fscores_out                                 = dir_out + 'sub' + str(suj) + '.decoding.' + str(nback) + 'back.'
                fscores_out                                 = fscores_out+ 'agaisnt.all.'+ freq_list[ifreq] + '.lockedon.' +list_stim[nstim-1]+ '.dwn70.bsl.excl.coef.mat'
                            
                if np.size(find_nback)>0 and np.size(find_stim)>1 and np.size(find_nback)<np.size(evnt_stim):
                    if not os.path.exists(fscores_out):
                            
                        x                                   = data_stim
                        x[np.where(np.isnan(x))]            = 0
                            
                        y                                   = np.zeros(np.shape(evnt_stim)[0])
                        y[find_nback]                       = 1
                        y                                   = np.squeeze(y)
                        
                        clf                                 = make_pipeline(Vectorizer(),
                                                                        StandardScaler(), 
                                                                        LinearModel(LogisticRegression(solver='lbfgs',max_iter=150))) # define model
                        
                        print('\nfitting model for '+fscores_out)
                        clf.fit(x,y)
                        print('extracting coefficients for '+fscores_out)            
                        for name in('patterns_','filters_'):
                            coef                            = get_coef(clf,name,inverse_transform=True)
                            
                        savemat(fscores_out, mdict={'scores': coef,'time_axis':time_axis})
                        print('\nsaving '+ fscores_out + '\n')
                        
                        del(coef,x,y)
                        
                del(find_nback)
            del(find_stim,data_stim,evnt_stim)
        del(allevents,alldata)