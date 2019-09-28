function s = config(env)
if strcmp(env, 'local')
    s.DATA_DIR_DONE = '/Volumes/annex4/afried/resultfiles/system-tree/msn_dendrites_spines_detection/done';
    s.DATA_DIR_MANUAL = '/Volumes/annex4/afried/resultfiles/system-tree/msn_dendrites_spines_detection/manual';
    s.OUT_DIR = '/Users/drammis/workspace/striomatrix-cv/analysis/tmp';
    s.IMGS_DIR = '/Volumes/annex4/afried/resultfiles/FINAL_EXPORTED_IMAGES';
    s.DB_PATH = '/Volumes/annex4/afried/resultfiles/system-tree/db.json';
    s.DIMS_PATH = './dbs/dimensions.mat';
    s.MSK_GEN_PTH = '/Users/drammis/workspace/striomatrix-cv/analysis/+msnspines/+v2/makeMask.js';
    s.MASK_TMP_DIR = '/Users/drammis/workspace/striomatrix-cv/analysis/tmp/spines_masks';
    s.NODE_PTH = ':/Users/drammis/.nvm/versions/node/v8.12.0/bin/';
elseif strcmp(env, 'prod')
    s.DATA_DIR_DONE = '/annex4/afried/resultfiles/system-tree/msn_dendrites_spines_detection/done';
    s.DATA_DIR_MANUAL = '/annex4/afried/resultfiles/system-tree/msn_dendrites_spines_detection/manual';
    s.OUT_DIR = '/annex4/afried/resultfiles/analysis_output/msn_dends_spinesv2';
    s.IMGS_DIR = '/annex4/afried/resultfiles/FINAL_EXPORTED_IMAGES';
    s.DB_PATH = '/annex4/afried/resultfiles/system-tree/db.json';
    s.DIMS_PATH = './dbs/dimensions.mat';
    s.MSK_GEN_PTH = './+msnspines/+v2/makeMask.js';
    s.MASK_TMP_DIR = '/annex4/afried/resultfiles/analysis_output/tmp/msn_dends_spines_v2';
    s.NODE_PTH = ':/home/drammis/.nvm/versions/node/v10.12.0/bin/node';
end
end