function MSNCellBodyDetection_run(exid, imgSrc, realsize, ~, manualDir, ~)
THRESHOLDS = {0.97, 0.98, 0.99};
RESIZE_SIZE = 0.3;

img = imread(imgSrc); % load the cell body image (now Fitc channel)

imgInfo = imfinfo(imgSrc);
bitDepth = imgInfo.BitDepth;
if bitDepth == 16
    img = uint8(img / 256);
end

f = figure;
imgResized = imresize(img, RESIZE_SIZE); 
imshow(mat2gray(imgResized));
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
            thresholded = find(csumnorm1 > threshold);
            cellsWindow = MSNCellBodyDetection_find(ROI, thresholded(1), sizefactor);
            cells(y1:y2, x1:x2) = cellsWindow;
        end
    end
   
    cellsResized = imresize(cells, RESIZE_SIZE); 
    green = cat(3,cellsResized*0,logical(cellsResized),cellsResized*0);
    f = figure;
    imshow(mat2gray(imgResized));
    hold on
    h = imshow(green);
    hold off
    set(h, 'AlphaData', cellsResized * 0.3  + ~cellsResized * 0);
    saveas(f, sprintf('%s/%s-%d.png', manualDir, exid, i));
    save(sprintf('%s/%s-%d-data.mat', manualDir, exid, i), 'cells', 'threshold', '-v7.3');
    close all;
end
savejson('', struct('thresholds', cell2mat(THRESHOLDS)), sprintf('%s/%s-data.json', manualDir, exid));
end
