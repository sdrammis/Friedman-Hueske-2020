function devalData = devalData_UPDATE1(twdb)
% 08/25/2019
% Author: QZ
% devalData_UPDATE1.m
% threshold == 1

waterIDs = twdb_lookup(twdb,'mouseID','key','devaluation','Water');
sucroseIDs = twdb_lookup(twdb,'mouseID','key','devaluation','Sucrose');
[~,uwi,~] = unique(waterIDs);
[~,usi,~] = unique(sucroseIDs);
nonUWIDs = unique(waterIDs(setdiff(1:length(waterIDs),uwi)));
nonUSIDs = unique(sucroseIDs(setdiff(1:length(sucroseIDs),usi)));
waterIDs = setdiff(waterIDs,nonUWIDs);
sucroseIDs = setdiff(sucroseIDs,nonUSIDs);
mouseIDs = intersect(waterIDs,sucroseIDs);
idxs = [cell2mat(twdb_lookup(twdb,'index','key','mouseID',mouseIDs,...
    'key','devaluation','Water')),cell2mat(twdb_lookup(twdb,'index',...
    'key','mouseID',mouseIDs,'key','devaluation','Sucrose'))];
clear waterIDs sucroseIDs uwi usi nonUWIDs nonUSIDs mouseIDs
devalData = struct2table(twdb(idxs)); % converted to table because that's what other code expects