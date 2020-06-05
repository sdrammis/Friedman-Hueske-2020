function [learnWT_DP,learnWT_C,learnWT_RLF,learnWT_CLF] = correlationPlots2_mouse(numBins,...
    periods,learnWT_IDs,learnWT_Trials,learnWT_FTrials,learnWT_rTones,learnWT_cTones)
% Partitioned from correlationPlots.m 04/23/2020
% QZ

learnWT_DP = cell(1,length(periods));
learnWT_C = cell(1,length(periods));
learnWT_RLF = cell(1,length(periods));
learnWT_CLF = cell(1,length(periods));
for i = 1:length(periods)
    [learnwt_dp,learnwt_c,learnwt_rlf,...
        learnwt_clf] = calcBTPeriods_edit2QZ(learnWT_IDs,learnWT_Trials{i},...
        learnWT_FTrials{i},learnWT_rTones{i},learnWT_cTones{i},numBins);
    learnWT_DP{i} = learnwt_dp;
    learnWT_C{i} = learnwt_c;
    learnWT_RLF{i} = learnwt_rlf;
    learnWT_CLF{i} = learnwt_clf;
end
end