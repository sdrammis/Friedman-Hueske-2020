function [mean_rz,mean_cz,bin_dp,RTS,CTS,RTA,R_R,P_R,R_C,P_C,R,P,DP_R,DP_P] = calcBTPeriods_QZ(mouseIDs,miceTrials,miceFTrials,rTones,cTones,binSize)
% Author: QZ
% 08/16/2019
mean_rz = [];
mean_cz = [];
bin_dp = [];
RTS = [];
CTS = [];
RTA = [];
R_R = [];
P_R = [];
R_C = [];
P_C = [];
R = [];
P = [];
DP_R = [];
DP_P = [];
for i = 1:length(mouseIDs)
    mouseTrials = miceTrials{i};
    mouseFTrials = miceFTrials{i};
    rTone = rTones(i);
    cTone = cTones(i);
    thisMouseMean = nanmean(mouseTrials.ResponseLickFrequency);
    thisMouseSD = nanstd(mouseTrials.ResponseLickFrequency);
    binCuts = round(linspace(1,height(mouseTrials),ceil(height(mouseTrials)/binSize)));
    thisMouseRZ = [];
    thisMouseCZ = [];
    thisMouseDP = [];
    thisMouseRTS = [];
    thisMouseCTS = [];
    thisMouseRTA = [];
    for j = 2:length(binCuts)
        startIdx = binCuts(j-1);
        if j == length(binCuts)
            endIdx = binCuts(j);
        else
            endIdx = binCuts(j)-1;
        end
        thisBinTrials = mouseTrials(startIdx:endIdx,:);
        thisBinFTrials = mouseFTrials(startIdx:endIdx,:);
        % separate reward and cost
        [dp,rta,rts,cts,~,~,~] = get_dprime_traceArea_edit3QZ(thisBinTrials,thisBinFTrials,rTone,cTone);
        if isnan(rts) || isnan(cts) || isnan(rta)
            continue;
        end
        thisBinRTrials = thisBinTrials(thisBinTrials.StimulusID == rTone,:);
        thisBinCTrials = thisBinTrials(thisBinTrials.StimulusID == cTone,:);
        thisBinRZ = nanmean((thisBinRTrials.ResponseLickFrequency-thisMouseMean)/thisMouseSD);
        thisBinCZ = nanmean((thisBinCTrials.ResponseLickFrequency-thisMouseMean)/thisMouseSD);
        thisMouseRZ(end+1) = thisBinRZ;
        thisMouseCZ(end+1) = thisBinCZ;
        thisMouseDP(end+1) = dp;
        thisMouseRTS(end+1) = rts;
        thisMouseCTS(end+1) = cts;
        thisMouseRTA(end+1) = rta;
    end
    [~,~,r_r,p_r,~,~] = corrReg(thisMouseRZ,thisMouseRTS);
    [~,~,r_c,p_c,~,~] = corrReg(thisMouseCZ,thisMouseCTS);
    R_R = [R_R r_r];
    P_R = [P_R p_r];
    R_C = [R_C r_c];
    P_C = [P_C p_c];
    [~,~,r,p,~,~] = corrReg([thisMouseRZ thisMouseCZ],[thisMouseRTS thisMouseCTS]);
    R = [R r];
    P = [P p];
    [~,~,dp_r,dp_p,~,~] = corrReg(thisMouseDP,thisMouseRTS-thisMouseCTS); % R-C vs. d'
    DP_R = [DP_R dp_r];
    DP_P = [DP_P dp_p];
    mean_rz = [mean_rz thisMouseRZ];
    mean_cz = [mean_cz thisMouseCZ];
    bin_dp = [bin_dp thisMouseDP];
    RTS = [RTS thisMouseRTS];
    CTS = [CTS thisMouseCTS];
    RTA = [RTA thisMouseRTA];
    if any(thisMouseRZ == 0) || any(thisMouseCZ == 0) || any(thisMouseRTS == 0) || ...
            any(thisMouseCTS == 0) || any(thisMouseDP == 0) || any(thisMouseRTA == 0)
        disp('WARNING!')
        disp(thisMouseRZ == 0);
        disp(thisMouseCZ == 0);
        disp(thisMouseDP == 0);
        disp(thisMouseRTS == 0);
        disp(thisMouseCTS == 0);
        disp(thisMouseRTA == 0);
    end
end
end