%this script filters out emilys mice and updates the database
%Kaden DiMarco 6/10/19

function twdb = EmilyPhotometryFilter(twdb)
msid = {'2802', '2852', '2776', '2781', '2782', '2785', '2786', '2789', ...
    '2790', '2777', '2736', '2739', '2741', '2743' };

result = [];

for i = 1:length(msid)
    idx = twdb_lookup(twdb,'index','key','mouseID',msid{i}); % 05-02: 'ID', not 'mouseID'
    result = [result, cell2mat(idx)];
end
twdb(:,result) = [];

for i = 1:length(twdb)
    twdb(i).index = i;
end
end