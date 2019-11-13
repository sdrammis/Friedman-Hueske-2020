TWDB_FILE = '../../tmp/light_twdb_2019-08-08_spikes.mat';
OUT_FOLDER = '.';
N_ROWS = 1000;

% load(TWDB_FILE);
[filepath,fname,ext] = fileparts(TWDB_FILE);
outdir = [OUT_FOLDER '/' fname];
mkdir(outdir);

n = size(twdb,2);
s_idx = 1:N_ROWS:n;
for ii=1:length(s_idx)
    s = s_idx(ii);
    t = min(s+N_ROWS-1,n);
    fprintf('%d, %d\n', s_idx(ii), t);
    
    twdb_sub = twdb(s:t);
    save([outdir '/' fname '_' num2str(ii) '.mat'], 'twdb_sub');
end
