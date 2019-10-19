function photometryPerAge(twdb,health,intendedStriosomality,learned,split)

%SEARCH AFTER LEARNING
%SEARCH FOR ENGAGEMENT

if split
    ageCutoff = 12;
    cellSize = 2;
else
    ageCutoff = Inf;
    cellSize = 1;
end
reversal = 0;
miceIDs = get_mouse_ids(twdb,reversal,health,learned,intendedStriosomality,'all','all',1,{});
upToLearned = 0;
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,upToLearned,reversal);
 
if learned
    learned_str = 'learned';
else
    learned_str = 'not learned';
end
title_str = [intendedStriosomality ' ' health ' ' learned_str];
 
fluorRewardTrials = cell(1,cellSize);
fluorCostTrials = cell(1,cellSize);
for m = 1:length(miceIDs)
    learningTrial = first(twdb_lookup(twdb,'learnedFirstTask','key','mouseID',miceIDs{m}));
    mouseTrials = miceTrials{m};
    mouseFluorTrials = miceFluorTrials{m};
    rewardTone = rewardTones(m);
    costTone = costTones(m);
    mouseAge = first(twdb_lookup(twdb,'firstSessionAge','key','mouseID',miceIDs{m}));
    ageIdx = (mouseAge > ageCutoff) + 1;
    [~,~,rewardFluorTrials,costFluorTrials] = reward_and_cost_trials(mouseTrials,mouseFluorTrials,rewardTone,costTone);
    fluorRewardTrials{ageIdx} = [fluorRewardTrials{ageIdx}; get_dist_stats(rewardFluorTrials)];
    fluorCostTrials{ageIdx} = [fluorCostTrials{ageIdx}; get_dist_stats(costFluorTrials)];
     
end

if split
    ageStr = {'Young (age<13)','Old (age>=13)'};
else
    ageStr = {'All Ages'};
end

figure('units','normalized','outerposition',[0 0 1 1])
for n = 1:length(fluorRewardTrials)
    subplot(length(fluorRewardTrials),1,n)
    fluor_rewardTrials = fluorRewardTrials{n};
    xReward = (1:size(fluor_rewardTrials,2));
    [mReward, lowCLReward, highCLReward] = get_dist_stats(fluor_rewardTrials);
    dg_plotShadeCL(gca, [xReward' lowCLReward' highCLReward' mReward'], 'Color', [0 0 1]);
    hold on;
    fluor_costTrials = fluorCostTrials{n};
    xCost = (1:size(fluor_costTrials,2));
    [mCost, lowCLCost, highCLCost] = get_dist_stats(fluor_costTrials);
    dg_plotShadeCL(gca, [xCost' lowCLCost' highCLCost' mCost'], 'Color', [1 0 0]);
    hold on;
     
    yLim = ylim;
    textY = yLim(1) + abs(yLim(1) / 10);
    hold on;
    plot([22.72 22.72], ylim, 'k', 'LineWidth',3);
    hold on;
    text(27.72, textY, 'T');
    hold on;
    plot([38.87 38.87], ylim, 'k', 'LineWidth',3);
    hold on;
    text(40.72, textY, 'R');
    hold on;
    plot([46.44 46.44], ylim, 'k', 'LineWidth',3);
    hold on;
    text(51.72, textY, 'O & ITI');
    title([ageStr{n},' n = ',num2str(size(fluor_rewardTrials,1))])
     
end
supertitle({title_str,'',''})