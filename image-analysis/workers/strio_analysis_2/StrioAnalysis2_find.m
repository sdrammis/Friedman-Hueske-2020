function [centers, rims] = StrioAnalysis2_find(ROI, thresh1, thresh2, noise1, noise2)
GAUSS_FACT1 = 1;
GAUSS_FACT2 = 1;

loghisto1 = log(imhist(ROI));
histo1 = 10.^loghisto1;
csum1 = cumsum(histo1(2:256));
csumnorm1 = csum1/csum1(255);

centers = ROI > find(csumnorm1 >= thresh1, 1);
centers = imgaussfilt(im2uint8(centers), GAUSS_FACT1);
centers = im2bw(centers,0);
% removes small pixels in the image and updates the final image
centers = bwareaopen(centers, noise1);

centerAndRim = ROI > find(csumnorm1 >= thresh2,1);
centerAndRim = imgaussfilt(im2uint8(centerAndRim), GAUSS_FACT2);
centerAndRim = im2bw(centerAndRim,0);
% removes small pixels in the image and updates the final image
centerAndRim = bwareaopen(centerAndRim, noise2);

rims = xor(centers, centerAndRim);
end

