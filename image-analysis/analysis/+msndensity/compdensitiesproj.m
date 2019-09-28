IMAGES_PATH = '/annex4/afried/resultfiles/FINAL_EXPORTED_IMAGES';
STRIO_MASKS_PATH = '/annex4/afried/resultfiles/system-tree/strio_analysis/done';
MSN_CELLS_PATH = '/annex4/afried/resultfiles/system-tree/msn_cell_body_detection/done';
DATABASE_PATH = '/annex4/afried/resultfiles/system-tree/db.json';
OUT_DIR = '/annex4/afried/resultfiles/analysis_output/msn_density/msn_density_proj';
EXPS_TO_RUN = {'exp1', 'exp2', 'exp3', 'exp4', 'exp5', 'exp6'};

load('./dbs/micedb.mat');
addpath(genpath('./utils'));
addpath(genpath('./lib'));

% Find slices to run on, must have strio masks.
fileObjs = dir([STRIO_MASKS_PATH '/*-done.txt']);
if isempty(fileObjs)
    return;
end

datefmt = 'YYmmdd_HHMMSS';
outFileStrio = [OUT_DIR '/strio-data_' datestr(datetime('now'), datefmt)  '.txt'];
outFileMatrix = [OUT_DIR '/matrix-data_' datestr(datetime('now'), datefmt)  '.txt'];
fileStrioID = fopen(outFileStrio, 'a');
fileMatrixID = fopen(outFileMatrix, 'a');

exids = erase({fileObjs.name}, '-done.txt');
for iExids=1:length(exids)
    exid = exids{iExids};
    
    % Only run on MSN cell dectection experiments
    if ~contains(exid, EXPS_TO_RUN)
        continue;
    end
    
    expr = utils.findexp(DATABASE_PATH, exid);
    slce = utils.findslice(DATABASE_PATH, exid);
    mouse = utils.findmouse(micedb, exid);
    if isempty(mouse)
        continue;
    end
    striosomality = mouse.intendedStriosomality;
    
    try
        % Compute strio mask.
        fprintf(['EXID ' exid ': Computing strio masks. \n']);
        imgStrio = [IMAGES_PATH '/' expr '/' slce '_strio.tiff'];
        masksStrio = [STRIO_MASKS_PATH '/' exid '-masks.mat'];
        thrshStrio = [STRIO_MASKS_PATH '/' exid '-threshs.json'];
        [strio, matrix] = utils.compstriomasks(imgStrio, masksStrio, thrshStrio, 2);
    catch
        fprintf(['ERROR! EXID ' exid ': Could not compute strio masks. \n']);
        continue;
    end
    
    msnpath = [MSN_CELLS_PATH '/' exid '-data.mat'];
    if ~isfile(msnpath)
        fprintf(['EXID ' exid ' : MSN cells not found. \n']);
        continue;
    end
    
    fprintf(['EXID ' exid ' : Computing densities... \n']);
    % Load MSN cell bodies and label
    msn = load(msnpath);
    [cellsStrio, cellsMatrix] = msndensity.labelcells(msn.cells, strio, matrix, striosomality);
    
    % Compute densities
    [strioTL, strioTM, strioTR, strioBL, strioBM, strioBR] = ...
        utils.split_quadrants6(strio);
    [matrixTL, matrixTM, matrixTR, matrixBL, matrixBM, matrixBR] = ...
        utils.split_quadrants6(matrix);
    [cellsStrioTL, cellsStrioTM, cellsStrioTR, cellsStrioBL, cellsStrioBM, cellsStrioBR] = ...
        utils.split_quadrants6(cellsStrio);
    [cellsMatrixTL, cellsMatrixTM, cellsMatrixTR, cellsMatrixBL, cellsMatrixBM, cellsMatrixBR] = ...
        utils.split_quadrants6(cellsMatrix);
    
    [nStrioAll, aStrioAll] = compdensity(cellsStrio, strio);
    [nMatrixAll, aMatrixAll] = compdensity(cellsMatrix, matrix);
    
    [nStrioTL, aStrioTL] = compdensity(cellsStrioTL, strioTL);
    [nStrioTM, aStrioTM] = compdensity(cellsStrioTM, strioTM);
    [nStrioTR, aStrioTR] = compdensity(cellsStrioTR, strioTR);
    [nStrioBL, aStrioBL] = compdensity(cellsStrioBL, strioBL);
    [nStrioBM, aStrioBM] = compdensity(cellsStrioBM, strioBM);
    [nStrioBR, aStrioBR] = compdensity(cellsStrioBR, strioBR);
    
    [nMatrixTL, aMatrixTL] = compdensity(cellsMatrixTL, matrixTL);
    [nMatrixTM, aMatrixTM] = compdensity(cellsMatrixTM, matrixTM);
    [nMatrixTR, aMatrixTR] = compdensity(cellsMatrixTR, matrixTR);
    [nMatrixBL, aMatrixBL] = compdensity(cellsMatrixBL, matrixBL);
    [nMatrixBM, aMatrixBM] = compdensity(cellsMatrixBM, matrixBM);
    [nMatrixBR, aMatrixBR] = compdensity(cellsMatrixBR, matrixBR);
    
    fprintf(fileStrioID, ...
        '%s, %s, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d \n', ...
        mouse.ID, slce, ...
        nStrioAll, nStrioTL, nStrioTM, nStrioTR, nStrioBL, nStrioBM, nStrioBR, ...
        aStrioAll, aStrioTL, aStrioTM, aStrioTR, aStrioBL, aStrioBM, aStrioBR);
    fprintf(fileMatrixID, ...
        '%s, %s, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d \n', ...
        mouse.ID, slce, ...
        nMatrixAll, nMatrixTL, nMatrixTM, nMatrixTR, nMatrixBL, nMatrixBM, nMatrixBR, ...
        aMatrixAll, aMatrixTL, aMatrixTM, aMatrixTR, aMatrixBL, aMatrixBM, aMatrixBR);
end

function [nCells, aMask] = compdensity(cells, mask)
cc = bwconncomp(cells);
nCells = cc.NumObjects;
aMask = sum(mask(:));
end
