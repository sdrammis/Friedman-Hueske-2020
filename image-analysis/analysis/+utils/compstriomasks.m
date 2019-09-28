function [strio, matrix] = compstriomasks(imgPth, masksPth, thrshsPth, realsize, varargin)
if contains(varargin, 'cc')
   img = imgaussfilt(utils.imreadvisible(imgPth));
else
   img = utils.imreadvisible(imgPth);
end

imgInfo = imfinfo(imgPth);
bitDepth = imgInfo.BitDepth;
if bitDepth == 16
    img = uint8(img / 256);
end

masks = load(masksPth);
threshs = jsondecode(fileread(thrshsPth));

[m ,n] = size(img);
realdensity = m*n/realsize;
refdensity = 337641472/(7.7784*4.6431);  
noise2 = round(3000*realdensity/refdensity);
centersAndRims = zeros(m, n);

for i=1:length(masks.masks)
    ROI = img;
    ROI(~masks.masks{i}) = 0;
    thresh = threshs.(['region' num2str(i)]);
    thresh1 = thresh.thresh1;
    thresh2 = thresh.thresh2;
    
    if isempty(thresh1) || isempty(thresh2)
        continue;
    end
    
    loghisto1 = log(imhist(ROI));
    histo1 = exp(loghisto1);
    csum1 = cumsum(histo1);
    csumnorm1 = csum1/csum1(256);
    newcs = cumsum(diff(csumnorm1));
    newcsn = newcs/newcs(255);
    
    centerAndRim = ROI > find(newcsn >= thresh2,1);
    centerAndRim = imgaussfilt(im2uint8(centerAndRim), 1);
    centerAndRim = im2bw(centerAndRim,0);
    % removes small pixels in the image and updates the final image
    centerAndRim = bwareaopen(centerAndRim, noise2);
    centersAndRims = centersAndRims | centerAndRim;
end

imgBlur = imgaussfilt(img, 40);
h = imhist(img);
m = find(h == max(h));
fibersOfPassage = ~(imgBlur > m);

hull = bwconvhull(centersAndRims);
centersAndRimsFilled = imfill(centersAndRims, 'holes');

strio = centersAndRimsFilled & ~fibersOfPassage;
matrix = hull & ~fibersOfPassage & ~centersAndRimsFilled;
end