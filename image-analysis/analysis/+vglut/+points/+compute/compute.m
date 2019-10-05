DATA_PATH = '//chunky.mit.edu/annex4/afried/resultfiles/analysis_output/vglut_kian/detection_data/Grade_5';
STRIO_PATH = '//chunky.mit.edu/annex4/afried/resultfiles/system-tree/strio_analysis/done';
IMGS_PATH = '//chunky.mit.edu/annex4/afried/resultfiles/FINAL_EXPORTED_IMAGES';

addpath(genpath('./lib'));
load('./dbs/dimensions.mat');
excsM = utils.dbload('./dbs/db.json');
for iExc=1:length(excsM)
    excsM(iExc).slice = lower(excsM(iExc).slice);
end

load('./dbs/vglutregions.mat');

dirContents = dir(DATA_PATH);
files = {dirContents(:).name};
for iFile=17:length(files)
    filename = files{iFile};
    if length(filename) < 4 || ~strcmp(filename(end-3:end), '.csv')
        continue;
    end

    fprintf('Progress %d/%d...\n', iFile, length(files));
    
    slicename = lower(strrep(filename, '_vglut.csv', ''));
    idx = twdb_lookup(excsM, 'index', 'key', 'slice', lower(slicename));
    if isempty(idx)
       fprintf('No execution found for slice %s !! \n', slicename); 
    end
    idx = idx{1};
    
    experiment = excsM(idx).experiment;
    exid = excsM(idx).exid;

    vglutImgPth = [IMGS_PATH '/' experiment '/' slicename '_vglut.tiff'];
    vglutDataPth = [DATA_PATH '/' filename];
    strioImgPth = [IMGS_PATH '/' experiment '/' slicename '_strio.tiff'];
    strioMsksPth = [STRIO_PATH '/' exid '-masks.mat'];
    strioThrshsPth = [STRIO_PATH '/' exid '-threshs.json'];

    if ~(exist(strioMsksPth, 'file') == 2)
	fprintf('No strio masks found for slice %s.\n', slicename);
        continue;
    end
    
    % Get the image pixel size.
    w = dimensions.width(lower(dimensions.slice) == slicename);
    h = dimensions.height(lower(dimensions.slice) == slicename);
    realsize = w * h;
    
    vglutregionNames = lower(strrep(vglutregions.Name, '_vglut.tiff', ''));
    region = vglutregions(vglutregionNames == slicename,:);
    coords = [region.X1 region.Y1 region.X2 region.Y2];
    
    fprintf('Running analysis on slice %s...\n', slicename);
    [s, t, u] = vglut.points.compute.imcompute(coords, vglutImgPth, vglutDataPth, strioImgPth, strioMsksPth, strioThrshsPth, realsize);
    vglut.points.compute.saveoutput(micedb, slicename, s, u, t)
end
