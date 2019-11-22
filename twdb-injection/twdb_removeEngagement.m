function twdb = twdb_removeEngagement(twdb)

for n = 1:length(twdb)
    trialData = twdb(n).trialData;
    if ~isempty(trialData) && sum(strcmp('Engagement',trialData.Properties.VariableNames))
        trialData.Engagement = [];
        twdb(n).trialData = trialData;
    end
end