% Author: QZ
% 06/14/2019
function [rLicks, cLicks] = get_r_and_c_licks2(data,msIdx,trialIdx1,trialIdx2)
% returns reward licks and cost licks arrays for the trial range specified
% for the mouse specified in the database specified
% THIS ONE IS FOR ENGAGEMENT. MUST HAVE APPLIED engagementFilter to get
% data input
% mouse = data(msIdx);
tData = data(msIdx).engagedTrialData;
rewardTone = data(msIdx).rewardTone;
actualTones = tData.StimulusID(trialIdx1:trialIdx2);
licks = tData.LicksInResponse(trialIdx1:trialIdx2);
logArrayR = (actualTones == rewardTone);
logArrayC = (logArrayR == 0);
rLicks = licks(logArrayR);
cLicks = licks(logArrayC);
end