function twdb = twdb_removeRow(twdb,rows)

twdb(rows) = [];

for i = 1:length(twdb)
    twdb(i).index = i;
end

twdb = correctSessionNumbers(twdb);