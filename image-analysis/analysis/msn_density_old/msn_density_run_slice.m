function [strioT, matrixT] = msn_density_run_slice(imgStrio, imgMSN, masksStrio, threshsStrio, realsize)
%% Find the masks for striosomes and matrix
[centers, centersAndRims] = get_strio_masks(imgStrio, masksStrio, threshsStrio, realsize);

imgStrioBlur = imgaussfilt(imgStrio, 40);
h = imhist(imgStrio);
m = find(h == max(h));
fibersOfPassage = ~(imgStrioBlur > m);

hull = bwconvhull(centersAndRims);
centersAndRimsFilled = imfill(centersAndRims, 'holes');

strioMask = imfill(centers, 'holes') & ~fibersOfPassage;
matrixMask = hull & ~fibersOfPassage & ~centersAndRimsFilled;

% figure; imshow(mat2gray(imgStrio));
% figure; imshow(strioMask);
% figure; imshow(matrixMask);

%% Find pv cell bodies.
cells = find_msn_cells(imgMSN, realsize);

% o1 = imoverlay(mat2gray(imgMSN), bwperim(strioMask), 'b');
% o2 = imoverlay(o1, bwperim(matrixMask), 'r');
% o3 = imoverlay(o2, cells, 'g');
% figure;
% imshow(o3);

%% Compute density across regions.
[topLeftCells, topMidCells, topRightCells, ...
    botLeftCells, botMidCells, botRightCells] = split_quadrants6(cells);
[topLeftStrio, topMidStrio, topRightStrio, ...
    botLeftStrio, botMidStrio, botRightStrio] = split_quadrants6(strioMask);   
[topLeftMatrix, topMidMatrix, topRightMatrix, ...
    botLeftMatrix, botMidMatrix, botRightMatrix] = split_quadrants6(matrixMask);   

allStrioDensity = compute_density(cells, strioMask);
allMatrixDensity = compute_density(cells, matrixMask);

topLeftStrioDensity = compute_density(topLeftCells, topLeftStrio);
topMidStrioDensity = compute_density(topMidCells, topMidStrio);
topRightStrioDensity = compute_density(topRightCells, topRightStrio);
botLeftStrioDensity = compute_density(botLeftCells, botLeftStrio);
botMidStrioDensity = compute_density(botMidCells, botMidStrio);
botRightStrioDensity = compute_density(botRightCells, botRightStrio);

topLeftMatrixDensity = compute_density(topLeftCells, topLeftMatrix);
topMidMatrixDensity = compute_density(topMidCells, topMidMatrix);
topRightMatrixDensity = compute_density(topRightCells, topRightMatrix);
botLeftMatrixDensity = compute_density(botLeftCells, botLeftMatrix);
botMidMatrixDensity = compute_density(botMidCells, botMidMatrix);
botRightMatrixDensity = compute_density(botRightCells, botRightMatrix);

strioT = table(allStrioDensity, topLeftStrioDensity, topMidStrioDensity, ...
    topRightStrioDensity, botLeftStrioDensity, botMidStrioDensity, botRightStrioDensity);
matrixT = table(allMatrixDensity, topLeftMatrixDensity, topMidMatrixDensity, ...
    topRightMatrixDensity, botLeftMatrixDensity, botMidMatrixDensity, botRightMatrixDensity);
end


function ret = compute_density(cells_, mask)
cells = cells_;
cells(~mask) = 0;
count = length(unique(cells(:))) - 1;
ret = count / sum(mask(:));
end

