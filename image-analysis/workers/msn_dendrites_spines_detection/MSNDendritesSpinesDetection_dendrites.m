function dendrites = MSNDendritesSpinesDetection_dendrites(img, realsize, cells, threshold)
[n, m] = size(img);
realdensity = n*m/realsize;
refdensity = 95867000;  % pixel density of reference image Alexander63xStriosomesFirstCohort2018-08-25 18-50 F-Region 006_Fitc.tiff
sizefactor = realdensity/refdensity;

imgSubCells = immultiply(img, ~cells);
loghisto = log(imhist(imgSubCells));
histo = exp(loghisto(2:256));
[~,I] = max(histo);
csum = cumsum(histo(I(length(I))+1:end));
csumnorm = csum/csum(length(csum));

thresholded = find(csumnorm > threshold,1)+I(length(I));
imgThresholded = imgSubCells > thresholded;
dendrites = bwareaopen(imgThresholded,round(3000*sizefactor));
end

