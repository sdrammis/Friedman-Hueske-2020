function rocGraph(twdb)

%% ROC Graphs - TPR vs. FPR
% Author: QZ
% 06/12/2019
% roc_graphs2_3.m
%% loads data

% strio vs. matrix. 1E. young animals only. 2 subplots (strio vs. matrix). Dynamic of learning is same for svm
%% Get Data for young learning WT mice, not filtered for Emily's non-photometry animals
% createStruct(twdb,age,health,learned,engagementFilt,photoFilt,cStats,noBaseFilt,strio)
yngWTS = createStruct(twdb,'young','WT',true,false,false,false,false,'Strio'); % added last false
yngWTS = calcStats2(yngWTS);
yngWTM = createStruct(twdb,'young','WT',true,false,false,false,false,'Matrix');
yngWTM = calcStats2(yngWTM);
size = 10;
%% Plotting progression TPR vs. FPR
c2 = [zeros(1,4);(0.1:0.3:1);zeros(1,4)]';
figure();
subplot(2,1,1);
hold on;
tpr_fpr_scatter2({[yngWTS.FPREarly],[yngWTS.FPRMid],[yngWTS.FPRLate],[yngWTS.FPRLast3]},...
    {[yngWTS.TPREarly],[yngWTS.TPRMid],[yngWTS.TPRLate],[yngWTS.TPRLast3]},size,c2,...
    '<=12 months WT Strio',[yngWTS.DLast3],[yngWTS.CLast3],[yngWTS.DEarly],[yngWTS.CEarly]);
hold off;
subplot(2,1,2);
hold on;
tpr_fpr_scatter2({[yngWTM.FPREarly],[yngWTM.FPRMid],[yngWTM.FPRLate],[yngWTM.FPRLast3]},...
    {[yngWTM.TPREarly],[yngWTM.TPRMid],[yngWTM.TPRLate],[yngWTM.TPRLast3]},size,c2,...
    '<=12 months WT Matrix',[yngWTM.DLast3],[yngWTM.CLast3],[yngWTM.DEarly],[yngWTM.CEarly]);
hold off;