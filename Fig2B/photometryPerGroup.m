function [reward,cost,area,ages] = photometryPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,age,engagement)

ageCutoff = 12;

ages = [];
reward = [];
cost = [];
area = [];

for m = 1:length(miceIDs)
    
    mouseTrials = miceTrials{m};
    mouseFluorTrials = miceFluorTrials{m};
    rewardTone = rewardTones(m);
    costTone = costTones(m);
    
    if ~isequal('all',engagement)
        mouseFluorTrials = mouseFluorTrials(mouseTrials.Engagement == engagement,:);
        mouseTrials = mouseTrials(mouseTrials.Engagement == engagement,:);
    end
    
    mouseAge = first(twdb_lookup(twdb,'firstSessionAge','key','mouseID',miceIDs{m}));
    
    if isequal(age,'young') && mouseAge > ageCutoff
        continue
    elseif isequal(age,'old') && mouseAge <= ageCutoff
        continue
    end
    ages = [ages; mouseAge];
    
    [~,responseTraceArea,responseRewardTraceSum,responseCostTraceSum] = get_dprime_traceArea(mouseTrials,mouseFluorTrials,rewardTone,costTone);
    
    reward = [reward; responseRewardTraceSum];
    cost = [cost; responseCostTraceSum];
    area = [area; responseTraceArea];
    
end