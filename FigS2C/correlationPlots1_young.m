function [learnWT_IDs,learnWT_Trials,learnWT_FTrials,learnWT_rTones,...
    learnWT_cTones] = correlationPlots1_young(twdb,striosomality,upToLearned,reversal,periods)
% striosomality - Strio or Matrix
% Updated 04/23/2020
% Author: QZ
% 08/16/2019
% nonRespCorrs2.m
%% Part I. Get Data
learnWT_IDs = unique(twdb_lookup(twdb,'mouseID','key','Health','WT',...
    'grade','learnedFirstTask',0,inf,'key','intendedStriosomality',striosomality,...
    'grade','firstSessionAge',6,9));
learnWT_Trials = cell(1,length(periods));
learnWT_FTrials = cell(1,length(periods));
learnWT_rTones = cell(1,length(periods));
learnWT_cTones = cell(1,length(periods));
for i = 1:length(periods)
    period = periods{i};
    disp(['---------Period: ' period '---------']);
    [learnwt_Trials,learnwt_FTrials,~,learnwt_rTones,learnwt_cTones,...
        ~] = get_all_trials_edit2QZ(twdb,learnWT_IDs,upToLearned,reversal,period);
    learnWT_Trials{i} = learnwt_Trials;
    learnWT_FTrials{i} = learnwt_FTrials;
    learnWT_rTones{i} = learnwt_rTones;
    learnWT_cTones{i} = learnwt_cTones;
end
end