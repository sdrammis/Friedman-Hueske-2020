%this function filters mice that are learned or not learned. If you are
%looking for learned mice, input true.
%Kaden DiMarco 6/10/19

function datafiltered = LearnedFilter(twdb,input)

if input == false
    idx = twdb_lookup(twdb, 'index', 'key', 'learnedFirstTask', -1);
elseif input == true
    idx = twdb_lookup(twdb, 'index', 'grade', 'learnedFirstTask', 0, inf);
end

datafiltered = twdb(cell2mat(idx));

for i = 1:length(datafiltered)
    datafiltered(i).index = i;
end
end