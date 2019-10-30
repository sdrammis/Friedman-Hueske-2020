function [e_zscores_tone1,n_zscores_tone1,e_zscores_tone2, n_zscores_tone2]...
    = correlateEngagementPupilSize_session(trialData,fieldname)

if isequal(fieldname,'Response')
    fieldname = 'ResponsePupilZScore';
elseif isequal(fieldname,'Outcome')
    fieldname = 'OutcomePupilZScore';
else
    fieldname = 'PupilZScore';
end
%Tone 1
tone1 = trialData.StimulusID == 1;
trialData_tone1 = trialData(tone1,:);

engagement_tone1 = trialData_tone1.Engagement;
pupilZscores_tone1 = table2array(trialData_tone1(:,fieldname));
e_zscores_tone1 = nanmean(pupilZscores_tone1(engagement_tone1==1));
n_zscores_tone1 = nanmean(pupilZscores_tone1(engagement_tone1==0));

%Tone 2
tone2 = trialData.StimulusID == 2;
trialData_tone2 = trialData(tone2,:);

engagement_tone2 = trialData_tone2.Engagement;
pupilZscores_tone2 = table2array(trialData_tone2(:,fieldname));
e_zscores_tone2 = nanmean(pupilZscores_tone2(engagement_tone2==1));
n_zscores_tone2 = nanmean(pupilZscores_tone2(engagement_tone2==0));