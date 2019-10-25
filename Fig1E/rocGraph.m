function rocGraph(twdb)

%% ROC Graphs - TPR vs. FPR
% Author: QZ
% 06/12/2019
% roc_graphs2_3.m
%% loads data


%% Get Data for young learning WT mice, not filtered for Emily's non-photometry animals
% createStruct(twdb,age,health,learned,engagementFilt,photoFilt,cStats)
midWT = createStruct(twdb,'mid','WT',true,false,false,false,false); % added last false
midWT = calcStats2(midWT);
size = 10;
%% Plotting progression TPR vs. FPR
figure();
c2 = [zeros(1,4);(0.1:0.3:1);zeros(1,4)]';
hold on;
tpr_fpr_scatter2({[midWT.FPREarly],[midWT.FPRMid],[midWT.FPRLate],[midWT.FPRLast3]},...
    {[midWT.TPREarly],[midWT.TPRMid],[midWT.TPRLate],[midWT.TPRLast3]},size,c2,...
    '9-12 months WT',[midWT.DLast3],[midWT.CLast3],[midWT.DEarly],[midWT.CEarly]);
hold off;
%% Table creation
% DATATABLE = table([midWT.FPREarly]',[midWT.FPRMid]',[midWT.FPRLate]',[midWT.FPRLast3]',...
%     [midWT.TPREarly]',[midWT.TPRMid]',[midWT.TPRLate]',[midWT.TPRLast3]',...
%     [midWT.DLast3]',[midWT.CLast3]',[midWT.DEarly]',[midWT.CEarly]',...
%     'VariableNames',{'FPREarly','FPRMid','FPRLate','FPRLast50',...
%     'TPREarly','TPRMid','TPRLate','TPRLast50','DPLast50','CLast50',...
%     'DPEarly','CEarly'});
% save('DATATABLE.mat','DATATABLE');