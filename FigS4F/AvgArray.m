%Kaden DiMarco 6/28/19
%Calculated mean of each element in cell array

function AveragedArray = AvgArray(InputArray)

AveragedArray = [];

for i=1:length(InputArray)
    AveragedArray(i) = mean(InputArray{i});
end
end
