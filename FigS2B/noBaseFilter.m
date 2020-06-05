% Author: QZ
% 07/16/2019
function twdb = noBaseFilter(twdb)
msID = {'2660','2736','2739','2741','2743','2776','2777','2781',...
    '2782','2783','2785','2786','2788','2789','2790','2795','2802',...
    '2852'};

result = cell2mat(twdb_lookup(twdb,'index','key','mouseID',msID));
twdb(result,:) = []; % 05-02: (:,result)

for i = 1:length(twdb)
    twdb(i).index = i;
end
end