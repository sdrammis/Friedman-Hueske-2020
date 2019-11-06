TWDB_FILE = '../../tmp/light_twdb_2019-08-08_spikes.mat';
OUT_FOLDER = '.';
N_ROWS = 100;

load(TWDB_FILE);
[filepath,fname,ext] = fileparts(TWDB_FILE);
outdir = [OUT_FOLDER '/' fname];
mkdir(outdir);

s_idx = 1:N_ROWS:size(twdb,1);
for ii=1:length(s_idx)
     s = s_idx(ii);
     fprintf('%d, %d', s_idx(ii), s+N_ROWS-1);
%     sub_twdb = twdb(s:s+N_ROWS-1,:);
%     sub_fname = [fname '_' num2str(ii) '.mat'];
%     
%     twdb_tmp = twdb;
%     twdb = sub_twdb;
%     save([outdir '/' sub_fname], twdb);
%     twdb = twdb_tmp;
end
