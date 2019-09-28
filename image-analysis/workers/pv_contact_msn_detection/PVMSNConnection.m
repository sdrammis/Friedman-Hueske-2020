%% Load all necessary files
load('pvcells.mat');
pvcells = final;
load('pvdendrites.mat');
pvdendrites = corrected;
%load('msncells.mat');  %cannot do this on alexander's comp
%msncells = cells;
%% Load necessary images
pvimage = imread('\\chunky.mit.edu\analysis3\Strio_scan_AF_EH_EN\Alexander_Emily_Erik\exported experiment 1 full range\region 003\z-stack\alexander63xstriosomesfirstcohort2018-08-25 18-50 f-region 003_texa.tiff');
msnimage = imread('\\chunky.mit.edu\analysis3\Strio_scan_AF_EH_EN\Alexander_Emily_Erik\exported experiment 1 full range\region 003\z-stack\alexander63xstriosomesfirstcohort2018-08-25 18-50 f-region 003_fitc.tiff');
imsize = size(pvimage);
realsize = 3.2615;  % width * height  mm^2 (THIS COMES FROM QUILEE'S TEXT DOCUMENTS)
realdensity = imsize(1)*imsize(2)/realsize;
refdensity = 109310000;  % pixel density of reference image alexander63xstriosomesfirstcohort2018-08-25 18-50 f-region 003_texa.tiff
sizefactor = realdensity/refdensity;
%% Subtract pv cells from dendrites and find min value of dendrites
onlydendrites = pvdendrites & xor(pvcells,pvdendrites);
pvcopy = pvimage;
pvcopy(~onlydendrites) = 0;
loghisto = log(imhist(pvcopy));
histo = exp(loghisto(2:256));
maxima = find(histo == max(histo));   % the method to find the threshold is subject to change
threshold = maxima(1);
%% Expand MSN cells in a circular manner
se = strel('disk',round(sizefactor*10));   % this is subject to change
ROI = imdilate(msncells, se);
%% Create binary mask consisting only of pv pixels greater than the threshold and near the msn cells
output = msnimage;
output(~ROI) = 0;
output = output >= threshold;
fig1 = figure(1);
imshow(output);