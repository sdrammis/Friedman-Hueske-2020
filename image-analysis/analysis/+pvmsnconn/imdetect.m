function [cellsMSN, blobsPV] = imdetect(srcMSN, srcPV, debugDir)
% Run MSN cell body detection and PV blob detection the input zStack images.
% Optionally supply a debug directory to store output detection images. 

imgMSN = imread(srcMSN);
imgPV = imread(srcPV);
if ~isempty(debugDir)
    mkdir(debugDir);
end

cellsMSN = utils.msn.findcellsZ(srcMSN,2);
stats = regionprops(cellsMSN,'all');

[r,c] = size(imgMSN);
blobsPV = zeros(r,c);
blobCount = 0;
se = strel('disk',12,0);
smallSE = strel('disk',2,0);
numberOfCells = size(stats,1);
for i=1:numberOfCells
    singleCellCentroid = stats(i).Centroid;
    cell = bwselect(cellsMSN, singleCellCentroid(1), singleCellCentroid(2));
    halfSizeLen = max(size(stats(i).Image));
    
    x = singleCellCentroid(1);
    y = singleCellCentroid(2);
    
    r1 = round(y-halfSizeLen);
    r2 = round(y+halfSizeLen);
    c1 = round(x-halfSizeLen);
    c2 = round(x+halfSizeLen);
    
    cellROI = cell(r1:r2,c1:c2);
    expandedcell = imdilate(cellROI,se);
    shrunkencell = imerode(cellROI,se);
    rim = expandedcell & ~shrunkencell;
    region = imgPV(r1:r2,c1:c2);
    cellRegion = region;
    cellRegion(~expandedcell) = 0;

    [Gmag, ~] = imgradient(region);
    region(~rim) = 0;
    Gmag(~expandedcell) = 0;
    maxGrad = max(max(Gmag(expandedcell)));
    minGrad = min(min(Gmag(expandedcell)));
    minMax = (Gmag-minGrad)/(maxGrad-minGrad);
    threshed = minMax > 0.25; % was .18
    refilled = bwareaopen(imfill(threshed, 'holes'), 8, 4);
    bridged = imfill(bwmorph(refilled, 'bridge'), 'holes');
    potentialBlobs = imerode(bridged, smallSE) & rim;
    blobMeasurements = regionprops(potentialBlobs, 'all');
    
    numberOfBlobs = size(blobMeasurements, 1);
    rimMean = mean(double(region(rim)));
    rimSTD = std(double(region(rim)));
    windowBlobLabels = zeros(size(region));
    for k=1:numberOfBlobs
        thisBlobsPixels = blobMeasurements(k).PixelIdxList;
        blobArea = blobMeasurements(k).Area;
        blobSolidity = blobMeasurements(k).Solidity;
        energy = sum(((double(cellRegion(thisBlobsPixels))-rimMean)/rimSTD) .^ 3) / blobArea;
        
        if energy < 10 || blobArea < 6
            continue;
        elseif blobArea < 100 && blobSolidity > .83
            blobPixels = blobMeasurements(k).PixelIdxList;
            blobCount = blobCount + 1;
            windowBlobLabels(blobPixels) = blobCount;
            continue;
        end   
    end
    blobsPV(r1:r2,c1:c2) = windowBlobLabels;
    
    % Debug figures
    if ~isempty(debugDir)
        o1 = imoverlay(mat2gray(cellRegion), bwperim(cellROI), 'g');
        o1 = imoverlay(o1, bwperim(shrunkencell), 'g');
        o1 = imoverlay(o1, mat2gray(windowBlobLabels), 'r');
        
        msnROI = imgMSN(y-halfSizeLen:y+halfSizeLen,x-halfSizeLen:x+halfSizeLen);
        o2 = imoverlay(mat2gray(msnROI), bwperim(cellROI), 'g');
        o2 = imoverlay(o2, mat2gray(windowBlobLabels), 'r');
        
        splits1 = split(srcMSN, '/');
        splits2 = split(splits1{end}, '.');
        sliceStackName = splits2{1};
        f1 = figure;
        subplot(2,2,1);
        imshow(mat2gray(cellRegion));
        subplot(2,2,2);
        imshow(o1);
        subplot(2,2,3);
        imshow(mat2gray(msnROI));
        subplot(2,2,4);
        imshow(o2);
        saveas(f1, [debugDir '/' sliceStackName '_cell' num2str(i) '_fig1.png']);
        f2 = figure;
        subplot(1,2,1);
        imshow(Gmag/256^2);
        subplot(1,2,2);
        imshow(refilled);
        saveas(f2, [debugDir '/' sliceStackName '_cell' num2str(i) 'fig2.png']);
        close all;
    end
end
end