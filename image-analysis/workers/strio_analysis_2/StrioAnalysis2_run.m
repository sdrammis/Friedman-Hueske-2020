function StrioAnalysis2_run(exid, imgSrc, realsize, ~, manualDir, ~)
THRESHOLDS_1 = {0.9995, 0.999, 0.995};
THRESHOLDS_2 = {0.999, 0.994, 0.99};

img = img_read_visible(imgSrc);

%% compute image processing variables
[imgHeight, imgWidth] = size(img);
realdensity = imgWidth*imgHeight/realsize;
refdensity = 337641472/(7.7784*4.6431);  % pixel density of reference image 05292018StriazomeMatrixGraybielFriedman-Region 029_Cy5
noise1 = round(4500*realdensity/refdensity);
noise2 = round(3000*realdensity/refdensity);

%% split into ROIs
ROI1 = img(1:floor(imgHeight/2), 1:floor(imgWidth/2));
ROI2 = img(1:floor(imgHeight/2), floor(imgWidth/2)+1:imgWidth);
ROI3 = img(floor(imgHeight/2)+1:imgHeight, 1:floor(imgWidth/2));
ROI4 = img(floor(imgHeight/2)+1:imgHeight, floor(imgWidth/2)+1:imgWidth);
ROIs = {ROI1, ROI2, ROI3, ROI4};

numRegions = length(ROIs);
numThresholds = length(THRESHOLDS_1);
%% run extraction
centers = cell(numRegions, numThresholds);
rims = cell(numRegions, numThresholds);

for j=1:numThresholds
    thresh1 = THRESHOLDS_1{j};
    thresh2 = THRESHOLDS_2{j};
        
    for i=1:numRegions
        ROI = ROIs{i};
        loghisto1 = log(imhist(ROI));
        histo1 = 10.^loghisto1;
        csum1 = cumsum(histo1(2:256));
        csumnorm1 = csum1/csum1(255);
        
        [ROICenters, ROIRims] = ...
            StrioAnalysis2_find(ROI, thresh1, thresh2, noise1, noise2);
        centers{i, j} = ROICenters;
        rims{i, j} = ROIRims;
        
        f = figure;
        centersResized = imresize(ROICenters, 0.2);
        rimsResized = imresize(ROIRims, 0.2);
        ROIResized = imresize(ROI, 0.2);
        green = cat(3, centersResized*0, centersResized*1, centersResized*0);
        magenta = cat(3, rimsResized*1,rimsResized*0,rimsResized*1);
        imshow(ROIResized);
        hold on;
        h = imshow(green);
        hh = imshow(magenta);
        hold off
        set(h, 'AlphaData', centersResized * 0.2);
        set(hh, 'AlphaData', rimsResized * 0.2);
        saveas(f, sprintf('%s/%s-%d-%d.png', manualDir, exid, i, j));
        f2 = figure;
        imshow(ROIResized);
        saveas(f2, sprintf('%s/%s-%d-original.png', manualDir, exid, i));
        close all;
    end
    save(sprintf('%s/%s-data.mat', manualDir, exid), 'centers', 'rims', 'imgWidth', 'imgHeight')
end
end

