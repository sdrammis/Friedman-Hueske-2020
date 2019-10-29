function mouseIDs = getMiceAttemptReversal_QZ(twdb,mouseIDs)
% Author: QZ
% 08/19/2019
% gets mice that attempt both tasks
deleteIdxs = [];
for i = 1:length(mouseIDs)
    msID = mouseIDs{i};
    if length(unique({twdb(cell2mat(twdb_lookup(twdb,'index','key','mouseID',msID))).taskType})) <= 1
        deleteIdxs = [deleteIdxs i];
    end
end
mouseIDs(deleteIdxs) = [];
end