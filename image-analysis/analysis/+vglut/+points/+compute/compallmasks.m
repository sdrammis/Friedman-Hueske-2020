DATA_PATH = 'F:/vglut_points_output/data';
STRIO_PATH = '//chunky.mit.edu/annex4/afried/resultfiles/system-tree/strio_analysis/done';
IMGS_PATH = '//chunky.mit.edu/annex4/afried/resultfiles/FINAL_EXPORTED_IMAGES';
OUT_DIR = 'F:/vglut_points_output/masks';

addpath(genpath('./lib'));
load('./dbs/dimensions.mat');
excsM = utils.dbload('./dbs/db.json');
for iExc=1:length(excsM)
    excsM(iExc).slice = lower(excsM(iExc).slice);
end

load('./dbs/vglutregions.mat');

dirContents = dir(DATA_PATH);
files = {dirContents(:).name};
%for iFile=1:length(files)
for iFile=118
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
    if contains(exid, 'exp')
        stain = 1;
    else 
        stain = 2;
    end
        
    
    vglutImgPth = [IMGS_PATH '/' experiment '/' slicename '_vglut.tiff'];
    vglutDataPth = [DATA_PATH '/' filename];
    strioImgPth = [IMGS_PATH '/' experiment '/' slicename '_strio.tiff'];
    strioMsksPth = [STRIO_PATH '/' exid '-masks.mat'];
    strioThrshsPth = [STRIO_PATH '/' exid '-threshs.json'];
    
    % Get the image pixel size.
    w = dimensions.width(lower(dimensions.slice) == slicename);
    h = dimensions.height(lower(dimensions.slice) == slicename);
    if isempty(w) || isempty(h)
        fprintf('Could not find realsie for exid %s!!! \n', exid);
        continue;
    end
    realsize = w * h;
    
    vglutregionNames = lower(strrep(vglutregions.Name, '_vglut.tiff', ''));
    region = vglutregions(vglutregionNames == slicename,:);
    coords = [region.X1 region.Y1 region.X2 region.Y2];
    
    % Construct strio masks.
%     try
        if stain == 2
            [striomsk, matrixmsk, f] = vglut.points.compute.compstriomasks(...
                strioImgPth, vglutImgPth, strioMsksPth, strioThrshsPth, realsize);
            sgtitle(sprintf('iFile = %d', iFile));
            saveas(f, [OUT_DIR '/' exid '.png']);
            close all;
        else
            [strio, matrix, f1, f2] = utils.compstriomasks(...
                strioImgPth, strioMsksPth, strioThrshsPth, realsize);
            saveas(f1, [OUT_DIR '/' exid '-strio-iFile-' num2str(iFile) '.png']);
            saveas(f2, [OUT_DIR '/' exid '-matrix-iFile-' num2str(iFile) '.png']);
            close all;
        end
%     catch
%         f = figure; 
%         text(0.5,0.5,'FAILED!');
%         sgtitle(sprintf('iFile = %d', iFile));
%         saveas(f, [OUT_DIR '/' exid '.png']);
%         close all;
%     end
end