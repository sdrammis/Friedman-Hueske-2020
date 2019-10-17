% Author: QZ
% 07/01/2019
function plotBarTPRFPRDZP_QZ(msID,dzp,threshold,plotRow,plotCol,sPID,striosomality)
% msID :: e.g. {'4199'}. Single string in single cell
% conc :: concentration of DZP injection for that mouse
% threshold :: lick threshold determined by get_DZP_C_Threshold_QZ
% sPID :: subplot starting ID. E.g., if starting from the first subplot,
% sPID = 1
[tpr,fpr,c,dp,lrr,lrc,dzpTPR,dzpFPR,dzpC,dzpDP,dzpLRR,...
    dzpLRC] = calcMeanSaline_DZP_QZ(dzp,msID,threshold);
% title1 = ['Mouse ' first(msID) ', ' striosomality ', threshold=' ...
%     num2str(threshold) ', Ratio (DZP:Mean Saline)='];
title1 = [first(msID) ', thres.=' num2str(threshold) ', Ratio(DZP:Saline)='];
subplot(plotRow,plotCol,sPID) % TPR
hold on
ylim([0,1]);
plotBar({tpr,dzpTPR},'TPR',{'Mean Saline','DZP'},[title1 num2str(dzpTPR/tpr)])
hold off

subplot(plotRow,plotCol,sPID+1) % FPR
hold on
ylim([0,1]);
plotBar({fpr,dzpFPR},'FPR',{'Mean Saline','DZP'},[title1 num2str(dzpFPR/fpr)])
hold off

subplot(plotRow,plotCol,sPID+2) % LRr
hold on
plotBar({lrr,dzpLRR},'LRR',{'Mean Saline','DZP'},[title1 num2str(dzpLRR/lrr)])
hold off

subplot(plotRow,plotCol,sPID+3) % LRc
hold on
plotBar({lrc,dzpLRC},'LRC',{'Mean Saline','DZP'},[title1 num2str(dzpLRC/lrc)])
hold off

subplot(plotRow,plotCol,sPID+4) % LRr*TPR
hold on
plotBar({lrr*tpr,dzpLRR*dzpTPR},'LRR*TPR',{'Mean Saline','DZP'},[title1 num2str(dzpLRR*dzpTPR/lrr/tpr)])
hold off

subplot(plotRow,plotCol,sPID+5) % LRc*FPR
hold on
plotBar({lrc*fpr,dzpLRC*dzpFPR},'LRC*FPR',{'Mean Saline','DZP'},[title1 num2str(dzpLRC*dzpFPR/lrc/fpr)])
hold off

subplot(plotRow,plotCol,sPID+6) % c
hold on
plotBar({c,dzpC},'C',{'Mean Saline','DZP'},[title1 num2str(dzpC/c)])
hold off

subplot(plotRow,plotCol,sPID+7) % dp
hold on
plotBar({dp,dzpDP},'DP',{'Mean Saline','DZP'},[title1 num2str(dzpDP/dp)])
hold off
end