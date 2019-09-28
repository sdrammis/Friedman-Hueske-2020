function PVDendriteDetection_run_stain2(exid, imgSrc, realsize, ~, manualDir, ~, dataFile)
THRESHOLDS = {0, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240 };

data = load(dataFile);
image = img_read_visible(imgSrc);
f = figure;
imshow(image);
saveas(f, sprintf('%s/%s-original.png', manualDir, exid));
close all;

[n, m] = size(image);
realdensity = n*m/realsize;
refdensity = 109310000;
sizefactor = realdensity/refdensity;

% top left corner of regions to sample manual check images
displayRegionLength = 2000;
displayRegions = { ...
    [floor(n/2) floor(m/2)], ...
    [floor(n/4) floor(m/4)], ...
    [floor(3*n/4) floor(3*m/4)]};

% Try random filters 30 works well
C = im2uint8(fibermetric(image,30,'StructureSensitivity',3));
sharp = imsharpen(C);

for i = 1:length(THRESHOLDS)
    threshold = THRESHOLDS{i};
    
    threshed = sharp > threshold;
    removed1 = bwareaopen(threshed,round(500*sizefactor));
    filled = imfill(removed1,'holes');
    
    % combine nearby dendrites
    se1 = strel('line',round(10*sqrt(sizefactor)),0);
    se2 = strel('line',round(14*sqrt(sizefactor)),45);
    se3 = strel('line',round(10*sqrt(sizefactor)),90);
    se4 = strel('line',round(14*sqrt(sizefactor)),135);
    closeBW = imclose(filled,se1);
    closeBW = imclose(closeBW,se2);
    closeBW = imclose(closeBW,se3);
    closeBW = imclose(closeBW,se4);
    removed2 = imfill(closeBW,'holes');
    removed2 = bwareaopen(removed2,round(9000*sizefactor));
    final = image;
    final(~removed2) = 0;
    
    dendrites = final & filled;
    save(sprintf('%s/%s-%d-data.mat', manualDir, exid, i), 'dendrites', 'threshold', '-v7.3')
    
    % create manual check images for regions
    for j=1:length(displayRegions)
        % save sample image for manual checking
        region = displayRegions{j};
        r = region(1); c = region(2);
        imgRegion = image(r:r+displayRegionLength, c:c+displayRegionLength);
        regionDendrites = dendrites(r:r+displayRegionLength, c:c+displayRegionLength);
        regionShow = imgRegion;
        regionShow(~regionDendrites) = 0;
        f = figure;
        imshow(regionShow);
        saveas(f, sprintf('%s/%s-%d-%d.png', manualDir, exid, i, j));
        
        % save original image as reference for manual verification
        f2 = figure;
        imshow(imgRegion);
        saveas(f2, sprintf('%s/%s-%d-original.png', manualDir, exid, j));
        close all;
    end
    
    green = create_color_img(n, m, 0, 255, 0);
    pink = create_color_img(n, m, 255, 110, 170);
    yellow = create_color_img(n, m, 255, 255, 0);
    f = figure;
    imshow(imread(imgSrc));
    hold on;
    h1 = imshow(yellow);
    hold on
    h2 = imshow(green);
    hold on;
    h3 = imshow(pink);
    hold off
    set(h1, 'AlphaData', data.striatumMask * 0.1);
    set(h2, 'AlphaData', dendrites * 0.3);
    set(h3, 'AlphaData', data.cells);
    saveas(f, sprintf('%s/%s-%d.png', manualDir, exid, i));
    save(sprintf('%s/%s-%d-data.mat', manualDir, exid, i), 'dendrites', 'threshold', '-v7.3')
    close all;
end
end
