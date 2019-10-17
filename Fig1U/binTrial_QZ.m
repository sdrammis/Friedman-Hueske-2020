% Author: QZ
% 06/24/2019
function bins = binTrial_QZ(n,trialData)
% bins :: cell array of tables of binned trial data
% n :: number of trials in each bin
% trialData :: a single **table** of trial data

numTrials = size(trialData,1);
numBins = ceil(numTrials/n);
bins = cell(1,numBins);
start = 1;
for i = 1:numBins
    bins{i} = trialData(start:(start+n-1),:);
    start = start + n;
    if (numTrials - start + 1) <= n
        bins{i+1} = trialData(start:numTrials,:);
        break
    end
end
end