function PVCellBodyDetection_run_stain1(exid, imgSrc, realsize, ~, manualDir, ~)
THRESHOLDS = {0.6, 0.7, 0.8};
width = 160;
height = 140;

img = imread(imgSrc);

imgInfo = imfinfo(imgSrc);
bitDepth = imgInfo.BitDepth;
if bitDepth == 16
    img = uint8(img / 256);
end

[m, n] = size(img);
realdensity = m*n/realsize;
refdensity = 93491573.7779782;  % pixel density of reference image 07272018Alexander63xtest-Region 001_Fitc.tiff
sizefactor = realdensity/refdensity;

for i = 1:length(THRESHOLDS)
    threshold = THRESHOLDS{i};
    threshed = zeros(m, n);
    for x = 1:width/2:(n-width)
        for y = 1:height/2:(m-height)
            ROI = img(y:y+height,x:x+width);
            variance = var(double(ROI(:)));
            if variance >= 200
                loghisto1 = log(imhist(ROI));
                histo1 = exp(loghisto1(2:256));
                csum1 = cumsum(histo1);
                csumnorm1 = csum1/csum1(length(csum1));
                thresh = find(csumnorm1 > threshold);
                ROIthreshed = ROI > thresh(1);
                threshed(y:y+height,x:x+width) = ROIthreshed;
            end
        end
    end
    cells = imfill(threshed,'holes');
    cells = bwareaopen(cells,round(sizefactor*1000));
    se = strel('disk',round(sizefactor*10));
    cells = imopen(cells,se);
    cells = bwareaopen(cells,round(sizefactor*1500));
    save(sprintf('%s/%s-%d-data.mat', manualDir, exid, i), 'cells', 'threshold', '-v7.3')
    
    % Display for manual verification
    cellsResized = imresize(cells, 0.2);
    imageResized = imresize(img, 0.2);
    green = cat(3,cellsResized*0,logical(cellsResized),cellsResized*0);
    f = figure;
    imshow(imageResized);
    hold on
    h = imshow(green);
    hold off
    set(h, 'AlphaData',  cellsResized * 0.5  + ~cellsResized * 0);
    saveas(f, sprintf('%s/%s-%d.png', manualDir, exid, i));
    close all;
end
% Display original downsampled as reference for manual verification
f2 = figure;
imshow(imageResized);
saveas(f2, sprintf('%s/%s-original.png', manualDir, exid));
close all;
end