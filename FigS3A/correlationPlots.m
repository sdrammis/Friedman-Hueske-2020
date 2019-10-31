function correlationPlots(twdb)

% Author: QZ
% 08/16/2019
% nonRespCorrs2.m
%% Part I. Get Data
learnWTS_IDs = unique(twdb_lookup(twdb,'mouseID','key','Health','WT',...
    'grade','learnedFirstTask',0,inf,'key','intendedStriosomality','Strio'));
learnWTS_IDs(strcmp(learnWTS_IDs,'4635')) = []; % faulty photometry data
periods = {'tone','response','outcome','ITI'};
upToLearned = 0;
reversal = 0;
learnWTS_Trials = cell(1,length(periods));
learnWTS_FTrials = cell(1,length(periods));
learnWTS_rTones = cell(1,length(periods));
learnWTS_cTones = cell(1,length(periods));
for i = 1:length(periods)
    period = periods{i};
    [learnwts_Trials,learnwts_FTrials,~,learnwts_rTones,learnwts_cTones,...
        ~] = get_all_trials_edit2QZ(twdb,learnWTS_IDs,upToLearned,reversal,period);
    learnWTS_Trials{i} = learnwts_Trials;
    learnWTS_FTrials{i} = learnwts_FTrials;
    learnWTS_rTones{i} = learnwts_rTones;
    learnWTS_cTones{i} = learnwts_cTones;
end
binSize = 200;
learnWTS_DP = cell(1,length(periods));
learnWTS_RTA = cell(1,length(periods));
for i = 1:length(periods)
    [~,~,learnwts_dp,~,~,learnwts_rta] = calcBTPeriods_QZ(learnWTS_IDs,learnWTS_Trials{i},...
        learnWTS_FTrials{i},learnWTS_rTones{i},learnWTS_cTones{i},binSize);
    learnWTS_DP{i} = learnwts_dp;
    learnWTS_RTA{i} = learnwts_rta;
end
%% Part II. Plotting
xbinSize = 0.25;
for i = 1:length(periods)
    period = periods{i};
    plotCorrZ(learnWTS_IDs,learnWTS_DP{i},learnWTS_RTA{i},'D-Prime','R-C Trace Area',...
        xbinSize,['Learn WT Strio ' period]);
end