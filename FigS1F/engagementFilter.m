%% Behavioral Data Visualization - Filter for Engagement
% Author: QZ
% 06/10/2019
% engagementFilter.mat
function twdb = engagementFilter(twdb)
%% Gets indices of animals that don't have engagement data and remove
tbRemoved = [];
for i = 1:length(twdb)
    td = twdb(i).trialData;
    if  size(td,2) == 9
        tbRemoved = [tbRemoved i];
    end
end
twdb(:,tbRemoved) = [];
% reset indices
for i = 1:length(twdb)
    twdb(i).index = i;
end
%% Creates new field with only data for engaged trials
% better to loop twice than to needlessly also loop through trials that
% will all be deleted anyway
engagedTrialData = cell(1,length(twdb));
ep = cell(1,length(twdb));
for i = 1:length(twdb)
    td = twdb(i).trialData;
    engagement = td.Engagement;
    engagedTrials = td(engagement==1,:);
    engagedTrialData{i} = engagedTrials;
    ep{i} = height(engagedTrials)/height(td);
end
% adds field to twdb
[twdb.engagedTrialData] = engagedTrialData{:};
[twdb.engagementProportion] = ep{:};
end