% createDataTable3A.m
DATATABLE3A = table({learnWTS_IDs},{learnWTS_DP},{learnWTS_RTA},{periods},...
    'VariableNames',{'learnWTS_IDs','DPrime','RewardTraceArea','periodsInOrder'});
% save('DATATABLE3A.mat','DATATABLE3A');