% Author: QZ
% 07/06/2019
function [baselineSessionNum,twdbIdx,twdbIdxsLastThird] = getBaselineSessionNum_QZ(twdb,msID)
% get sessionNum where the mouse learns.
rows = twdb_lookup(twdb,'index','key','mouseID',msID);
mouseData = twdb(cell2mat(rows));
sorted = sortMouseData_QZ(struct2table(mouseData));
sortedData = table2struct(sorted);
learnedTrial = mouseData(1).learnedFirstTask;
trials = 0;
if learnedTrial == -1
    disp('Non-learning')
    sortedTable = struct2table(sortedData);
    firstTaskIdxs = find(strcmp(sortedTable.taskType,sortedTable.firstSessionType));
    fTLastId = firstTaskIdxs(end);
    disp(['First and Base Task Same: ' num2str(strcmp(sortedData(fTLastId).taskType,sortedData(1).taskType))]);
    baselineSessionNum = sortedData(fTLastId).sessionNumber;
    twdbIdx = sortedData(fTLastId).index;
    twdbIdxsLastThird = sortedData(ceil(fTLastId*2/3)).index;
else
    for i = 1:length(sortedData)
        session = sortedData(i);
        if isa(session.trialData,'table')
            trials = trials + height(session.trialData);
        else
            trials = trials + length(session.trialData);
        end
        if trials >= learnedTrial
            baselineSessionNum = session.sessionNumber;
            twdbIdx = session.index;
            twdbIdxsLastThird = sortedData(ceil(2*i/3)).index;
            break;
        end
    end
end
disp(['Baseline session for ' first(msID) ' is ' ...
    num2str(baselineSessionNum) ' with twdbIdx ' num2str(twdbIdx)]);
disp(twdbIdxsLastThird);
end