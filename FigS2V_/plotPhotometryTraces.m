function plotPhotometryTraces(fluor_rewardTrials,fluor_costTrials)

xReward = (1:size(fluor_rewardTrials,2));
[mReward, lowCLReward, highCLReward] = get_dist_stats(fluor_rewardTrials);
dg_plotShadeCL(gca, [xReward' lowCLReward' highCLReward' mReward'], 'Color', [0 0 1]);
hold on;
xCost = (1:size(fluor_costTrials,2));
[mCost, lowCLCost, highCLCost] = get_dist_stats(fluor_costTrials);
dg_plotShadeCL(gca, [xCost' lowCLCost' highCLCost' mCost'], 'Color', [1 0 0]);
hold on;

plot(1:98,ones(1,98)*0.5,'k--')
plot(1:98,ones(1,98)*0,'k--')
plot(1:98,ones(1,98)*-0.5,'k--')

ylim([-1 1])
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
