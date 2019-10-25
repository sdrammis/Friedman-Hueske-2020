function [reward,cost,area,ages] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,age,title_str,engagement,statType,normalized,xType)

ageCutoff = 12;

if ~isempty(age)
    age_str = [' ' age];
else
    age_str = age;
end

ages = [];
reward = [];
cost = [];
area = [];
mice = {};
for m = 1:length(miceIDs)
    
%     if  ~isequal('No Dreadd',first(twdb_lookup(twdb,'DREADDType','key','mouseID',miceIDs{m})))
%         continue
%     end
    
    mouseTrials = miceTrials{m};
    mouseFluorTrials = miceFluorTrials{m};
    rewardTone = rewardTones(m);
    costTone = costTones(m);
    
    mouseAge = first(twdb_lookup(twdb,'firstSessionAge','key','mouseID',miceIDs{m}));
    
    if isequal(age,'young') && mouseAge > ageCutoff
        continue
    elseif isequal(age,'old') && mouseAge <= ageCutoff
        continue
    end
    ages = [ages; mouseAge];
    [area_slope,area_R,area_Pval,reward_slope,reward_R,reward_Pval,cost_slope,cost_R,cost_Pval] = dPrimeCorrelations([title_str age_str],miceIDs{m},mouseTrials,mouseFluorTrials,rewardTone,costTone,engagement,xType);
    
    if isequal(statType,'slope')
        if normalized
            reward = [reward; abs(reward_slope)];
            cost = [cost; abs(cost_slope)];
            area = [area; abs(area_slope)];
        else
            reward = [reward; reward_slope];
            cost = [cost; cost_slope];
            area = [area; area_slope];
        end
    elseif isequal(statType,'R')
        if normalized
            reward = [reward; reward_R^2];
            cost = [cost; cost_R^2];
            area = [area; area_R^2];
        else
            reward = [reward; reward_R];
            cost = [cost; cost_R];
            area = [area; area_R];
        end
    elseif isequal(statType,'p-value')
            reward = [reward; reward_Pval];
            cost = [cost; cost_Pval];
            area = [area; area_Pval];
    end
    
    mice = [mice; miceIDs{m}];
    
end
end