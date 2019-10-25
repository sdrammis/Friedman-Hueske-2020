% Author: QZ
% 06/26/2019
function [conc,dp,c,rTA,txtDP,txtC,fittedX1,fittedY1,fittedX2,fittedY2,cor1,cor2,m1,m2] = calcPlotDZPCorrCandDP_QZ(twdb,msID,threshold,trialType,binSize)
% twdb :: database to be used
% msID :: e.g. {'4199'}; cell array of SINGLE mouse ID, string
% threshold :: integer (1,2, or 3)
% trialType :: e.g. 'Diazepam','Saline Before','Saline After'
% binSize :: integer, hopefully <100
% dp, c, rTA ::  arrays of d-prime, c, and rewardTracesArea
[miceTrials,miceFluorTrials,rewardTone,costTone,...
    ~] = get_all_trials(twdb,msID,trialType);
bins1 = binTrial_QZ(binSize,miceTrials{1});
bins2 = binTrial_QZ(binSize,miceFluorTrials{1});
if strcmp(trialType,'Diazepam')
    conc = first(twdb_lookup(twdb,'concentration','key','mouseID',msID,...
        'key','injection',trialType));
else
    conc = '?';
end
dp = zeros(1,length(bins1));
c = zeros(1,length(bins1));
rTA = zeros(1,length(bins1));
for i = 1:length(bins1)
    mTrials = bins1{i};
    mFTrials = bins2{i};
    [dPrime,responseTraceArea,~,~,C] = get_dprime_traceArea(mTrials,mFTrials,rewardTone,costTone,threshold);
    dp(i) = dPrime;
    rTA(i) = responseTraceArea;
    c(i) = C;
end
[fittedX1,fittedY1,cor1,pval1,m1,~] = corrReg(dp,rTA);
[fittedX2,fittedY2,cor2,pval2,m2,~] = corrReg(c,rTA);
txtDP = ['r=' num2str(cor1) '; pval=' num2str(pval1) '; m1=' num2str(m1)];
txtC = ['r=' num2str(cor2) '; pval=' num2str(pval2) '; m2=' num2str(m2)];
end