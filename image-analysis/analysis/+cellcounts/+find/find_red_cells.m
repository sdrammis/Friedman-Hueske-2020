function cells = find_red_cells(img_, realsize)
imgNonZero = double(img_(img_ > 0));
if std(imgNonZero) > 400
    threshold = 0.95;
    energyThreshold = 100;
else
    threshold = 0.8;
    energyThreshold = 20;
    
end

img = uint8(img_/256);
imsize = size(img);

numRows = 20;
numCols = 20;
cellCount = 0;

winHeight = floor(imsize(1) / numRows);
winWidth = floor(imsize(2) / numCols);

[cellsWin1, cellCount] = ...
    find_cells_loop(img, realsize, threshold, energyThreshold, cellCount, ...
    winHeight, winWidth, 0, 0, 1, numRows, 1, numCols);

img(logical(cellsWin1)) = 0;
[cellsWin2, cellCount] = ...
    find_cells_loop(img, realsize, threshold, energyThreshold, cellCount, ...
    winHeight, winWidth, 0, floor(winWidth/2), 1, numRows, 1, numCols-1);

img(logical(cellsWin2)) = 0;
[cellsWin3, cellCount] = ...
    find_cells_loop(img, realsize, threshold, energyThreshold, cellCount, ...
    winHeight, winWidth, floor(winHeight/2), 0, 1, numRows-1, 1, numCols);

img(logical(cellsWin3)) = 0;
[cellsWin4, ~] = ...
    find_cells_loop(img, realsize, threshold, energyThreshold, cellCount, ...
    winHeight, winWidth, floor(winHeight/2), floor(winWidth/2), 1, numRows-1, 1, numCols-1);


cells = cellsWin1 + cellsWin2 + cellsWin3 + cellsWin4;
end

function [cells, cellCount] = find_cells_loop(img, realsize, ...
    threshold, energyThreshold, cellCount, ...
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
        ROI = imcrop(img, [x1 y1 x2-x1 y2-y1]);
        if sum(sum(ROI)) == 0
            continue;
        end
        
        loghisto1 = log(imhist(ROI));
        histo1 = exp(loghisto1);
        csum1 = cumsum(histo1);
        csumnorm1 = csum1/csum1(length(csum1));
        thresholded = find(csumnorm1 > threshold);
        [cellsWindow, cellCount] = find_cells_(ROI, thresholded(1), energyThreshold, sizefactor, cellCount);
        cells(y1:y2, x1:x2) = cellsWindow;
    end
end
end

function [cells, cellCount] = find_cells_(img_, threshold, energyThreshold, sizefactor, startCount)
SOLIDITY_THRESH = 0.85;
AREA_LOWER_THRESH = 200;

img = img_;
[r,c] = size(img);
cells = zeros(r,c);
cellCount = startCount;

% Thresholds the cropped image
threshed = img > threshold;
img(~threshed) = 0;

% Preprocessing
removed = bwareaopen(img,round(100*sizefactor));
potentialCells = imfill(removed,'holes');
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
blobs = bwareaopen(blobs, 40); % Remove small blobs.
blobMeasurements = regionprops(blobs, 'all');
numberOfBlobs = size(blobMeasurements, 1);
for k=1:numberOfBlobs
    % Get blob mask.
    centroid = blobMeasurements(k).Centroid;
    blob = bwselect(blobs, centroid(1), centroid(2));
    region = img;
    region(~blob) = 0;
    
    isOnBorder = is_on_border(region);
    thisBlobsPixels = blobMeasurements(k).PixelIdxList;
    blobArea = blobMeasurements(k).Area;
    energy = sum(img(thisBlobsPixels) .^ 2) / blobArea;
    
    % Pre filter anything with low energy, low area, or on border.
    % Allow bordered cells to be picked up with different window.
    if energy < energyThreshold ...
            ||  blobArea < AREA_LOWER_THRESH ...
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
    
    
    % Find edges of mask.
    % TODO detect edges for the entire region, then use mask to select
    % edges
    padSize = 10;
    edges = edge(padarray(blob,[padSize padSize]), 'Canny');
    edges = edges(padSize+1:end-padSize, padSize+1:end-padSize);
    
    % Find brightest areas as references for segmentation.
    maskMax = imextendedmax(region, 5);
    maskMax = imfill(maskMax, 'holes');
    maskMax = bwareaopen(maskMax, 25);
    
    % Apply watershed segmentation.
    regionComp = imcomplement(region);
    regionSeg = watershed(imimposemin(regionComp, ~(blob - maskMax + edges)));
    
    % Find sub regions that are cells.
    subBlobs = utils.sortStruct(regionprops(regionSeg, 'all'), 'Area', -1);
    numSubBlobs = size(subBlobs, 1);
    for l=2:numSubBlobs % Don't consider background.
        subBlobPixels = subBlobs(l).PixelIdxList;
        subBlobArea = subBlobs(l).Area;
        subBlobSolidity = subBlobs(l).Solidity; % area / convexArea
        subBlobEnergy = sum(img(subBlobPixels) .^ 2) / subBlobArea;
        
        if subBlobArea < AREA_LOWER_THRESH ...
                || subBlobEnergy < energyThreshold ...
                || subBlobSolidity < SOLIDITY_THRESH
            continue;
        end
        
        cellCount = cellCount + 1;
        cells(subBlobPixels) = cellCount;
    end
end

% figure;
% subplot(2,2,3);
% imshow(mat2gray(img_));
% subplot(2,2,2);
% imshow(label2rgb(cells));
% subplot(2,2,1);
% imshow(potentialCells);
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