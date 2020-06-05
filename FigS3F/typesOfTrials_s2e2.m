function [engaged, not_engaged, Ts, Es] = typesOfTrials_s2e2(twdb, mouseID, threshold, estimate_T,estimate_E, changept,include_deevaluate)
symbols = {'S',  'H'};
tone = 1;
mouseTrials = [];

if include_deevaluate 
    sessions_idx = get_mouse_sessions(twdb,mouseID,1,1,'all',0);
else
    sessions_idx = get_mouse_sessions(twdb,mouseID,1,0,'all',0);
end

for idx = sessions_idx

        sessionNumber = twdb_lookup(twdb, 'sessionNumber', 'key', 'index', idx(1));
        trialData = twdb(idx(1)).trialData;
    if ~isempty(trialData)
        trialData.IDXofTrial = [1:height(trialData)]';
        trialData.SessionNumber = sessionNumber{1}*ones(1,height(trialData))';
        if sum(strcmp('Engagement',trialData.Properties.VariableNames))
            trialData.Engagement = [];
        end
        mouseTrials = [mouseTrials; trialData];
    end
end
tone1Trials = mouseTrials([mouseTrials.StimulusID] == tone, :);
numTrials = size(tone1Trials, 1);

%numWindows = max(round(numTrials/window_size), 1);
%splitTrials = splitData(mouseTrials,numWindows);
numWindows = length(changept)+1;
if length(changept) == 0 
    numWindows = 1;
    splitTrials = cell(1,1);
    splitTrials{1,1} = mouseTrials;
end
if length(changept) == 1
    splitTrials = cell(2,1);
    splitTrials{1,1} = head(mouseTrials,changept);
    splitTrials{2,1} = tail(mouseTrials,height(mouseTrials)-changept);
end
if length(changept) == 2
    splitTrials = cell(3,1);
    splitTrials{1,1} = mouseTrials(1:changept(1),:);
    splitTrials{2,1} = mouseTrials(changept(1):changept(2),:);
    splitTrials{3,1} = mouseTrials(changept(2):end,:);
end
if length(changept) == 3
    splitTrials = cell(4,1);
    splitTrials{1,1} = mouseTrials(1:changept(1),:);
    splitTrials{2,1} = mouseTrials(changept(1):changept(2),:);
    splitTrials{3,1} = mouseTrials(changept(2):changept(3),:);
    splitTrials{4,1} = mouseTrials(changept(3):end,:);
end
if length(changept) == 4
    splitTrials = cell(5,1);
    splitTrials{1,1} = mouseTrials(1:changept(1),:);
    splitTrials{2,1} = mouseTrials(changept(1):changept(2),:);
    splitTrials{3,1} = mouseTrials(changept(2):changept(3),:);
    splitTrials{4,1} = mouseTrials(changept(3):changept(4),:);
    splitTrials{5,1} = mouseTrials(changept(4):end,:);

end


engaged = cell(1,numWindows);
not_engaged = cell(1,numWindows);
BICs = cell(1,numWindows);
Ts = cell(1,numWindows);
Es = cell(1,numWindows);
for n = 1:numWindows
    training_set = splitTrials{n};
    training_set = training_set([training_set.StimulusID] == tone, :);
    [Ts{n}, Es{n}] = HMM_train(training_set, estimate_T{n}, estimate_E{n}, threshold, symbols, false);
    %[~, BICs{n}] = aicbic(loglikes(end), 8, size(training_set, 1));
    [ states ] = HMM_decode(training_set, Ts{n}, Es{n}, threshold, symbols, false );
    [eTrials, nTrials] = splitByStates2(splitTrials{n}, states);
    engaged{n} =  eTrials;
    not_engaged{n} = nTrials;
end