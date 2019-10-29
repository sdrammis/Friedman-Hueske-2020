function correlationOverTime(twdb)

% Author: QZ
% 08/19/2019
% rollingReversal.m
%% Part I. Get Data - only Strio
L2HDS_IDs = unique(twdb_lookup(twdb,'mouseID','key','Health','HD',...
    'key','intendedStriosomality','Strio','grade','learnedReversalTask',0,inf));
L2HDS_IDs = getMiceAttemptReversal_QZ(twdb,L2HDS_IDs); % unnecessary

upToLearned = 0;
reversal = 0;
[L2HDS_Trials1,L2HDS_FTrials1,L2HDS_rTones,L2HDS_cTones] = get_all_trials(twdb,...
    L2HDS_IDs,upToLearned,reversal);
reversal = 1;
[L2HDS_Trials2,L2HDS_FTrials2,~,~] = get_all_trials(twdb,L2HDS_IDs,...
    upToLearned,reversal);
%% Part III. Plotting w/Edit1 Functions
engagement = 1;
L2HDS_title = 'Learn Both Tasks HD Strio Engaged Trials ';
[R_first,R_reversal] = correlationOverTime_reversal_edit1QZ(L2HDS_IDs(1),L2HDS_title,engagement,...
    L2HDS_rTones(1),L2HDS_cTones(1),L2HDS_Trials1(1),L2HDS_Trials2(1),L2HDS_FTrials1(1),...
    L2HDS_FTrials2(1),0.04,5);
xlim([3 30]);
% data table creation
RFirst65 = table(R_first{1}','VariableNames',{'RFirstTask'});
RReversal65 = table(R_reversal{1}','VariableNames',{'RReversalTask'});
% save('RFirst65.mat','RFirst65');
% save('RReversal65.mat','RReversal65');