function [sorted, meanSorted] = sortByLevel(level,toBeSorted)

for l = 1:3
    sorted{l} = toBeSorted(level == l);
end

meanSorted = cellfun(@mean,sorted);