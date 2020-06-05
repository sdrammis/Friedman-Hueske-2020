function [miceEngagementPercentages,miceEngagement] = miceTrialEngagement(miceTrials)

miceEngagementPercentages = nan(1,length(miceTrials));
miceEngagement = cell(1,length(miceTrials));
for m = 1:length(miceTrials)
    mouseTrials = miceTrials{m};
    engagementColumn = strcmp('Engagement',mouseTrials.Properties.VariableNames); 
    if sum(engagementColumn)
        mouseEngagement = mouseTrials.Engagement;
        miceEngagementPercentages(m) = mean(mouseEngagement);
        miceEngagement{m} = mouseEngagement;
    end
end