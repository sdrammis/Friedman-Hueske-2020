% Author: QZ
% 06/26/2019
function binSize = DZP_Binning_QZ(twdb,msID,trialTypes,threshold)
% msID :: cell array of a single string e.g. {'4199'}
% trialTypes :: e.g. {'Saline Before','Diazepam','Saline After'}
% threshold :: integer of lick threshold (1,2,3)
binSize = 15;
maxCorr = -1;
for size = 15:45
    % optimized for average r for dp. If for c, beware of negative
    corr = zeros(1,length(trialTypes));
    for j = 1:length(trialTypes)
        [~,~,~,~,~,~,~,~,~,~,cor1,~,~,...
            ~] = calcPlotDZPCorrCandDP_QZ(twdb,msID,threshold,trialTypes{j},size);
        corr(j) = cor1;
    end
    if sum(isnan(corr)) == 0
        thisCorr = mean(corr);
        if thisCorr > maxCorr
            maxCorr = thisCorr;
            binSize = size;
        end
    end
end
end