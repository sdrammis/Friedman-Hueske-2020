% Create the analysisdb
% This database stores the cv output data for easy analysis.

STRIO_PATH = './data/strio-data_190604.csv';
MATRIX_PATH = './data/matrix-data_190604.csv';

dbpath = 'pipeline-db.json';
analysisdb = create(dbpath);
analysisdb = inj_pvmsnconn(analysisdb, 'pvmsn_conn_v3_060419.csv');
analysisdb = inj_msnspines(analysisdb, dbpath, 'msnspines_data_071619_14-45.csv');
analysisdb = inj_densitiescc(analysisdb, 'msndenscc-data_190624_130346.csv');

save('./analysisdb.mat', 'analysisdb', '-v7.3');
