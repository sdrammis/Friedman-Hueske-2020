function plotCorrelations(twdb,striosomality)

    miceIDs = get_mouse_ids(twdb,0,'WT',1,striosomality,'all','',1,{'3910', '4198','4635', '4638', '4778'});   
    [miceTrials,miceFluorTrials,~,rewardTones,costTones,~] = get_all_trials_edit2QZ(twdb,miceIDs,0,0,'response');
    % lickrate vs Rsum
    individualMouse_correlation(twdb,miceIDs,miceTrials,miceFluorTrials,rewardTones,costTones,'WT',1,striosomality,'','Lick Frequency','all', 1, 'response','Rsum',0,'slopes',0)
    individualMouse_correlation(twdb,miceIDs,miceTrials,miceFluorTrials,rewardTones,costTones,'WT',1,striosomality,'','Lick Frequency','all', 1, 'response','Rsum',1,'slopes',0)
    individualMouse_correlation(twdb,miceIDs,miceTrials,miceFluorTrials,rewardTones,costTones,'WT',1,striosomality,'','Lick Frequency','all', .25, 'response','Rsum',1,'slopes',0)
    % lickrate vs Csum
    individualMouse_correlation(twdb,miceIDs,miceTrials,miceFluorTrials,rewardTones,costTones,'WT',1,striosomality,'','Lick Frequency','all', 1, 'response','Csum',0,'slopes',0)
    individualMouse_correlation(twdb,miceIDs,miceTrials,miceFluorTrials,rewardTones,costTones,'WT',1,striosomality,'','Lick Frequency','all', 1, 'response','Csum',1,'slopes',0)
    individualMouse_correlation(twdb,miceIDs,miceTrials,miceFluorTrials,rewardTones,costTones,'WT',1,striosomality,'','Lick Frequency','all', .25, 'response','Csum',1,'slopes',0)
end