% Create the analysisdb
% This database stores the cv output data for easy analysis.

dbpath = 'pipeline-db.json';
analysisdb = create(dbpath);
analysisdb = inj_pvmsnconn(analysisdb, 'pvmsn_conn_v3_060419.csv');
analysisdb = inj_msnspines(analysisdb, dbpath, 'msnspines_data_071619_14-45.csv');
save('./analysisdb.mat', 'analysisdb', '-v7.3');
