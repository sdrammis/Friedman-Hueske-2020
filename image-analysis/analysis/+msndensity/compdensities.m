CELL_LABELS_PATH = '/Volumes/annex4/afried/resultfiles/analysis_output/msn_density/msn_density_v2/labeled_cells';
OUT_DIR = '/Volumes/annex4/afried/resultfiles/analysis_output/msn_density/msn_density_v2';

datefmt = 'YYmmdd_HHMMSS';
outFileStrio = [OUT_DIR '/strio-data_' datestr(datetime('now'), datefmt)  '.txt'];
outFileMatrix = [OUT_DIR '/matrix-data_' datestr(datetime('now'), datefmt)  '.txt'];
fileStrioID = fopen(outFileStrio, 'a');
fileMatrixID = fopen(outFileMatrix, 'a');

fileObjs = dir(CELL_LABELS_PATH);
nFiles = length(fileObjs);
for iFiles=1:nFiles
    filename = fileObjs(iFiles).name;
    if any(strcmp(filename(1), {'.', '@'}))
        continue;
    end
    
    data = load([CELL_LABELS_PATH '/' filename]);
    
    splits = strsplit(filename, '_');
    mouseID = splits{2};
    slce = splits{3};
    stck = splits{end}(1:end-4);
    
    [strioTL, strioTM, strioTR, strioBL, strioBM, strioBR] = ...
        utils.split_quadrants6(data.strio);
    [matrixTL, matrixTM, matrixTR, matrixBL, matrixBM, matrixBR] = ...
        utils.split_quadrants6(data.matrix);
    [cellsStrioTL, cellsStrioTM, cellsStrioTR, cellsStrioBL, cellsStrioBM, cellsStrioBR] = ...
        utils.split_quadrants6(data.cellsStrio);
    [cellsMatrixTL, cellsMatrixTM, cellsMatrixTR, cellsMatrixBL, cellsMatrixBM, cellsMatrixBR] = ...
        utils.split_quadrants6(data.cellsMatrix);

    [nStrioAll, aStrioAll] = compdensity(data.cellsStrio, data.strio);
    [nMatrixAll, aMatrixAll] = compdensity(data.cellsMatrix, data.matrix);

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
        '%s, %s, %s, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d \n', ...
        mouseID, slce, stck, ...
        nStrioTL, nStrioTM, nStrioTR, nStrioBL, nStrioBM, nStrioBR, ...
        aStrioTL, aStrioTM, aStrioTR, aStrioBL, aStrioBM, aStrioBR);
    fprintf(fileMatrixID, ...
        '%s, %s, %s, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d \n', ...
        mouseID, slce, stck, ...
        nMatrixTL, nMatrixTM, nMatrixTR, nMatrixBL, nMatrixBM, nMatrixBR, ...
        aMatrixTL, aMatrixTM, aMatrixTR, aMatrixBL, aMatrixBM, aMatrixBR);
end


function [nCells, aMask] = compdensity(cells, mask)
cc = bwconncomp(cells);
nCells = cc.NumObjects;
aMask = sum(mask(:));
end