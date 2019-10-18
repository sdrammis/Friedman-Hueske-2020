% Author: QZ
% 07/16/2019
function [trialData,onlyFirstTask,twdbIdxs] = getMouseTrialData_QZ(twdb,msID)
mouseData = getMouseData_QZ(twdb,msID);
sortedData = sortMouseData_QZ(mouseData);
allTrials = sortedData.trialData;
twdbIdxs = sortedData.index;
trialData = [];
onlyFirstTask = [];
% trialData = [sortedData.trialData{1}(:,1:8);sortedData.trialData{2}(:,1:8)];
for i = 1:length(allTrials)
%     disp(['~~~' num2str(i) '~~~']);
%     disp(size(sortedData.trialData{i}));
    if ~isempty(sortedData.trialData{i})
        trialData = [trialData;sortedData.trialData{i}(:,1:8)];
        if strcmp(sortedData.injection(i),'') && ...
                strcmp(sortedData.devaluation(i),'') && ...
                strcmp(sortedData.taskType(i),sortedData.firstSessionType(i))
%             disp(num2str(i))
            onlyFirstTask = [onlyFirstTask;sortedData.trialData{i}(:,1:8)];
        end
    end
end
end