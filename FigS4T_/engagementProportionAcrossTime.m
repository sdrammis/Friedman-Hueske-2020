function [engagementProportion,ages] = engagementProportionAcrossTime(twdb,miceTrials,miceIDs,age,timeSplit)

ageCutoff = 15;
[~,miceEngagement] = miceTrialEngagement(miceTrials);

engagementProportion = [];
ages = [];
mouseCount = 1;
for m = 1:length(miceIDs)

    mouseEngagement = miceEngagement{m};
    mouseAge = first(twdb_lookup(twdb,'firstSessionAge','key','mouseID',miceIDs{m}));
    
    if isequal(age,'young') && mouseAge > ageCutoff
        continue
    elseif isequal(age,'old') && mouseAge <= ageCutoff
        continue
    end
    ages = [ages; mouseAge];
    
    bin_size = round(length(mouseEngagement)/timeSplit);
    bins = fliplr(length(mouseEngagement):-bin_size:0);
    if length(bins) < timeSplit+1
        bins = [1 bins];
    end
    for b = 1:length(bins)-1
        bin_range = bins(b)+1:bins(b+1);
        engagementProportion(mouseCount,b) = nanmean(mouseEngagement(bin_range));
    end
    mouseCount = mouseCount + 1;
end