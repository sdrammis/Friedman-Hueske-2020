function [DP,diffTA,rcTS,rTS,cTS,C,TPR,FPR,R1,P1,R2,P2,R3,P3,R4,P4] = get_dprime_traceArea_edit2QZ(allMouseTrials,...
    allMouseFluorTrials,rTones,cTones,periodName,numBins)
% really should modify to take both 470 and 405 inputs and spit out tons of
% output
% From Helper Functions
DP = cell(1,length(rTones));
diffTA = cell(1,length(rTones));
rcTS = cell(1,length(rTones));
rTS = cell(1,length(rTones));
cTS = cell(1,length(rTones));
C = cell(1,length(rTones));
TPR = cell(1,length(rTones));
FPR = cell(1,length(rTones));
R1 = zeros(1,length(rTones));
P1 = zeros(1,length(rTones));
R2 = zeros(1,length(rTones));
P2 = zeros(1,length(rTones));
R3 = zeros(1,length(rTones));
P3 = zeros(1,length(rTones));
R4 = zeros(1,length(rTones));
P4 = zeros(1,length(rTones));
for i = 1:length(rTones)
    this_mouseTrials = allMouseTrials{i};
    this_mouseFluorTrials = allMouseFluorTrials{i};
    rewardTone = rTones(i);
    costTone = cTones(i);
    numTrials = height(this_mouseTrials);
    binCuts = round(linspace(1,numTrials,numBins+1));
    this_dp = zeros(1,numBins);
    this_c = zeros(1,numBins);
    this_tpr = zeros(1,numBins);
    this_fpr = zeros(1,numBins);
    this_rts = zeros(1,numBins);
    this_cts = zeros(1,numBins);
    this_rcts = zeros(1,numBins);
    this_dta = zeros(1,numBins);
    for j = 1:numBins
        startIdx = binCuts(j);
        if j == numBins
            endIdx = binCuts(j+1);
        else
            endIdx = binCuts(j+1)-1;
        end
        mouseTrials = this_mouseTrials(startIdx:endIdx,:);
        mouseFluorTrials = this_mouseFluorTrials(startIdx:endIdx,:);
        [rewardTrials,costTrials,rewardFluorTrials,...
            costFluorTrials] = reward_and_cost_trials(mouseTrials,...
            mouseFluorTrials,rewardTone,costTone);
        if strcmp(periodName,'outcome')
            [tpr,fpr,dPrime,c] = dprime_and_c_licks(rewardTrials.OutcomeLickFrequency,...
                costTrials.OutcomeLickFrequency);
        else
            [tpr,fpr,dPrime,c] = dprime_and_c_licks(rewardTrials.ResponseLickFrequency,...
                costTrials.ResponseLickFrequency);
        end

        responseRewardTrace = nanmean(rewardFluorTrials);
        responseCostTrace = nanmean(costFluorTrials);
        differenceTraceArea = responseRewardTrace-responseCostTrace;
        rcTraceSum = responseRewardTrace+responseCostTrace;
        rewardTraceSum = responseRewardTrace;
        costTraceSum = responseCostTrace;
        
        this_dp(j) = dPrime;
        this_c(j) = c;
        this_tpr(j) = tpr;
        this_fpr(j) = fpr;
        this_rts(j) = rewardTraceSum;
        this_cts(j) = costTraceSum;
        this_rcts(j) = rcTraceSum;
        this_dta(j) = differenceTraceArea;
    end
    DP{i} = this_dp;
    C{i} = this_c;
    TPR{i} = this_tpr;
    FPR{i} = this_fpr;
    diffTA{i} = this_dta;
    rcTS{i} = this_rcts;
    rTS{i} = this_rts;
    cTS{i} = this_cts;
    [~,~,r1,p1,~,~] = corrReg(this_dp,this_dta);
    R1(i) = r1;
    P1(i) = p1;
    [~,~,r2,p2,~,~] = corrReg(this_dp,this_rcts);
    R2(i) = r2;
    P2(i) = p2;
    [~,~,r3,p3,~,~] = corrReg(this_dp,this_rts);
    R3(i) = r3;
    P3(i) = p3;
    [~,~,r4,p4,~,~] = corrReg(this_dp,this_cts);
    R4(i) = r4;
    P4(i) = p4;
end
end