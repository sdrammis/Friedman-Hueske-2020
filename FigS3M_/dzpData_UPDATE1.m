function dzpData = dzpData_UPDATE1(twdb)

% Author: QZ
% 08/25/2019
% dzpData_UPDATE1.m
% threshold == 1

dzpIDs = twdb_lookup(twdb,'mouseID','key','injection','Diazepam');
idxs = [];
for id = dzpIDs
    sessionNum = cell2mat(twdb_lookup(twdb,'sessionNumber','key','mouseID',id,...
        'key','injection','Diazepam'));
    dzpIdx = cell2mat(twdb_lookup(twdb,'index','key','mouseID',id,...
        'key','injection','Diazepam'));
    sal1Idx = cell2mat(twdb_lookup(twdb,'index','key','mouseID',id,...
        'key','injection','Saline','key','sessionNumber',sessionNum-1));
    sal2Idx = cell2mat(twdb_lookup(twdb,'index','key','mouseID',id,...
        'key','injection','Saline','key','sessionNumber',sessionNum+1));
    idxs = [idxs sal1Idx dzpIdx sal2Idx];
end
dzpData = struct2table(twdb(idxs));
