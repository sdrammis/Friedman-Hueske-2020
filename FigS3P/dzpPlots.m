function dzpPlots(twdb)
% Author: QZ
% 08/26/2019
% crossPlotsDZPDeval_UPDATE1.m
% deval part3, dzp part2

%% Part II. DZP Part 2 Update. No binning. Each Mouse is a data point.
dzpData = dzpData_UPDATE1(twdb);
upToLearned = 0;
reversal = 0;
dzp05IDs_M = twdb_lookup(twdb,'mouseID','key','intendedStriosomality','Matrix','key','injection','Diazepam',...)
'key','concentration',0.5);
[~,~,dzpMRTones,dzpMCTones,dzpMN] = get_all_trials(twdb,dzp05IDs_M,upToLearned,reversal);
[~,~,~,~,~,~,~,~,RTSaline_DZPM,RTDZP_DZPM,RTBase_DZPM,...
    CTSaline_DZPM,CTDZP_DZPM,CTBase_DZPM] = calcAndPlotDZPUPDATE2_QZ(twdb,...
    dzp05IDs_M,dzpMRTones,dzpMCTones,dzpMN,'Matrix 0.5 mg/kg',dzpData);
disp(['------>>>>>> Matrix ' num2str(0.5) ' mg/kg <<<<<<------'])
p1 = ttest_QZ(cellfun(@nanmean,CTDZP_DZPM),cell2mat(CTSaline_DZPM),'Matrix CTS DZP vs Saline: ');
p2 = ttest_QZ(cellfun(@nanmean,RTDZP_DZPM),cell2mat(RTSaline_DZPM),'Matrix RTS DZP vs Saline: ');