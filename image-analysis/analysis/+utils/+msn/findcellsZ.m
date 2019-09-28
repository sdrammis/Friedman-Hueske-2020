function cells = findcellsZ(imgsrc, realsize)
NUM_ROWS = 20;
NUM_COLS = 20;

THRESH = 0.87;
ENERGY_THRESH = 180;

% Convert image to 8bit if needed.
imginfo = imfinfo(imgsrc);
img = imread(imgsrc);
if imginfo.BitDepth == 16
    img = uint8(img / 256);
end

imsize = size(img);
winHeight = floor(imsize(1) / NUM_ROWS);
winWidth = floor(imsize(2) / NUM_COLS);

cellCount = 0;
imgSubFoundCells = img;

[cellsWin1, cellCount] = ...
    find_cells_loop(img, imgSubFoundCells, realsize, THRESH, ENERGY_THRESH, cellCount, ...
    winHeight, winWidth, 0, 0, 1, NUM_ROWS, 1, NUM_COLS);

imgSubFoundCells(logical(cellsWin1)) = 0;
[cellsWin2, cellCount] = ...
    find_cells_loop(img, imgSubFoundCells, realsize, THRESH, ENERGY_THRESH, cellCount, ...
    winHeight, winWidth, 0, floor(winWidth/2), 1, NUM_ROWS, 1, NUM_COLS-1);

imgSubFoundCells(logical(cellsWin2)) = 0;
[cellsWin3, cellCount] = ...
    find_cells_loop(img, imgSubFoundCells, realsize, THRESH, ENERGY_THRESH, cellCount, ...
    winHeight, winWidth, floor(winHeight/2), 0, 1, NUM_ROWS-1, 1, NUM_COLS);

imgSubFoundCells(logical(cellsWin3)) = 0;
[cellsWin4, ~] = ...
    find_cells_loop(img, imgSubFoundCells, realsize, THRESH, ENERGY_THRESH, cellCount, ...
    winHeight, winWidth, floor(winHeight/2), floor(winWidth/2), 1, NUM_ROWS-1, 1, NUM_COLS-1);

cells = cellsWin1 + cellsWin2 + cellsWin3 + cellsWin4;
end

function [cells, cellCount] = find_cells_loop(img, imgSubFoundCells, realsize, ...
    thresh, energyThresh, cellCount, ...
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
        
        loghisto1 = log(imhist(imcrop(img, [x1 y1 x2-x1 y2-y1])));
        histo1 = exp(loghisto1);
        csum1 = cumsum(histo1);
        csumnorm1 = csum1/csum1(length(csum1));
        threshed = find(csumnorm1 > thresh);
        [cellsWindow, cellCount] = find_cells_(ROI, threshed(1), energyThresh, sizefactor, cellCount);
        cells(y1:y2, x1:x2) = cellsWindow;
    end
end
end

function [cells, cellCount] = find_cells_(img_, thresh, energyThresh, sizefactor, startCount)
SOLIDITY_THRESH = 0.85;
AREA_LOWER_THRESH = 200;

img = img_;
[r,c] = size(img);
cells = zeros(r,c);
cellCount = startCount;

% Threshs the cropped image
threshed = img > thresh;
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
selectedRegions = false(r,c);
for i = 1:(r-sideLen)
    for j = 1:(c-sideLen)
        if potentialCells(i,j) == 1
            % creates a submatrix of reference size 51 x 51
            potsub = potentialCells(i:i+sideLen,j:j+sideLen);
            % checks if the submatrix is all ones
            if sum(sum(potsub)) == (sideLen+1)^2
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
    region = img;
    region(~blob) = 0;
    
    isOnBorder = is_on_border(region);
    thisBlobsPixels = blobMeasurements(k).PixelIdxList;
    blobArea = blobMeasurements(k).Area;
    energy = sum(img(thisBlobsPixels) .^ 2)/ blobArea;
    
    % Pre filter anything with low energy, low area, or on border.
    % Allow bordered cells to be picked up with different window.
    if energy < energyThresh...
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
end
end

function ret = is_on_border(binImg)
bordersTop = sum(binImg(1,:)) > 1;
bordersBottom = sum(binImg(size(binImg,1), :)) > 1;
bordersLeft = sum(binImg(:, 1)) > 1;
bordersRight = sum(binImg(:,size(binImg,2))) > 1;
ret = bordersTop || bordersBottom || bordersLeft || bordersRight;
end
