% Author: QZ
% 07/06/2019
function [baselineSessionNum,twdbEndIdx,twdbIdxsLastThird] = getBaselineSessionNum_QZ(twdb,msID,lastProp,outOf)
% get sessionNum where the mouse learns.
rows = twdb_lookup(twdb,'index','key','mouseID',msID);
mouseData = twdb(cell2mat(rows));
sorted = sortMouseData_QZ(struct2table(mouseData));
sortedData = table2struct(sorted);
learnedTrial = mouseData(1).learnedFirstTask;
fTType = first(sorted.firstSessionType);
% disp(fTType)
trials = 0;
if learnedTrial == -1
    disp('Non-learning')
    sortedTable = struct2table(sortedData);
    firstTaskIdxs = find(strcmp(sortedTable.taskType,sortedTable.firstSessionType));
    fTLastId = firstTaskIdxs(end);
%     disp(['First and Base Task Same: ' num2str(strcmp(sortedData(fTLastId).taskType,sortedData(1).taskType))]);
    baselineSessionNum = sortedData(fTLastId).sessionNumber;
    twdbEndIdx = sortedData(fTLastId).index;
%     disp(ceil(fTLastId*(outOf-lastProp)/outOf)+1);
    lastThirdSessionNum = sortedData(ceil(fTLastId*(outOf-lastProp)/outOf)+1).sessionNumber;
    twdbIdxsLastThird = cell2mat(twdb_lookup(twdb,'index',...
        'key','mouseID',msID,'key','taskType',fTType,...
        'grade','sessionNumber',lastThirdSessionNum,baselineSessionNum));
else
    for i = 1:length(sortedData)
        session = sortedData(i);
        if isa(session.trialData,'table')
            numTrials = height(session.trialData);
%             trials = trials + height(session.trialData);
        else
            numTrials = length(session.trialData);
%             trials = trials + length(session.trialData);
        end
        trials = trials + numTrials;
        if trials >= learnedTrial
            baselineSessionNum = session.sessionNumber;
            twdbEndIdx = session.index;
                if baselineSessionNum < (outOf + 1)
                    twdbIdxsLastThird = twdbEndIdx; % baseline index
                else
                    lastThirdSessionNum = sortedData(ceil((outOf-lastProp)*i/outOf)+1).sessionNumber;
        %             disp(['Last third sessionNum: ' num2str(ceil((outOf-lastProp)*i/outOf)+1)]);
                    twdbIdxsLastThird = cell2mat(twdb_lookup(twdb,'index',...
                        'key','mouseID',msID,'key','taskType',fTType,...
                        'grade','sessionNumber',lastThirdSessionNum,baselineSessionNum));
                end
            break;
        end
    end
end
disp(['Baseline session for ' first(msID) ' is ' ...
    num2str(baselineSessionNum) ' with twdbIdx ' num2str(twdbEndIdx)]);
disp(twdbIdxsLastThird);
end