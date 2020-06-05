% Author: QZ
% 06/13/2019
% Can only do this for learning mice! (for now)
function twdb = calcStats2(twdb)
% twdb  a structure of mouse data, of twdb format

% automatically filters for learning mice. Do not remove. Will break code.
twdb = LearnedFilter(twdb,true);
numMice = length(twdb);
% Calculations
tprEarly = cell(1,numMice);
tprMid = cell(1,numMice);
tprLate = cell(1,numMice);
tprLast3 = cell(1,numMice);
fprEarly = cell(1,numMice);
fprMid = cell(1,numMice);
fprLate = cell(1,numMice);
fprLast3 = cell(1,numMice);
dEarly = cell(1,numMice);
dMid = cell(1,numMice);
dLate = cell(1,numMice);
dLast3 = cell(1,numMice);
cEarly = cell(1,numMice);
cMid = cell(1,numMice);
cLate = cell(1,numMice);
cLast3 = cell(1,numMice);
for i = 1:numMice
    mouse = twdb(i);
    tones = mouse.trialData.StimulusID;
    licks = mouse.trialData.LicksInResponse;
    lFTask = mouse.learnedFirstTask;
    rewardTone = mouse.rewardTone;
    earlyStart = 1;
    earlyEnd = floor(lFTask/3);
    midStart = earlyEnd + 1;
    midEnd = floor(2*lFTask/3);
    lateStart = midEnd + 1;
    lateEnd = lFTask;
    last3Start = lFTask - 49;
    last3End = lFTask;
    rLicks1 = [];
    cLicks1 = [];
    rLicks2 = [];
    cLicks2 = [];
    rLicks3 = [];
    cLicks3 = [];
    rLicks4 = [];
    cLicks4 = [];
    % early
    for j = earlyStart:earlyEnd
        if tones(j) == rewardTone
            rLicks1 = [rLicks1 licks(j)];
        else
            cLicks1 = [cLicks1 licks(j)];
        end
    end
    [tpr1,fpr1,dp1,c1] = dprime_and_c_licks(rLicks1,cLicks1);
    tprEarly{i} = tpr1;
    fprEarly{i} = fpr1;
    dEarly{i} = dp1;
    cEarly{i} = c1;
    % mid
    for j = midStart:midEnd
        if tones(j) == rewardTone
            rLicks2 = [rLicks2 licks(j)];
        else
            cLicks2 = [cLicks2 licks(j)];
        end
    end
    [tpr2,fpr2,dp2,c2] = dprime_and_c_licks(rLicks2,cLicks2);
    tprMid{i} = tpr2;
    fprMid{i} = fpr2;
    dMid{i} = dp2;
    cMid{i} = c2;
    % late
    for j = lateStart:lateEnd
        if tones(j) == rewardTone
            rLicks3 = [rLicks3 licks(j)];
        else
            cLicks3 = [cLicks3 licks(j)];
        end
    end
    [tpr3,fpr3,dp3,c3] = dprime_and_c_licks(rLicks3,cLicks3);
    tprLate{i} = tpr3;
    fprLate{i} = fpr3;
    dLate{i} = dp3;
    cLate{i} = c3;
    % last 3
    for j = last3Start:last3End
        if tones(j) == rewardTone
            rLicks4 = [rLicks4 licks(j)];
        else
            cLicks4 = [cLicks4 licks(j)];
        end
    end
    [tpr4,fpr4,dp4,c4] = dprime_and_c_licks(rLicks4,cLicks4);
    tprLast3{i} = tpr4;
    fprLast3{i} = fpr4;
    dLast3{i} = dp4;
    cLast3{i} = c4;
end
[twdb(:).TPREarly] = tprEarly{:};
[twdb(:).TPRMid] = tprMid{:};
[twdb(:).TPRLate] = tprLate{:};
[twdb(:).TPRLast3] = tprLast3{:};
[twdb(:).FPREarly] = fprEarly{:};
[twdb(:).FPRMid] = fprMid{:};
[twdb(:).FPRLate] = fprLate{:};
[twdb(:).FPRLast3] = fprLast3{:};
[twdb(:).DEarly] = dEarly{:};
[twdb(:).DMid] = dMid{:};
[twdb(:).DLate] = dLate{:};
[twdb(:).DLast3] = dLast3{:};
[twdb(:).CEarly] = cEarly{:};
[twdb(:).CMid] = cMid{:};
[twdb(:).CLate] = cLate{:};
[twdb(:).CLast3] = cLast3{:};
end