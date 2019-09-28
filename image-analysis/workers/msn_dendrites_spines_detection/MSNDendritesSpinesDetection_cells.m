function cells = MSNDendritesSpinesDetection_cells(img, realsize, threshold)
imsize = size(img);
realdensity = imsize(1)*imsize(2)/realsize;
refdensity = 93491573.7779782;  % pixel density of reference image 07272018Alexander63xtest-Region 001_Fitc.tiff
sizefactor = realdensity/refdensity;

windowHeight = floor(imsize(1) / 10);
windowWidth = floor(imsize(2) / 10);
numRows = floor(imsize(1) / windowHeight);
numCols = floor(imsize(1) / windowHeight);

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
        thresholded = find(csumnorm1 > threshold);
        cellsWindow = MSNDendritesSpinesDetection_cells_region(ROI, thresholded(1), sizefactor);
        cells(y1:y2, x1:x2) = cellsWindow;
    end
end
cells = ceil(imgaussfilt(cells,5));
end
