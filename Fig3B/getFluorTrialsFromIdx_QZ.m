function fluorTrials = getFluorTrialsFromIdx_QZ(twdb,msID,idx,trialData)
% Author: QZ
% 08/26/2019
fluorTrials = [];
[sessFluorTrials] = get_session_fluorescence_sta(twdb,msID,idx,'all',false);
if isempty(sessFluorTrials)
    fluorTrials = [fluorTrials; nan(height(trialData),98)];
else
    sessFluorAll = get_session_fluorescence_sta(twdb,msID,idx,'all',true);
    numSessionTrials = size(sessFluorTrials, 1);
    for i=1:numSessionTrials
        zSessFluor = zscore_baseline(sessFluorTrials(i,:),sessFluorAll);
        fluorTrials = [fluorTrials; zSessFluor];
    end
end
end
function ret = zscore_baseline(data, base)
    m = mean(base);
    s = std(base);
    ret = arrayfun(@(x) (x - m) / s, data);
end