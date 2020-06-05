function [q1Trials,q1FTrials] = getFirstQuarterTrials(periods,IDs,Trials,FTrials)
% from a 1x4 cell (for data for each period), extracts the first quarter of
% trials
q1Trials = cell(1,length(periods));
q1FTrials = cell(1,length(periods));
for i = 1:length(periods)
    q1Trials{i} = cell(1,length(IDs));
    q1FTrials{i} = cell(1,length(IDs));
    for j = 1:length(IDs)
        numTotTrials = height(Trials{i}{j});
        firstQCut = ceil(numTotTrials/4);
        q1Trials{i}{j} = Trials{i}{j}(1:firstQCut,:);
        q1FTrials{i}{j} = FTrials{i}{j}(1:firstQCut,:);
    end
end
end