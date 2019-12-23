function [CSaline_DZPS,CDZP_DZPS,CBase_DZPS,DSaline_DZPS,DDZP_DZPS,DBase_DZPS,...
    RTSaline_DZPS,RTDZP_DZPS,RTBase_DZPS,CTSaline_DZPS,CTDZP_DZPS,CTBase_DZPS,...
    CSaline_DZPM,CDZP_DZPM,CBase_DZPM,DSaline_DZPM,DDZP_DZPM,DBase_DZPM,...
    RTSaline_DZPM,RTDZP_DZPM,RTBase_DZPM,CTSaline_DZPM,CTDZP_DZPM,...
    CTBase_DZPM] = masterFunc_UPDATE2_QZ(twdb,dzpSIDs,dzpMIDs,conc,dzpData)
upToLearned = 0;
reversal = 0;
[~,~,dzpSRTones,dzpSCTones,dzpSN] = get_all_trials(twdb,dzpSIDs,upToLearned,reversal);
[~,~,dzpMRTones,dzpMCTones,dzpMN] = get_all_trials(twdb,dzpMIDs,upToLearned,reversal);
[~,~,CSaline_DZPS,CDZP_DZPS,CBase_DZPS,DSaline_DZPS,DDZP_DZPS,DBase_DZPS,...
    RTSaline_DZPS,RTDZP_DZPS,RTBase_DZPS,CTSaline_DZPS,CTDZP_DZPS,CTBase_DZPS] = calcAndPlotDZPUPDATE2_QZ(twdb,...
    dzpSIDs,dzpSRTones,dzpSCTones,dzpSN,['Strio ' num2str(conc) ' mg/kg'],dzpData);
[~,~,CSaline_DZPM,CDZP_DZPM,CBase_DZPM,DSaline_DZPM,DDZP_DZPM,DBase_DZPM,...
    RTSaline_DZPM,RTDZP_DZPM,RTBase_DZPM,CTSaline_DZPM,CTDZP_DZPM,CTBase_DZPM] = calcAndPlotDZPUPDATE2_QZ(twdb,...
    dzpMIDs,dzpMRTones,dzpMCTones,dzpMN,['Matrix ' num2str(conc) ' mg/kg'],dzpData);
disp(['------>>>>>> Strio ' num2str(conc) ' mg/kg <<<<<<------'])
% ttest_QZ(CDZP_DZPS,CSaline_DZPS,'Strio C DZP vs Saline: ');
% ttest_QZ(DDZP_DZPS,DSaline_DZPS,'Strio DP DZP vs Saline: ');
% ttest_QZ(cellfun(@nanmean,CTDZP_DZPS),cell2mat(CTSaline_DZPS),'Strio CTS DZP vs Saline: ');
% ttest_QZ(cellfun(@nanmean,RTDZP_DZPS),cell2mat(RTSaline_DZPS),'Strio RTS DZP vs Saline: ');
% ttest_QZ(CDZP_DZPS,CBase_DZPS,'Strio C DZP vs Base: ');
% ttest_QZ(CSaline_DZPS,CBase_DZPS,'Strio C Saline vs Base: ');
% ttest_QZ([CDZP_DZPS CSaline_DZPS],[CBase_DZPS CBase_DZPS],'Strio C DZP&Saline vs Base: ');
% ttest_QZ(DDZP_DZPS,DBase_DZPS,'Strio DP DZP vs Base: ');
% ttest_QZ(DSaline_DZPS,DBase_DZPS,'Strio DP Saline vs Base: ');
% ttest_QZ([DDZP_DZPS DSaline_DZPS],[DBase_DZPS DBase_DZPS],'Strio DP DZP&Saline vs Base: ');
% ttest_QZ(cellfun(@nanmean,CTDZP_DZPS),cellfun(@nanmean,CTBase_DZPS),'Strio CTS DZP vs Base: ');
% ttest_QZ(cellfun(@nanmean,CTSaline_DZPS),cellfun(@nanmean,CTBase_DZPS),'Strio CTS Saline vs Base: ');
% ttest_QZ([cellfun(@nanmean,CTDZP_DZPS) cellfun(@nanmean,CTSaline_DZPS)],...
%     [cellfun(@nanmean,CTBase_DZPS) cellfun(@nanmean,CTBase_DZPS)],'Strio CTS DZP&Saline vs Base: ');
% ttest_QZ(cellfun(@nanmean,RTDZP_DZPS),cellfun(@nanmean,RTBase_DZPS),'Strio RTS DZP vs Base: ');
% ttest_QZ(cellfun(@nanmean,RTSaline_DZPS),cellfun(@nanmean,RTBase_DZPS),'Strio RTS Saline vs Base: ');
% ttest_QZ([cellfun(@nanmean,RTDZP_DZPS) cellfun(@nanmean,RTSaline_DZPS)],...
%     [cellfun(@nanmean,RTBase_DZPS) cellfun(@nanmean,RTBase_DZPS)],'Strio RTS DZP&Saline vs Base: ');
disp(['------>>>>>> Matrix ' num2str(conc) ' mg/kg <<<<<<------'])
% ttest_QZ(CDZP_DZPM,CSaline_DZPM,'Matrix C DZP vs Saline: ');
% ttest_QZ(DDZP_DZPM,DSaline_DZPM,'Matrix DP DZP vs Saline: ');
% ttest_QZ(cellfun(@nanmean,CTDZP_DZPM),cell2mat(CTSaline_DZPM),'Matrix CTS DZP vs Saline: ');
% ttest_QZ(cellfun(@nanmean,RTDZP_DZPM),cell2mat(RTSaline_DZPM),'Matrix RTS DZP vs Saline: ');
% ttest_QZ(CDZP_DZPM,CBase_DZPM,'Matrix C DZP vs Base: ');
% ttest_QZ(CSaline_DZPM,CBase_DZPM,'Matrix C Saline vs Base: ');
% ttest_QZ([CDZP_DZPM CSaline_DZPM],[CBase_DZPM CBase_DZPM],'Matrix C DZP&Saline vs Base: ');
% ttest_QZ(DDZP_DZPM,DBase_DZPM,'Matrix DP DZP vs Base: ');
% ttest_QZ(DSaline_DZPM,DBase_DZPM,'Matrix DP Saline vs Base: ');
% ttest_QZ([DDZP_DZPM DSaline_DZPM],[DBase_DZPM DBase_DZPM],'Matrix DP DZP&Saline vs Base: ');
% ttest_QZ(cellfun(@nanmean,CTDZP_DZPM),cellfun(@nanmean,CTBase_DZPM),'Matrix CTS DZP vs Base: ');
% ttest_QZ(cellfun(@nanmean,CTSaline_DZPM),cellfun(@nanmean,CTBase_DZPM),'Matrix CTS Saline vs Base: ');
% ttest_QZ([cellfun(@nanmean,CTDZP_DZPM) cellfun(@nanmean,CTSaline_DZPM)],...
%     [cellfun(@nanmean,CTBase_DZPM) cellfun(@nanmean,CTBase_DZPM)],'Matrix CTS DZP&Saline vs Base: ');
% ttest_QZ(cellfun(@nanmean,RTDZP_DZPM),cellfun(@nanmean,RTBase_DZPM),'Matrix RTS DZP vs Base: ');
% ttest_QZ(cellfun(@nanmean,RTSaline_DZPM),cellfun(@nanmean,RTBase_DZPM),'Matrix RTS Saline vs Base: ');
% ttest_QZ([cellfun(@nanmean,RTDZP_DZPM) cellfun(@nanmean,RTSaline_DZPM)],...
%     [cellfun(@nanmean,RTBase_DZPM) cellfun(@nanmean,RTBase_DZPM)],'Matrix RTS DZP&Saline vs Base: ');
end