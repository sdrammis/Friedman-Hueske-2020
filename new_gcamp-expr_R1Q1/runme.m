% Load the miceType.mat file
% Strio and matrix masks are found in the ./mask-data folder.

MASKS_DIR = './masks-data';
DEBUG_DIR = './counts-debug';
MSN_DIR = '/Volumes/annex4/afried/resultfiles/system-tree/msn_cell_body_detection/done';
IMGS_DIR = '/Volumes/smbshare/analysis3/strio_matrix_cv/Alexander_Emily_Erik/FINAL EXPORTED IMAGES';

matrixDlxGCaMP = []; % column 1: strio expression, column 2: matrix expr
matrixMashGCaMP = [];
strioDlxGCaMP = [];
strioMashGCaMP = [];

execsM = dbload('./db.json');

listings = dir([MASKS_DIR '/*-striomasks.mat']);
for iListing=1:size(listings,1)
    filename = listings(iListing).name;
    splits = split(filename, '-striomasks.mat');
    
    exid = splits{1};
    masks = load([MASKS_DIR '/' filename]);
    msnfilepth = [MSN_DIR '/' exid '-data.mat'];
    if ~isfile(msnfilepth)
        continue;
    end
    
    fprintf('Running execution %s...\n', exid);
    
    msndata = load([MSN_DIR '/' exid '-data.mat']);
    striomask = masks.strio;
    matrixmask = masks.matrix;
    
    striodilated = imdilate(striomask, strel('disk',80,8));
    matrixsubed = (matrixmask - striodilated) > 0;
    
    cells = bwareaopen(msndata.cells, 4000);
    cellsprops = regionprops(cells, 'all');
    centroids = [cellsprops.Centroid];
    centroidsX = centroids(1:2:end-1);
    centroidsY = centroids(2:2:end);
    
    exec = execsM(strcmp({execsM.exid}, exid));
    experiment = lower(exec.experiment);
    slice = lower(exec.slice);
    strioimg = imreadvisible([IMGS_DIR '/' experiment '/' slice '_strio.tiff']);
    msnimg = imread([IMGS_DIR '/' experiment '/' slice '_msn.tiff']);
% %     matrixMaskColored = cat(3, matrixsubed*1, matrixsubed*0, matrixsubed*1);
    matrixcells = zeros(size(msndata.cells,1),size(msndata.cells,2));
    striocells = zeros(size(msndata.cells,1),size(msndata.cells,2));

    striocount = 0;
    matrixcount = 0;
    nCells = length(centroidsX);
    for iCells=1:nCells
        x = round(centroidsX(iCells));
        y = round(centroidsY(iCells));
        if isnan(x) || isnan(y)
            continue;
        end
        cell = bwselect(cells, x, y);
                        
        numStrio = nnz(striodilated & cell);
        numMatrix = nnz(matrixsubed & cell);
        if numStrio == 0 && numMatrix == 0
            continue;
        end
        
        if numStrio > 0 
%             striocells = striocells | cell;
            striocount = striocount + 1;
        elseif numMatrix > 0
%             matrixcells = matrixcells | cell;
            matrixcount = matrixcount + 1;
        end
    end
    
%     f1 = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
%     imshow(strioimg);
%     hold on;
% %     h = imshow(matrixMaskColored);
%     bstrio = bwboundaries(striodilated);
%     for k=1:length(bstrio)
%         b = bstrio{k};
%         plot(b(:,2),b(:,1),'r','LineWidth',1);
%     end
%     bstrio = bwboundaries(striocells);
%     for k=1:length(bstrio)
%         b = bstrio{k};
%         plot(b(:,2),b(:,1),'g','LineWidth',3);
%     end
%     bmatrix = bwboundaries(matrixcells);
%     for k=1:length(bmatrix)
%         b = bmatrix{k};
%         plot(b(:,2),b(:,1),'b','LineWidth',3);
%     end
% %     hold off;
% %     set(h, 'AlphaData', 0.3 * strioimg);
%     title(exid);
%     saveas(f1, [DEBUG_DIR '/' exid '-strio.png']);
%     
%     f2 = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
%     imshow(msnimg);
%     hold on;
%     bstrio = bwboundaries(striodilated);
%     for k=1:length(bstrio)
%         b = bstrio{k};
%         plot(b(:,2),b(:,1),'g','LineWidth',1);
%     end
% %     bmatrix = bwboundaries(matrixsubed);
% %     for k=1:length(bmatrix)
% %         b = bmatrix{k};
% %         plot(b(:,2),b(:,1),'b','LineWidth',1);
% %     end
%     title(exid);
%     saveas(f2, [DEBUG_DIR '/' exid '-msn.png']);
%     
%     close all;
    
    splits = strsplit(exid, '_');
    mouseID = splits{2};
    mouse = miceType(strcmp({miceType.ID}, mouseID));
    if isempty(mouse)
        continue;
    end
    
    sprintf('Mouse=%s, Intended=%s, actual=%d, Cound strio=%d, count matrix=%d \n', mouse.ID, mouse.intendedStriosomality, mouse.histologyStriosomality, striocount, matrixcount);
    striosomality = mouse.intendedStriosomality;
    genotype = mouse.genotype;
    if strcmp(striosomality, 'Strio')
        if strcmp(genotype, 'Dlx')
            strioDlxGCaMP = [strioDlxGCaMP; striocount matrixcount];
        elseif strcmp(genotype, 'Mash')
            strioMashGCaMP = [strioMashGCaMP; striocount matrixcount];
        end
    elseif strcmp(striosomality, 'Matrix')
        if strcmp(genotype, 'Dlx')
            matrixDlxGCaMP = [matrixDlxGCaMP; striocount matrixcount];
        elseif strcmp(genotype, 'Mash')
            matrixMashGCaMP = [matrixMashGCaMP; striocount matrixcount];
        end
    end
end

f1 = figure;
plotbarsgrp({strioDlxGCaMP, strioMashGCaMP, matrixDlxGCaMP, matrixMashGCaMP}, ...
    {'Strio Dlx', 'Strio Mash', 'Matrix Dlx', 'Matrix Mash'})
legend({'Strio', 'Matrix'});
title('Overall GCaMP expression comparison');

strioDlxNorm = donorm(strioDlxGCaMP);
strioMashNorm = donorm(strioMashGCaMP);
matrixDlxNorm = donorm(matrixDlxGCaMP);
matrixMashNorm = donorm(matrixMashGCaMP);
f2 = figure;
plotbars({strioDlxNorm, strioMashNorm, matrixDlxNorm, matrixMashNorm}, ...
    {'Strio Dlx', 'Strio Mash', 'Matrix Dlx', 'Matrix Mash'}, cbrewer('qual', 'Set2', 10));
title('GCaMP expression normalized');

function ret = donorm(dat)
S = dat(:,1);
M = dat(:,2);
ret = (S-M)./(S+M);
end
