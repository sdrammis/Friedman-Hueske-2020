function [q4Trials,q4FTrials] = getLastQuarterTrials(periods,IDs,Trials,FTrials)
% from a 1x4 cell (for data for each period), extracts the first quarter of
% trials
q4Trials = cell(1,length(periods));
q4FTrials = cell(1,length(periods));
for i = 1:length(periods)
    q4Trials{i} = cell(1,length(IDs));
    q4FTrials{i} = cell(1,length(IDs));
    for j = 1:length(IDs)
        numTotTrials = height(Trials{i}{j});
        lastQCut = 3*ceil(numTotTrials/4);
        q4Trials{i}{j} = Trials{i}{j}(lastQCut:numTotTrials,:);
        q4FTrials{i}{j} = FTrials{i}{j}(lastQCut:numTotTrials,:);
    end
end
end