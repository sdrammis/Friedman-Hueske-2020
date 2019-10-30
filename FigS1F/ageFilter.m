%cohortLB is lower bound of cohort   cohortUB is upper bound of cohort
%this function filters the database for mice INDEX of the inputted age and
%populates a table with the corresponding mice informtaion
%Kaden DiMarco 6/10/19

function datafiltered = ageFilter(twdb,cohortLB, cohortUB)
% param1: twdb  the data struct
% param2: cohortLB  lower bound of age
% param3: cohortUB  upper bound of age

idx = twdb_lookup(twdb, 'index', 'grade', 'firstSessionAge', cohortLB, cohortUB);

datafiltered = twdb(cell2mat(idx));

for i = 1:length(datafiltered)
    datafiltered(i).index = i;
end
end