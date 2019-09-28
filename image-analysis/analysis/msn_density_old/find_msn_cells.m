function cells = find_msn_cells(img, realsize)
ENERGY_THRESHOLD = 180;

imsize = size(img);
numRows = 20;
numCols = 20;
cellCount = 0;

winHeight = floor(imsize(1) / numRows);
winWidth = floor(imsize(2) / numCols);

imgSubFoundCells = img;

[cellsWin1, cellCount] = ...
    find_cells_loop(img, imgSubFoundCells, realsize, ...
    ENERGY_THRESHOLD, cellCount, ...
    winHeight, winWidth, 0, 0, 1, numRows, 1, numCols);

imgSubFoundCells(logical(cellsWin1)) = 0;
[cellsWin2, cellCount] = ...
    find_cells_loop(img, imgSubFoundCells, realsize, ...
    ENERGY_THRESHOLD, cellCount, ...
    winHeight, winWidth, 0, floor(winWidth/2), 1, numRows, 1, numCols-1);

imgSubFoundCells(logical(cellsWin2)) = 0;
[cellsWin3, cellCount] = ...
    find_cells_loop(img, imgSubFoundCells, realsize, ...
    ENERGY_THRESHOLD, cellCount, ...
    winHeight, winWidth, floor(winHeight/2), 0, 1, numRows-1, 1, numCols);

imgSubFoundCells(logical(cellsWin3)) = 0;
[cellsWin4, ~] = ...
    find_cells_loop(img, imgSubFoundCells, realsize, ...
    ENERGY_THRESHOLD, cellCount, ...
    winHeight, winWidth, floor(winHeight/2), floor(winWidth/2), 1, numRows-1, 1, numCols-1);


cells = cellsWin1 + cellsWin2 + cellsWin3 + cellsWin4;

% figure;
% imshow(cells);
% figure;
% imshow(imoverlay(mat2gray(img), bwperim(cells), 'g'));
% hold on;
% for k=1:winHeight:imsize(1)
%     x = [1 imsize(2)];
%     y = [k k];
%     plot(x,y,'Color','y','LineStyle','-');
%     plot(x,y,'Color','k','LineStyle',':');
% end
% for k=1:winWidth:imsize(2)
%     x = [k k];
%     y = [1 imsize(1)];
%     plot(x,y,'Color','y','LineStyle','-');
%     plot(x,y,'Color','k','LineStyle',':');
% end
end

function [cells, cellCount] = find_cells_loop(img, imgSubFoundCells, realsize, ...
    energyThreshold, cellCount, ...
    winHeight, winWidth, rowOffset, colOffset, rowS, rowT, colS, colT)

imsize = size(img);
realdensity = imsize(1)*imsize(2)/realsize;
refdensity = 2.662521880579250e+07;
sizefactor = realdensity/refdensity;

cells = zeros(imsize(1), imsize(2));
for r=rowS:rowT
    for c=colS:colT
        x1 = colOffset + (c-1) * winWidth + 1;
        x2 = colOffset + c * winWidth;
        y1 = rowOffset + (r-1) * winHeight + 1;
        y2 = rowOffset + r * winHeight;
        ROI = imcrop(imgSubFoundCells, [x1 y1 x2-x1 y2-y1]);
        if sum(sum(ROI)) == 0
            continue;
        end
        
        [cellsWindow, cellCount] = find_cells_(ROI, energyThreshold, sizefactor, cellCount);
        cells(y1:y2, x1:x2) = cellsWindow;
    end
end
end

function [cells, cellCount] = find_cells_(img, energyThreshold, sizefactor, startCount)
SOLIDITY_THRESH = 0.7;
AREA_LOWER_THRESH = 200;
INTENSITY_THRESHOLD = 0.92;

imgAdj = imadjust(img);
[r,c] = size(imgAdj);
cells = zeros(r,c);
cellCount = startCount;

loghisto1 = log(imhist(imgAdj));
histo1 = exp(loghisto1);
csum1 = cumsum(histo1);
csumnorm1 = csum1/csum1(length(csum1));
threshold = find(csumnorm1 > INTENSITY_THRESHOLD);

% Thresholds the cropped image
threshed = imgAdj > threshold(1);
imgAdj(~threshed) = 0;

% Preprocessing
removed = bwareaopen(imgAdj,round(100*sizefactor));
filled = imfill(removed,'holes');
holes = filled & ~removed;
bigholes = bwareaopen(holes, 500);
smallholes = holes & ~bigholes;
potentialCells = removed | smallholes;

if sum(sum(potentialCells))== 0
    return;
end

sideLen = round(15*sqrt(sizefactor));
centerLen = round(8*sqrt(sizefactor));
% Finds the Cells
% Initializes the total region of interest
blobs = potentialCells;
selectedRegions = logical(zeros(r,c));
for i = 1:(r-sideLen)
    for j = 1:(c-sideLen)
        if potentialCells(i,j) == 1
            % creates a submatrix of reference size 51 x 51
            sub = potentialCells(i:i+sideLen,j:j+sideLen);
            % checks if the submatrix is all ones
            if sum(sum(sub)) == (sideLen+1)^2
                % index is the center of the submatrix
                rMid = i+centerLen;
                cMid = j+centerLen;
                % creates ROI around index that is reference size 101 x 101
                minr = max(rMid - sideLen, 1);
                maxr = min(rMid + sideLen, r);
                minc = max(cMid - sideLen, 1);
                maxc = min(cMid + sideLen, c);
                
                % adds to the total ROI
                selectedRegions(minr:maxr, minc:maxc) = 1;
            end
        end
    end
end

blobs(~selectedRegions) = 0;
blobs = bwareaopen(blobs, 3000); % Remove small blobs.
blobMeasurements = regionprops(blobs, 'all');
numberOfBlobs = size(blobMeasurements, 1);
for k=1:numberOfBlobs
    % Get blob mask.
    centroid = blobMeasurements(k).Centroid;
    blob = bwselect(blobs, centroid(1), centroid(2));
    region = imgAdj;
    region(~blob) = 0;
    
    isOnBorder = is_on_border(region);
    thisBlobsPixels = blobMeasurements(k).PixelIdxList;
    blobArea = blobMeasurements(k).Area;
    energy = sum(img(thisBlobsPixels) .^ 2)/ blobArea;
    
    blobCentroid = blobMeasurements(k).Centroid;
    blobConvHull = blobMeasurements(k).ConvexImage;
    blobFilledImg = blobMeasurements(k).FilledImage;
    if all(blobFilledImg,'all') % Edge case where square gets selected as blob.
        continue;
    end
    nonConvHull = blobConvHull - blobFilledImg;
    center = size(nonConvHull)/2+.5;
    [a,b]= find(nonConvHull == 1);
    distances = sqrt((a-center(1)).^2 + (b-center(2)).^2);
    radius = min(distances);
    [W,H] = meshgrid(1:c,1:r);
    circleMask = ((W-blobCentroid(1)).^2 + (H-blobCentroid(2)).^2) < radius^2;
    circleMaskArea = sum(circleMask(:));
    
    % Pre filter anything with low energy, low area, or on border.
    % Allow bordered cells to be picked up with different window.
    if energy < energyThreshold ...
            ||  blobArea < AREA_LOWER_THRESH ...
            || circleMaskArea < 2000 ...
            || isOnBorder
        continue;
    end
    
    blobSolidity = blobMeasurements(k).Solidity; % area / convexArea
    if blobSolidity > SOLIDITY_THRESH
        blobPixels = blobMeasurements(k).PixelIdxList;
        cellCount = cellCount + 1;
        cells(blobPixels) = cellCount;
        continue;
    end
end

% figure;
% subplot(2,2,3);
% imshow(mat2gray(img));
% subplot(2,2,2);
% imshow(label2rgb(cells));
% subplot(2,2,1);
% imshow(imoverlay(potentialCells, bwperim(circleMask), 'r'));
% subplot(2,2,4);
% imshow(selectedRegions);
end

function ret = is_on_border(binImg)
bordersTop = sum(binImg(1,:)) > 1;
bordersBottom = sum(binImg(size(binImg,1), :)) > 1;
bordersLeft = sum(binImg(:, 1)) > 1;
bordersRight = sum(binImg(:,size(binImg,2))) > 1;
ret = bordersTop || bordersBottom || bordersLeft || bordersRight;
end
