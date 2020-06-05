function engagementRewardTrialPDF(twdb,mouseID)

[miceTrials,rewardTones,costTones] = get_mouse_trials(twdb,{mouseID},0,0);


mouseTrials = miceTrials{1};
rewardTone = rewardTones(1);
costTone = costTones(1);

rewardTrials = reward_and_cost_trials(mouseTrials,[],rewardTone,costTone);
rewardLicks = rewardTrials.ResponseLickFrequency;

engagedLicks = rewardLicks(rewardTrials.Engagement == 1);
notEngagedLicks = rewardLicks(rewardTrials.Engagement == 0);

engagedPDF = histcounts(engagedLicks,0:max(engagedLicks))/length(engagedLicks);
notEngagedPDF = histcounts(notEngagedLicks,0:max(notEngagedLicks))/length(notEngagedLicks);


figure
subplot(1,2,1)
bar(engagedPDF,'g')
ylim([0 1])
xlabel('Licks')
title('Engaged Trials')
subplot(1,2,2)
bar(notEngagedPDF,'r')
ylim([0 1])
xlabel('Licks')
title('Not Engaged Trials')
supertitle({'Reward Trial Response Period PDF',mouseID,'',''})
