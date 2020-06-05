% testScriptROC3.m
%% sortMouseData_QZ
% sorted2588 = sortMouseData_QZ(mouseData2588);
% sorted2610 = sortMouseData_QZ(mouseData2610);
% mouseData215 = getMouseData_QZ(twdb,{'215'});
% sorted215 = sortMouseData_QZ(mouseData215);
% mouseData2593 = getMouseData_QZ(twdb,'2593');
% sorted2593 = sortMouseData_QZ(mouseData2593);

% mouseData2703 = getMouseData_QZ(twdb,'2703');
% sorted2703 = sortMouseData_QZ(mouseData2703);
% mouseData2705 = getMouseData_QZ(twdb,'2705');
% sorted2705 = sortMouseData_QZ(mouseData2705);

% mouseData8 = getMouseData_QZ(twdb,'8');
% sorted8 = sortMouseData_QZ(mouseData8);

% mouseData63 = getMouseData_QZ(twdb,'63');
% sorted63 = sortMouseData_QZ(mouseData63);

% mouseData3 = getMouseData_QZ(twdb,'3');
% sorted3 = sortMouseData_QZ(mouseData3);
% 
% mouseData3001 = getMouseData_QZ(twdb,'3001');
% sorted3001 = sortMouseData_QZ(mouseData3001);

% mouseData59 = getMouseData_QZ(twdb,'59');
% sorted59 = sortMouseData_QZ(mouseData59);

% mouseData2774 = getMouseData_QZ(twdb,'2774');
% sorted2774 = sortMouseData_QZ(mouseData2774);
%% calcCorrStats.m
% [dp_arr,c_arr,rTA_arr,rTS_arr,cTS_arr,tpr_arr,fpr_arr,lrr_arr,...
%     lrc_arr] = calcCorrStats(twdb,HD,hdIdxs);
%% getBaselineSessionNum_QZ
% [bSN3,twdbIdx3,twdbIdxsLastThird3] = getBaselineSessionNum_QZ(twdb,{'3'});
%% getMouseTrialData_QZ
% cases = unique({twdb(:).mouseID});
% health = cell(1,length(cases));
% strio = cell(1,length(cases));
% lFT = zeros(1,length(cases));
% age = zeros(1,length(cases));
% rewardTones = zeros(1,length(cases));
% costTones = zeros(1,length(cases));
% allTrialData = cell(1,length(cases));
% allFirstTask = cell(1,length(cases));
% dreadd = cell(1,length(cases));
% genotype = cell(1,length(cases));
% positive = zeros(1,length(cases));
% twdbIdxs = cell(1,length(cases));
% for i = 1:length(cases)
%     disp(['------' num2str(i) ': Mouse ' cases{i} '------'])
%     [aTD,aFT,idxs] = getMouseTrialData_QZ(twdb,cases(i));
%     twdbIdxs{i} = idxs;
%     allTrialData{i} = aTD;
%     allFirstTask{i} = aFT;
%     health{i} = first(twdb_lookup(twdb,'Health','key','mouseID',cases(i)));
%     strio{i} = first(twdb_lookup(twdb,'intendedStriosomality','key','mouseID',cases(i)));
%     lFT(i) = first(twdb_lookup(twdb,'learnedFirstTask','key','mouseID',cases(i)));
%     age(i) = first(twdb_lookup(twdb,'firstSessionAge','key','mouseID',cases(i)));
%     rewardTones(i) = first(twdb_lookup(twdb,'rewardTone','key','mouseID',cases(i)));
%     costTones(i) = first(twdb_lookup(twdb,'costTone','key','mouseID',cases(i)));
%     dreadd{i} = first(twdb_lookup(twdb,'DREADDType','key','mouseID',cases(i)));
%     genotype{i} = first(twdb_lookup(twdb,'genotype','key','mouseID',cases(i)));
%     positive(i) = first(twdb_lookup(twdb,'positive','key','mouseID',cases(i)));
% end
% index = 1:length(cases);
% miceType = table(cases',health',strio',lFT',age',...
%     rewardTones',costTones',allTrialData',allFirstTask',dreadd',genotype',...
%     positive',index',twdbIdxs','VariableNames',{'mouseID','Health',...
%     'intendedStriosomality','learnedFirstTask','firstSessionAge',...
%     'rewardTone','costTone','trialData','firstTaskTrials','DREADDType',...
%     'genotype','positive','index','twdbIndices'});
% save('behavioralDB_06_06_2019.mat','miceType');
%%
% [mouseTrials,mouseFluorTrials,rewardTone,costTone,~] = get_all_trials(twdb,{'2553'},23);
% [~,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,~,~,~,~,...
%     ~] = get_dprime_traceArea(first(mouseTrials),first(mouseFluorTrials),rewardTone,costTone,1);