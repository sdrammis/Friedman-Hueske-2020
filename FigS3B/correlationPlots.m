function correlationPlots(twdb)

% Author: QZ
% 08/16/2019
% nonRespCorrs2.m
%% Part I. Get Data
learnWTM_IDs = unique(twdb_lookup(twdb,'mouseID','key','Health','WT',...
    'grade','learnedFirstTask',0,inf,'key','intendedStriosomality','Matrix'));
periods = {'tone','response','outcome','ITI'};
upToLearned = 0;
reversal = 0;
learnWTM_Trials = cell(1,length(periods));
learnWTM_FTrials = cell(1,length(periods));
learnWTM_rTones = cell(1,length(periods));
learnWTM_cTones = cell(1,length(periods));
for i = 1:length(periods)
    period = periods{i};
    [learnwtm_Trials,learnwtm_FTrials,~,learnwtm_rTones,learnwtm_cTones,...
        ~] = get_all_trials_edit2QZ(twdb,learnWTM_IDs,upToLearned,reversal,period);
    learnWTM_Trials{i} = learnwtm_Trials;
    learnWTM_FTrials{i} = learnwtm_FTrials;
    learnWTM_rTones{i} = learnwtm_rTones;
    learnWTM_cTones{i} = learnwtm_cTones;
end
binSize = 200;
learnWTM_RZ = cell(1,length(periods));
learnWTM_CZ = cell(1,length(periods));
learnWTM_RTS = cell(1,length(periods));
learnWTM_CTS = cell(1,length(periods));
for i = 1:length(periods)
    [learnwtm_rz,learnwtm_cz,~,learnwtm_rts,learnwtm_cts,~] = calcBTPeriods_QZ(learnWTM_IDs,learnWTM_Trials{i},...
        learnWTM_FTrials{i},learnWTM_rTones{i},learnWTM_cTones{i},binSize);
    learnWTM_RZ{i} = learnwtm_rz;
    learnWTM_CZ{i} = learnwtm_cz;
    learnWTM_RTS{i} = learnwtm_rts;
    learnWTM_CTS{i} = learnwtm_cts;
end
%% Part II. Plotting
xbinSize = 0.25;
for i = 1:length(periods)
    period = periods{i};
    if isequal(period,'response')
        plotCorrZ(learnWTM_IDs,learnWTM_RZ{i},learnWTM_RTS{i},'Reward Z-Score',...
            'Reward Trace Sum',xbinSize,['Learn WT Matrix ' period]);
        plotCorrZ(learnWTM_IDs,learnWTM_CZ{i},learnWTM_CTS{i},'Cost Z-Score',...
            'Cost Trace Sum',xbinSize,['Learn WT Matrix ' period]);
    else
        plotCorrZ(learnWTM_IDs,[learnWTM_RZ{i} learnWTM_CZ{i}],...
            [learnWTM_RTS{i} learnWTM_CTS{i}],'Z-Score','Trace Sum',xbinSize,...
            ['Learn WT Matrix ' period]);
    end
end