function PVCellBodyDetection_run_stain2(exid, imgSrc, realsize, ~, manualDir, ~)
THRESHOLDS = {0.93, 0.95, 0.97};

RESIZE_SIZE = 0.3;

img = imread(imgSrc);

imgInfo = imfinfo(imgSrc);
bitDepth = imgInfo.BitDepth;
if bitDepth == 16
    img = uint8(img / 256);
end

f = figure;
imgResized = imresize(img, RESIZE_SIZE); 
imshow(imgResized);
saveas(f, sprintf('%s/%s-original.png', manualDir, exid));
close all;

imsize = size(img);
realdensity = imsize(1)*imsize(2)/realsize;
refdensity = 93491573.7779782;  % pixel density of reference image 07272018Alexander63xtest-Region 001_Fitc.tiff
sizefactor = realdensity/refdensity;

windowHeight = floor(imsize(1) / 10);
windowWidth = floor(imsize(2) / 10);
numRows = floor(imsize(1) / windowHeight);
numCols = floor(imsize(1) / windowHeight);

for i=1:length(THRESHOLDS)
    threshold = THRESHOLDS{i};
    cells = zeros(imsize(1), imsize(2));
    for r=1:numRows
       for c=1:numCols
            x1 = (c-1) * windowWidth + 1;
            x2 = c * windowWidth;
            y1 = (r-1) * windowHeight + 1;
            y2 = r * windowHeight;
            ROI = imcrop(img, [x1 y1 x2-x1 y2-y1]);
            if sum(sum(ROI)) == 0
                continue;
            end
            
            loghisto1 = log(imhist(ROI));
            histo1 = exp(loghisto1(2:256));
            csum1 = cumsum(histo1);
            csumnorm1 = csum1/csum1(length(csum1));
            cumsumThresh = find(csumnorm1 > threshold);
            cellsWindow = PVCellBodyDetection_find_stain2(ROI, cumsumThresh(1), sizefactor);
            cells(y1:y2, x1:x2) = cellsWindow;
        end
    end
    
    CH = bwconvhull(cells);
    CHpad = padarray(CH,[2000 2000],'both');
    striatumMask = imresize(CHpad, size(img));
    cellsStriatum = cells;
    cellsStriatum(~striatumMask) = 0;

    % Note: This utility assumes the slice is on the right side of a
    % flipped brain. TODO: update this to general orientations. 
    % For now all stain2 PV cells meet the criteria. This may not be true
    % for stain1.
    [cellsMedial, cellsCentral, cellsLateral] = split_quadrants(cellsStriatum); 
    medialConnComp = bwconncomp(imgaussfilt(cellsMedial, 8), 8);
    numCellsMedial = medialConnComp.NumObjects;
    centralConnComp = bwconncomp(imgaussfilt(cellsCentral, 8), 8);
    numCellsCentral = centralConnComp.NumObjects;
    lateralConnComp = bwconncomp(imgaussfilt(cellsLateral, 8), 8);    
    numCellsLateral = lateralConnComp.NumObjects;
    
    areaCellsMedial = sum(sum(logical(cellsMedial)));
    areaCellsCentral = sum(sum(logical(cellsCentral)));
    areaCellsLateral = sum(sum(logical(cellsLateral)));

    cellsResized = imresize(cells, RESIZE_SIZE); 
    striatumMaskResized = imresize(striatumMask, RESIZE_SIZE);
    green = cat(3,cellsResized*0,logical(cellsResized),cellsResized*0);
    f = figure;
    imshow(imgResized);
    hold on
    h = imshow(green);
    hold off
    set(h, 'AlphaData', cellsResized * 0.3  + ~cellsResized * 0);
    hold on;
    h2 = imshow(cat(3, striatumMaskResized, striatumMaskResized, striatumMaskResized*0));
    hold off
    set(h2, 'AlphaData', 0.05);
    saveas(f, sprintf('%s/%s-%d.png', manualDir, exid, i));
    save(sprintf('%s/%s-%d-data.mat', manualDir, exid, i), 'cells', 'striatumMask', ...
        'threshold', 'numCellsMedial', 'numCellsCentral', 'numCellsLateral', ...
        'areaCellsMedial', 'areaCellsCentral', 'areaCellsLateral', '-v7.3');
    close all;
end
end
