% Author: QZ
% 06/25/2019
function threshold = get_DZP_C_Threshold_QZ(conc,msID,dzp)
% msID :: cell array of a single string e.g. {'4199'}
idxs = find(strcmp([dzp.mouseID{:}],msID));
idx = idxs(end)/3;
[~,thresholds,~,~,~] = optLickThresholdC(conc,dzp);
threshold = thresholds(idx);
end