function reconstruct_twdb(twdb_dirpath)
twdb = [];
[~,fname,ext] = fileparts(twdb_dirpath);

ii = 1;
next_file = [twdb_dirpath '/' fname '_' num2str(ii) ext '.mat'];
while exist(next_file, 'file') == 2
    fprintf('Working on file %s...\n', next_file);
    load(next_file);
    twdb = [twdb twdb_sub];
    ii = ii + 1;
    next_file = [twdb_dirpath '/' fname '_' num2str(ii) ext '.mat'];
end

save([fname '.mat'], 'twdb', '-v7.3');
end