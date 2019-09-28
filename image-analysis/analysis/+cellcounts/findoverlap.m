function [mixedCells, maybeMixedCells, notMixedCells] = findoverlap(cellsRed, imgGreen, lowThresh, highThresh)
DIP_N_BOOT = 500;

[m, n] = size(imgGreen);
windowHeight = floor(m / 9);
windowWidth = floor(n / 9);
numRows = floor(m / windowHeight);
numCols = floor(n / windowWidth);

[m, n] = size(imgGreen);
cropFactor = 8;
cropX = floor(n / cropFactor);
cropY = floor(m / cropFactor);
imgGreenMask = zeros(m, n);
imgGreenMask(cropY:cropY*(1+cropFactor-2), cropX:cropX*(1+cropFactor-2)) = 1;
imgGreenCrop = imgGreen;
imgGreenCrop(~imgGreenMask) = 0;
B = imgaussfilt(imgGreenCrop, 20);
striatumMask = bwconvhull(imbinarize(B, graythresh(B)*3));
imgGreenStriatum = double(imgGreen);
cellsRedStriatum = cellsRed;
imgGreenStriatum(~striatumMask) = NaN;
cellsRedStriatum(~striatumMask) = 0;

mixedCells = zeros(m, n);
maybeMixedCells = zeros(m, n);
notMixedCells = zeros(m, n);
for r=1:numRows
    for c=1:numCols
        x1 = (c-1) * windowWidth + 1;
        x2 = c * windowWidth;
        y1 = (r-1) * windowHeight + 1;
        y2 = r * windowHeight;
        
        ROI = imcrop(imgGreenStriatum, [x1 y1 x2-x1 y2-y1]);
        
        if isnan(nanmean(ROI(:)))
            continue;
        end
        
        % Skip any region that has a significant difference is intensity
        % values because of zstack artifact.
        mean1 = nanmean(ROI, 1);
        mean2 = nanmean(ROI, 2);
        xpdf1 = inpaint_nans(mean1);
        xpdf2 = inpaint_nans(mean2);
        dip1 = HartigansDipSignifTest(xpdf1, DIP_N_BOOT);
        dip2 = HartigansDipSignifTest(xpdf2, DIP_N_BOOT);
        if dip1 >= 1 || dip2 >= 1
            continue;
        end

        
        [mROI, nROI] = size(ROI);
        cellsRedROI = cellsRedStriatum(y1:y2, x1:x2);
        z = (ROI - nanmean(ROI(:))) / nanstd(ROI(:));
        definitecells = z > highThresh;
        definitenotcells = z < lowThresh;
        
        % Find the cells that are only in Red but not in Green channel.
        notMixedCellsROI = zeros(mROI, nROI);
        foundNotMixedCells = bwareaopen(imfill(cellsRedROI & definitenotcells, 'holes'), 500);
        notMixedCellsProps = regionprops(foundNotMixedCells, 'all');
        notMixedCellsCentroids = [notMixedCellsProps.Centroid];
        notMixedCellsCentroidsX = notMixedCellsCentroids(1:2:end-1);
        notMixedCellsCentroidsY = notMixedCellsCentroids(2:2:end);
        for i=1:length(notMixedCellsCentroidsX)
            cell = bwselect(cellsRedROI, notMixedCellsCentroidsX(i), notMixedCellsCentroidsY(i));
            notMixedCellsROI = notMixedCellsROI | cell;
        end
        
        % Find the cells that are both in Red and Green channels.
        mixedCellsROI = zeros(mROI, nROI);
        foundMixedCells = bwareaopen(imfill(cellsRedROI & ~notMixedCellsROI & definitecells, 'holes'), 500);
        mixedCellsProps = regionprops(foundMixedCells, 'all');
        mixedCellsCentroids = [mixedCellsProps.Centroid];
        mixedCellsCentroidsX = mixedCellsCentroids(1:2:end-1);
        mixedCellsCentroidsY = mixedCellsCentroids(2:2:end);
        for i=1:length(mixedCellsCentroidsX)
            cell = bwselect(cellsRedROI, mixedCellsCentroidsX(i), mixedCellsCentroidsY(i));
            mixedCellsROI = mixedCellsROI | cell;
        end
        
        % All left over cells are considered unknown.
        maybeMixedCellsROI = cellsRedROI & ~mixedCellsROI & ~notMixedCellsROI;
        
        mixedCells(y1:y2, x1:x2) = mixedCellsROI;
        notMixedCells(y1:y2, x1:x2) = notMixedCellsROI;
        maybeMixedCells(y1:y2, x1:x2) = maybeMixedCellsROI;
    end
end
end

