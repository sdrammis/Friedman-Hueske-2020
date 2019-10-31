function [mean_rz,mean_cz,RTS,CTS,R_R,P_R,R_C,P_C,R,P] = calcZRespLicks2_QZ(mouseIDs,miceTrials,miceFTrials,rTones,cTones,binSize)
% means = zeros(1,length(mouseIDs));
% sds = zeros(1,length(mouseIDs));
mean_rz = [];
mean_cz = [];
RTS = [];
CTS = [];
R_R = [];
P_R = [];
R_C = [];
P_C = [];
R = [];
P = [];
for i = 1:length(mouseIDs)
    disp(['------' num2str(i) ': ' mouseIDs{i} '------'])
    mouseTrials = miceTrials{i};
    mouseFTrials = miceFTrials{i};
    rTone = rTones(i);
    cTone = cTones(i);
    thisMouseMean = nanmean(mouseTrials.ResponseLickFrequency);
    thisMouseSD = nanstd(mouseTrials.ResponseLickFrequency);
%     means(i) = thisMouseMean;
%     sds(i) = thisMouseSD;
    binCuts = round(linspace(1,height(mouseTrials),ceil(height(mouseTrials)/binSize)));
    thisMouseRZ = [];
    thisMouseCZ = [];
    thisMouseRTS = [];
    thisMouseCTS = [];
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
        [~,~,rts,cts,~,~,~] = get_dprime_traceArea(thisBinTrials,thisBinFTrials,rTone,cTone);
        if isnan(rts) || isnan(cts)
            continue;
        end
        thisBinRTrials = thisBinTrials(thisBinTrials.StimulusID == rTone,:);
        thisBinCTrials = thisBinTrials(thisBinTrials.StimulusID == cTone,:);
        thisBinRZ = nanmean((thisBinRTrials.ResponseLickFrequency-thisMouseMean)/thisMouseSD);
        thisBinCZ = nanmean((thisBinCTrials.ResponseLickFrequency-thisMouseMean)/thisMouseSD);
        thisMouseRZ(end+1) = thisBinRZ;
        thisMouseCZ(end+1) = thisBinCZ;
        thisMouseRTS(end+1) = rts;
        thisMouseCTS(end+1) = cts;
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
%     mean_rz{i} = thisMouseRZ;
%     mean_cz{i} = thisMouseCZ;
%     RTS{i} = thisMouseRTS;
%     CTS{i} = thisMouseCTS;
    mean_rz = [mean_rz thisMouseRZ];
    mean_cz = [mean_cz thisMouseCZ];
    RTS = [RTS thisMouseRTS];
    CTS = [CTS thisMouseCTS];
    if any(thisMouseRZ == 0) || any(thisMouseCZ == 0) || any(thisMouseRTS == 0) || ...
            any(thisMouseCTS == 0)
        disp('WARNING!')
        disp(thisMouseRZ == 0);
        disp(thisMouseCZ == 0);
        disp(thisMouseRTS == 0);
        disp(thisMouseCTS == 0);
    end
end
end