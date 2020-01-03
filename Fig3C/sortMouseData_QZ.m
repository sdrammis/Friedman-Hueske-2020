% Author: QZ
% 07/10/2019
function sorted = sortMouseData_QZ(mouseData)
% sorts all session data for one mouse.
% mouseData :: a table of all data in twdb for 1 individual mouse,
% session-level
numSessions = height(mouseData);
% disp(numSessions)
firstTask = [];
reversalTask = [];
for i = 1:numSessions
%     disp(['------' num2str(i) '------'])
    row = table2struct(mouseData(i,:));
    if strcmp(row.taskType,row.firstSessionType)
        firstTask = [firstTask,row];
%         disp(size(firstTask))
    else
        reversalTask = [reversalTask,row];
%         disp(size(reversalTask))
    end
end
% disp('------------------------------')
fTask = struct2table(firstTask);
sorted1 = sortrows(fTask,'sessionNumber');
if isempty(reversalTask)
    sorted = sorted1;
elseif length(reversalTask) == 1 % choose to ignore if only 1 reversal session
%     disp([mouseData.mouseID{1} 'has only 1 reversal session'])
    rTask = struct2table(reversalTask,'AsArray',true);
    sorted2 = sortrows(rTask,'sessionNumber');
    sorted = [sorted1;sorted2];
else
    rTask = struct2table(reversalTask);
    sorted2 = sortrows(rTask,'sessionNumber');
    sorted = [sorted1;sorted2];
end
end