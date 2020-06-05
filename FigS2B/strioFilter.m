% QZ
% 05/13/2020
function filteredData = strioFilter(twdb,input)
idx = twdb_lookup(twdb,'index','key','intendedStriosomality',input);
filteredData = twdb(cell2mat(idx));
for i = 1:length(filteredData)
    filteredData(i).index = i;
end
end