function dzpPlots(twdb)

% Author: QZ
% 08/26/2019
% crossPlotsDZPDeval_UPDATE1.m
% deval part3, dzp part2
%% Part II. DZP Part 2 Update. No binning. Each Mouse is a data point.
dzpData = dzpData_UPDATE1(twdb);
dzpSIDs = unique(twdb_lookup(twdb,'mouseID',...
    'key','Health','WT','key','intendedStriosomality','Strio',...
    'grade','learnedFirstTask',0,inf,'key','injection','Diazepam'));
upToLearned = 0;
reversal = 0;
[dzpSTrials,dzpSFTrials,dzpSRTones,dzpSCTones,dzpSN] = get_all_trials(twdb,dzpSIDs,upToLearned,reversal);
[~,mouseIDsDZPStrio] = calcAndPlotDZPUPDATE1_QZ(twdb,dzpSIDs,...
    dzpSTrials,dzpSFTrials,dzpSRTones,dzpSCTones,dzpSN,'Strio',dzpData);
dzp1IDs = twdb_lookup(table2struct(dzpData),'mouseID','key','concentration',1);
dzp05IDs = setdiff(unique(dzpData.mouseID),dzp1IDs);
dzp05Idxs_S = cell2mat(twdb_lookup(table2struct(dzpData),'index',...
    'key','mouseID',dzp05IDs,'key','intendedStriosomality','Strio'));
dzp05Data_S = struct2table(twdb(dzp05Idxs_S));
dzp05IDs_S = unique(dzp05Data_S.mouseID);
[~,~,dzpSRTones,dzpSCTones,dzpSN] = get_all_trials(twdb,dzp05IDs_S,upToLearned,reversal);
[~,~,CSaline_DZPS,CDZP_DZPS,CBase_DZPS,~,~,~,RTSaline_DZPS,RTDZP_DZPS,RTBase_DZPS,...
    CTSaline_DZPS,CTDZP_DZPS,CTBase_DZPS,nSaline_S,nDZP_S,nBase_S] = calcAndPlotDZPUPDATE2_QZ(twdb,...
    dzp05IDs_S,dzpSRTones,dzpSCTones,dzpSN,'Strio 0.5 mg/kg',dzp05Data_S);
disp(['------>>>>>> Strio ' num2str(0.5) ' mg/kg <<<<<<------'])
p = ttest_QZ(CDZP_DZPS,CSaline_DZPS,'Strio C DZP vs Saline: ');
% ttest_QZ(cellfun(@nanmean,CTDZP_DZPS05),cellfun(@nanmean,CTSaline_DZPS05),'Strio CTS DZP vs Saline: ');
% ttest_QZ(cellfun(@nanmean,RTDZP_DZPS05),cellfun(@nanmean,RTSaline_DZPS05),'Strio RTS DZP vs Saline: ');
% table creation