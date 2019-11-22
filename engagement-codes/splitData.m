function split_data = splitData(Data,times)
%Splits data as many times as specified and returns a cell array with data
%split
split_data = {};
if times
    trialData_length = size(Data,1);
    numSplitTrials = ceil(trialData_length/times);
    first = 1;
    last = first+numSplitTrials-1;
    if last <= trialData_length
        split_data = [split_data {Data(first:last,:)}];
        split_data = [split_data splitData(Data(last+1:end,:),times-1)];
    else
        split_data = [split_data {Data(first:end)}];
    end
end
