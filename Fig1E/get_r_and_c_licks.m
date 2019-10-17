% Author: QZ
% 06/14/2019
function [rLicks, cLicks] = get_r_and_c_licks(data,msIdx,trialIdx1,trialIdx2)
% returns reward licks and cost licks arrays for the trial range specified
% for the mouse specified in the database specified
% mouse = data(msIdx);
tData = data(msIdx).trialData;
rewardTone = data(msIdx).rewardTone;
actualTones = tData.StimulusID(trialIdx1:trialIdx2);
licks = tData.LicksInResponse(trialIdx1:trialIdx2);
logArrayR = (actualTones == rewardTone);
logArrayC = (logArrayR == 0);
rLicks = licks(logArrayR);
cLicks = licks(logArrayC);
end