function PVCellBodyDetection_run(exid, imgSrc, realsize, ~, manualDir, ~)
% Example
% imgSrc = '../Alexander_Emily_Erik/FINAL EXPORTED IMAGES/Alexander63xStriosomesFirstCohort2018-08-25 18-50 F-Region 003_Texa.tiff'
% realsize = 3.2615
% PVCellBodyDetection_run(NaN,imgSrc,realsize,NaN,NaN,NaN);

image = imread(imgSrc); % load the cell body image (now Fitc channel)
fig1 = figure(1);
imshow(image);
imsize = size(image);
realdensity = imsize(1)*imsize(2)/realsize;
refdensity = 109310000;  % pixel density of reference image 07272018Alexander63xtest-Region 001_Fitc.tiff
sizefactor = realdensity/refdensity;

end