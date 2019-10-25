% Author: QZ
% 06/10/2019
% CAN MODIFY THRESHOLD FOR TRIAL SELECTION!!!
function twdb = calcStats(twdb)
% Calculates reward and cost lick rates, TPR, FPR, DP, C for "Start" and
% "After", determined by the cutoffs. (Can manually modify, may add params
% later)
% determine cut-offs
numMice = length(twdb);
% beginning sessions
start = cell(1,numMice);
% post-learning sessions
after = cell(1,numMice);
for i = 1:numMice
    mouse = twdb(i);
    learnTrial = mouse.learnedFirstTask;
    numTrials = height(mouse.trialData);
    if learnTrial >= 400
        start{i} = [1,200];
        after{i} = [learnTrial-199,learnTrial];
    elseif learnTrial >= 300 % [300,399] - 150 trials per
        start{i} = [1,150];
        after{i} = [learnTrial-149,learnTrial];
    elseif learnTrial >= 200 % [200,299] - 100 trials per
        start{i} = [1,100];
        after{i} = [learnTrial-99,learnTrial];
    elseif learnTrial >= 1 % [1,199] - shouldn't be applicable, but here anyway
        start{i} = [1,ceil(learnTrial/2)];
        after{i} = [ceil(learnTrial/2),learnTrial]; % overlaps by the middle trial
    else % -1, doesn't learn
        after{i} = [NaN,NaN];
        if numTrials >= 200
            start{i} = [1,200];
        elseif numTrials >= 150
            start{i} = [1,150];
        elseif numTrials >= 100
            start{i} = [1,100];
        else
            start{i} = [1,numTrials];
        end
    end
end
% add start and after to learn struct - manually checked
[twdb(:).Start] = start{:};
[twdb(:).After] = after{:};
%% Actual calculations
% stats for before trials
rLicksStart = cell(1,numMice);
cLicksStart = cell(1,numMice);
tprStart = cell(1,numMice);
fprStart = cell(1,numMice);
dpStart = cell(1,numMice);
cStart = cell(1,numMice);
% stats for after trials
rLicksAfter = cell(1,numMice);
cLicksAfter = cell(1,numMice);
tprAfter = cell(1,numMice);
fprAfter = cell(1,numMice);
dpAfter = cell(1,numMice);
cAfter = cell(1,numMice);
for i = 1:numMice
    mouse = twdb(i);
    tones = mouse.trialData.StimulusID;
    licks = mouse.trialData.ResponseLickFrequency; % 05-02: LicksInResponse
    lFTask = mouse.learnedFirstTask;
    rewardTone = mouse.rewardTone;
    startMarkers = mouse.Start;
    startStart = startMarkers(1);
    startEnd = startMarkers(2);
    rLicks1 = [];
    cLicks1 = [];
    % start session stats
    for j = startStart:startEnd
        if tones(j) == rewardTone
            rLicks1 = [rLicks1 licks(j)];
        else
            cLicks1 = [cLicks1 licks(j)];
        end
    end
    % start of conditional
    if lFTask ~= -1
        afterMarkers = mouse.After;
        afterStart = afterMarkers(1);
        afterEnd = afterMarkers(2);
        rLicks2 = [];
        cLicks2 = [];
        % after session stats
        for k = afterStart:afterEnd
            if tones(k) == rewardTone
                rLicks2 = [rLicks2 licks(k)];
            else
                cLicks2 = [cLicks2 licks(k)];
            end
        end
        [tpr2,fpr2,dp2,c2] = dprime_and_c_licks(rLicks2,cLicks2);
        tprAfter{i} = tpr2;
        fprAfter{i} = fpr2;
        dpAfter{i} = dp2;
        cAfter{i} = c2;
        rLicksAfter{i} = mean(rLicks2);
        cLicksAfter{i} = mean(cLicks2);
    else % mouse doesn't learn
        tprAfter{i} = NaN;
        fprAfter{i} = NaN;
        dpAfter{i} = NaN;
        cAfter{i} = NaN;
        rLicksAfter{i} = NaN;
        cLicksAfter{i} = NaN;
    end
    % end of conditional
    [tpr1,fpr1,dp1,c1] = dprime_and_c_licks(rLicks1,cLicks1);
    tprStart{i} = tpr1;
    fprStart{i} = fpr1;
    dpStart{i} = dp1;
    cStart{i} = c1;
    rLicksStart{i} = mean(rLicks1);
    cLicksStart{i} = mean(cLicks1);
end % end of for loop
[twdb(:).RewardLicksAfter] = rLicksAfter{:};
[twdb(:).CostLicksAfter] = cLicksAfter{:};
[twdb(:).TPRAfter] = tprAfter{:};
[twdb(:).FPRAfter] = fprAfter{:};
[twdb(:).DPAfter] = dpAfter{:};
[twdb(:).CAfter] = cAfter{:};
%
[twdb(:).RewardLicksStart] = rLicksStart{:};
[twdb(:).CostLicksStart] = cLicksStart{:};
[twdb(:).TPRStart] = tprStart{:};
[twdb(:).FPRStart] = fprStart{:};
[twdb(:).DPStart] = dpStart{:};
[twdb(:).CStart] = cStart{:};
end