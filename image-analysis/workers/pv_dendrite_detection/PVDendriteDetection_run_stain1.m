function PVDendriteDetection_run_stain1(exid, imgSrc, realsize, ~, manualDir, ~, dataFile)
THRESHOLD_SHIFTS = { 0.06, 0.03, 0 };

img = imread(imgSrc);

f = figure;
imshow(img);
saveas(f, sprintf('%s/%s-original.png', manualDir, exid));
close all;

[n,m] = size(img);
realdensity = n*m/realsize;
refdensity = 95867000;  % pixel density of reference image Alexander63xStriosomesFirstCohort2018-08-25 18-50 F-Region 006_Fitc.tiff
sizefactor = realdensity/refdensity;

% subtract out cell bodies
data = load(dataFile);
img = immultiply(img, ~data.cells);

% compute histogram
loghisto = log(imhist(img));
histo = exp(loghisto(2:256));
[~,I] = max(histo);
csum = cumsum(histo(I(length(I))+1:end));
csumnorm = csum/csum(length(csum));

% apply thresholding
for i=1:length(THRESHOLD_SHIFTS)
    t = data.threshold - THRESHOLD_SHIFTS{i};
    threshold = find(csumnorm > t,1)+I(length(I));
    imgThresholded = img > threshold;
    dendrites = bwareaopen(imgThresholded,round(3000*sizefactor));
    
    green = create_color_img(n, m, 0, 255, 0);
    pink = create_color_img(n, m, 255, 110, 170);
    yellow = create_color_img(n, m, 255, 255, 0);
    f = figure;
    imshow(img);
    hold on;
    h1 = imshow(yellow);
    hold on
    h2 = imshow(green);
    hold on;
    h3 = imshow(pink);
    hold off
    set(h1, 'AlphaData', data.striatumMask * 0.1);
    set(h2, 'AlphaData', dendrites);
    set(h3, 'AlphaData', data.cells);
    saveas(f, sprintf('%s/%s-%d.png', manualDir, exid, i));
    save(sprintf('%s/%s-%d-data.mat', manualDir, exid, i), 'dendrites', 'threshold', '-v7.3')
    close all;
end
end

