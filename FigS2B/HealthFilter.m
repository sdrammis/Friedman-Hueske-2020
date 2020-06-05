%filters miced based off of genotype provided by user, WT or HD
%Kaden DiMarco 6/10/19

function datafiltered = HealthFilter(twdb,genotype)

idx = twdb_lookup(twdb, 'index', 'key', 'Health', genotype);

datafiltered = twdb(cell2mat(idx));

for i = 1:length(datafiltered)
    datafiltered(i).index = i;
end
end