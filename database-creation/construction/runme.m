function runme(twdb_dirpath)
twdb_ret = [];
[~,fname,ext] = fileparts(TWDB_FILE);

ii = 1;
next_fname = [fname '_' num2str(ii) ext];
next_file = [twdb_dirpath '/' next_fname];
while exists(next_file)
    load(next_file);
    twdb_ret = [twdb_ret twdb];
    ii = ii + 1;
end

twdb = twdb_ret;
save([fname '.' ext], twdb);
end