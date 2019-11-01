function [sortedPerMouse,meanSortedPerMouse] = responseToTrial_perMouse(twdb,...
    taskReversal,mouseID,trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse)

sessions = get_mouse_sessions(twdb,mouseID,~taskReversal,0,wantedSessions,reverse);

sortedPerMouse = {};

for ses = 1:length(sessions)
    trialData = twdb(sessions(ses)).trialData;
    [trialNTone_idx,level] = outcome_level(trialData,trialNTone);
    if ~isempty(trialNTone_idx)
        if Nplus == 1 && trialNTone_idx(end) == height(trialData)
            trialNTone_idx(end) = [];
            level(end) = [];
        end
        [mouseResponse,responding_idx] = responseToTrial(trialData,...
            trialNTone_idx,trialNplusTone,Nplus,responseField);

        [sorted, meanSorted] = sortByLevel(level(responding_idx),mouseResponse);

        sortedPerMouse = [sortedPerMouse; sorted];
        meanSortedPerMouse(ses,1:3) = meanSorted;
    else
        sortedPerMouse = [sortedPerMouse; {[],[],[]}];
        meanSortedPerMouse(ses,1:3) = nan(1,3);
    end
end