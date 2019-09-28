CELLS_PATH_SORTED = '/annex2/analysis/strio_matrix_cv/Alexander_Emily_Erik/analysis_output_copy/cell_counts';
STRIO_PATH = '/annex4/afried/resultfiles/system-tree/strio_analysis/done';
IMGS_PATH = '/annex4/afried/resultfiles/FINAL_EXPORTED_IMAGES';
% OUT_DIR = '/annex4/afried/resultfiles/analysis_output/msn_density/msn_density_cc';

% CELLS_PATH_SORTED = '../tmp/densities/cells';
% STRIO_PATH = '../tmp/densities/strio';
% IMGS_PATH = '../tmp/densities/imgs';
OUT_DIR = './tmp';

LOW_THRESH = -0.1;
HIGH_THRESH = 1.3;

e11Dlx1D1Mice = {'2447', '5233', '3348', '4229'};
e11Dlx1D2Mice = {'3337', '3343', '3084', '3085'};
e11Mash1D1Mice = {'3552', '3545', '3535', '3536'};
e11Mash1D2Mice = {'3128', '3131', '3130', '3562'};
e15Dlx1D1Mice = {'3514', '3516', '3512', '4186'};
e15Dlx1D2Mice = {'3816', '3518', '3517', '3953'};
e15Mash1D1Mice = {'3556', '3899', '3846'};
e15Mash1D2Mice = {'3568', '3570', '3567', '3903'};

strioMice = [e11Dlx1D1Mice e11Dlx1D2Mice e11Mash1D1Mice e11Mash1D2Mice];
matrixMice = [e15Dlx1D1Mice e15Dlx1D2Mice e15Mash1D1Mice e15Mash1D2Mice];

load('./dbs/micedb.mat');
load('./dbs/dimensions.mat');

datefmt = 'YYmmdd_HHMMSS';
fileID = fopen([OUT_DIR '/msndenscc-data_' datestr(datetime('now'), datefmt)  '.txt'], 'a');

strioFiles = dir(STRIO_PATH);
strioFilenames = {strioFiles.name};

dirContents = dir(CELLS_PATH_SORTED);
files = {dirContents(:).name};
for iFile=1:length(files)
    filename = files{iFile};
    if isempty(regexpi(filename, '.*_data\.mat'))
        continue;
    end
    
    % Find the mouseID, slice, stack, and experiment.
    splits1 = split(filename, '_');
    splits2 = split(splits1{1}, '-');
    mouseID = splits2{end};
    slce = [splits1{1} '_' splits1{2}];
    slcenum = strrep(splits1{2}, 'slice', ''); 
    stck = splits1{3};
    if contains(filename, 'experiment')
        splits3 = split(splits2{3}, ' ');
        exp = splits3{end};
    else
        exp = '1';
    end
    
    fprintf('Working on slice %s and stack %s... \n', slce, stck);
    
    % Find the MSN Cell bodies.
    imgNameRed = [slce '_texa_' num2str(stck) '.tiff'];
    imgSrcRed = [IMGS_PATH '/cell_counts_' exp '/' imgNameRed];
    try 
        imgRed = imread(imgSrcRed);
        msnCells = cellcounts.find.find_red_cells(imgRed, 2); 
    catch
        fprintf('Could not open texa image!\n');
        continue;
    end
    
    % Compute striosomes and matrix masks.
    idxs = find(contains(strioFilenames, [mouseID '_slice' slcenum]));
    if length(idxs) < 3
        continue;
    end
 
    masksPth = [STRIO_PATH '/' strioFilenames{idxs(2)}];
    thrshsPth = [STRIO_PATH '/' strioFilenames{idxs(3)}];
    imgPth = [IMGS_PATH '/cell_counts_' exp '/' regexprep(filename, '_-?[0-9]+_data.mat', '_strio.tiff')];
    try
        [strio, matrix] = utils.compstriomasks(imgPth, masksPth, thrshsPth, 2, 'cc');
    catch
        fprintf('Failed to get masks for slice %s and satck %s!\n', slce, stck);
        continue;
    end
    if any(strcmp(strioMice, mouseID))
        striosomality = 'Strio';
    else
        striosomality = 'Matrix';
    end
    [cellsStrio, cellsMatrix] = msndensity.labelcells(msnCells, strio, matrix, striosomality);
    
    % Get the image pixel size.
    w = dimensions.width(lower(dimensions.slice) == strrep(slce, '\', ''));
    h = dimensions.height(lower(dimensions.slice) == strrep(slce, '\', ''));
    pixelsize = (w * h) / (size(strio,1) * size(strio,2));
    
    % Compute densities.
    [nStrioAll, aStrioAll] = compdensity(cellsStrio, strio, pixelsize);
    [nMatrixAll, aMatrixAll] = compdensity(cellsMatrix, matrix, pixelsize);
    
    [strioTL, strioTM, strioTR, strioBL, strioBM, strioBR] = ...
        utils.split_quadrants6(strio);
    [matrixTL, matrixTM, matrixTR, matrixBL, matrixBM, matrixBR] = ...
        utils.split_quadrants6(matrix);
    [cellsStrioTL, cellsStrioTM, cellsStrioTR, cellsStrioBL, cellsStrioBM, cellsStrioBR] = ...
        utils.split_quadrants6(cellsStrio);
    [cellsMatrixTL, cellsMatrixTM, cellsMatrixTR, cellsMatrixBL, cellsMatrixBM, cellsMatrixBR] = ...
        utils.split_quadrants6(cellsMatrix);
    
    [nStrioTL, aStrioTL] = compdensity(cellsStrioTL, strioTL, pixelsize);
    [nStrioTM, aStrioTM] = compdensity(cellsStrioTM, strioTM, pixelsize);
    [nStrioTR, aStrioTR] = compdensity(cellsStrioTR, strioTR, pixelsize);
    [nStrioBL, aStrioBL] = compdensity(cellsStrioBL, strioBL, pixelsize);
    [nStrioBM, aStrioBM] = compdensity(cellsStrioBM, strioBM, pixelsize);
    [nStrioBR, aStrioBR] = compdensity(cellsStrioBR, strioBR, pixelsize);
    
    [nMatrixTL, aMatrixTL] = compdensity(cellsMatrixTL, matrixTL, pixelsize);
    [nMatrixTM, aMatrixTM] = compdensity(cellsMatrixTM, matrixTM, pixelsize);
    [nMatrixTR, aMatrixTR] = compdensity(cellsMatrixTR, matrixTR, pixelsize);
    [nMatrixBL, aMatrixBL] = compdensity(cellsMatrixBL, matrixBL, pixelsize);
    [nMatrixBM, aMatrixBM] = compdensity(cellsMatrixBM, matrixBM, pixelsize);
    [nMatrixBR, aMatrixBR] = compdensity(cellsMatrixBR, matrixBR, pixelsize);
    
    fprintf(fileID, ...
        ['%s, %s, %s, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, '...
        '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n'], ...
        mouseID, slce, stck, ...
        nStrioAll, nStrioTL, nStrioTM, nStrioTR, nStrioBL, nStrioBM, nStrioBR, ...
        nMatrixAll, nMatrixTL, nMatrixTM, nMatrixTR, nMatrixBL, nMatrixBM, nMatrixBR, ...
        aStrioAll, aStrioTL, aStrioTM, aStrioTR, aStrioBL, aStrioBM, aStrioBR, ...
        aMatrixAll, aMatrixTL, aMatrixTM, aMatrixTR, aMatrixBL, aMatrixBM, aMatrixBR);
end

function [nCells, aMask] = compdensity(cells, mask, pixelsize)
cc = bwconncomp(cells);
nCells = cc.NumObjects;
aMask = sum(mask(:)) * pixelsize;
end
