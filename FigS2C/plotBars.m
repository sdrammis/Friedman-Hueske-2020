function plotBars(twdb)

periods = {'response'};
% up to learn - get q1
[learnWTM_IDs,learnWTM_Trials,learnWTM_FTrials,learnWTM_rTones,...
    learnWTM_cTones] = correlationPlots1_young(twdb,'Matrix',1,0,periods);
[learnWTS_IDs,learnWTS_Trials,learnWTS_FTrials,learnWTS_rTones,...
    learnWTS_cTones] = correlationPlots1_young(twdb,'Strio',1,0,periods);
[learnWTM_q1Trials,learnWTM_q1FTrials] = getFirstQuarterTrials(periods,...
    learnWTM_IDs,learnWTM_Trials,learnWTM_FTrials);
[learnWTS_q1Trials,learnWTS_q1FTrials] = getFirstQuarterTrials(periods,...
    learnWTS_IDs,learnWTS_Trials,learnWTS_FTrials);
numBins = 20;
% all learning up to reversal - get q4
[learnWTM_IDs_all,learnWTM_Trials_all,learnWTM_FTrials_all,learnWTM_rTones_all,...
    learnWTM_cTones_all] = correlationPlots1_young(twdb,'Matrix',0,0,periods);
[learnWTS_IDs_all,learnWTS_Trials_all,learnWTS_FTrials_all,learnWTS_rTones_all,...
    learnWTS_cTones_all] = correlationPlots1_young(twdb,'Strio',0,0,periods);
[learnWTM_q4Trials,learnWTM_q4FTrials] = getLastQuarterTrials(periods,...
    learnWTM_IDs_all,learnWTM_Trials_all,learnWTM_FTrials_all);
[learnWTS_q4Trials,learnWTS_q4FTrials] = getLastQuarterTrials(periods,...
    learnWTS_IDs_all,learnWTS_Trials_all,learnWTS_FTrials_all);

[~,~,learnWTM_q1RLF,learnWTM_q1CLF] = correlationPlots2_mouse(numBins,...
    periods,learnWTM_IDs,learnWTM_q1Trials,learnWTM_q1FTrials,...
    learnWTM_rTones,learnWTM_cTones);
[~,~,learnWTS_q1RLF,learnWTS_q1CLF] = correlationPlots2_mouse(numBins,...
    periods,learnWTS_IDs,learnWTS_q1Trials,learnWTS_q1FTrials,...
    learnWTS_rTones,learnWTS_cTones);
[~,~,learnWTM_q4RLF,learnWTM_q4CLF] = correlationPlots2_mouse(numBins,...
    periods,learnWTM_IDs,learnWTM_q4Trials,learnWTM_q4FTrials,...
    learnWTM_rTones,learnWTM_cTones);
[~,~,learnWTS_q4RLF,learnWTS_q4CLF] = correlationPlots2_mouse(numBins,...
    periods,learnWTS_IDs,learnWTS_q4Trials,learnWTS_q4FTrials,...
    learnWTS_rTones,learnWTS_cTones);
figure();
subplot(1,2,1);
hold on;
plotBar({learnWTS_q1CLF{1},learnWTS_q4CLF{1},learnWTM_q1CLF{1},learnWTM_q4CLF{1}},...
    'Cost Lick Frequency',{'Strio Q1','Strio Q4','Matrix Q1','Matrix Q4'},'WT Learn 6-9 mo.');
hold off;
subplot(1,2,2);
hold on;
plotBar({learnWTS_q1RLF{1},learnWTS_q4RLF{1},learnWTM_q1RLF{1},learnWTM_q4RLF{1}},...
    'Reward Lick Frequency',{'Strio Q1','Strio Q4','Matrix Q1','Matrix Q4'},'WT Learn 6-9 mo.');
hold off;

% t-tests
disp('------------paired t-tests------------');
ttest_QZ(learnWTS_q1CLF{1},learnWTS_q4CLF{1},'Learn WT Strio CLF Q1 vs. Q4: ');
ttest_QZ(learnWTM_q1CLF{1},learnWTM_q4CLF{1},'Learn WT Matrix CLF Q1 vs. Q4: ');
ttest_QZ(learnWTS_q1RLF{1},learnWTS_q4RLF{1},'Learn WT Strio RLF Q1 vs. Q4: ');
ttest_QZ(learnWTM_q1RLF{1},learnWTM_q4RLF{1},'Learn WT Matrix RLF Q1 vs. Q4: ');
ttest_QZ([learnWTS_q1CLF{1} learnWTM_q1CLF{1}],[learnWTS_q4CLF{1} learnWTM_q4CLF{1}],'Learn WT CLF Q1 vs. Q4: ');
ttest_QZ([learnWTS_q1RLF{1} learnWTM_q1RLF{1}],[learnWTS_q4RLF{1} learnWTM_q4RLF{1}],'Learn WT RLF Q1 vs. Q4: ');
disp('------------2 sample t-tests------------');
ttest2_QZ(learnWTS_q1CLF{1},learnWTM_q1CLF{1},'Learn WT CLF Q1 Strio vs. Matrix: ');
ttest2_QZ(learnWTS_q1RLF{1},learnWTM_q1RLF{1},'Learn WT RLF Q1 Strio vs. Matrix: ');
ttest2_QZ(learnWTS_q4CLF{1},learnWTM_q4CLF{1},'Learn WT CLF Q4 Strio vs. Matrix: ');
ttest2_QZ(learnWTS_q4RLF{1},learnWTM_q4RLF{1},'Learn WT RLF Q4 Strio vs. Matrix: ');
