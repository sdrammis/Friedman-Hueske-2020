function [strio, matrix] = compstriomasks1(imgPth, masksPth, thrshsPth, realsize, varargin)
img = utils.imreadvisible(imgPth);

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

hull = bwconvhull(centersAndRims);
centersAndRimsFilled = imfill(centersAndRims, 'holes');

strioImg = img;
strioImg(~centersAndRimsFilled) = 0;

strioFat = imgaussfilt(im2uint8(centersAndRimsFilled), 100);
strioFat(strioFat > 0) = 255;
matrixImg = img;
matrixImg(~hull | strioFat) = 0;

if isempty(varargin)
    strio = removeFibersOfPassage(strioImg);
    matrix = removeFibersOfPassage(matrixImg);
    strio = strio & centersAndRimsFilled;
elseif strcmp(varargin{1}, 't')
    strio = removeFibersOfPassage(strioImg, varargin{2});
    matrix = removeFibersOfPassage(matrixImg, varargin{2});
    strio = strio & centersAndRimsFilled;
else
    fibersOfPassage = varargin{2};
    strio = centersAndRimsFilled & ~fibersOfPassage;
    matrix = hull & ~fibersOfPassage & ~strioFat;
end
end


function mask = removeFibersOfPassage(img, varargin)
imgBlur = imgaussfilt(img, 30);
h = imhist(imgBlur);
m = find(h == max(h(2:end)));

if ~isempty(varargin)
    t = varargin{1};
else  
    t = floor(m / 2);
    mask = (imgBlur > t);
end

%f = figure('units','normalized','outerposition',[0 0 1 1]);
%subplot(1,3,1);
%hold on;
%plot(h);
%plot([t t], [0 10^7]);
%subplot(1,3,2);
%imshow(img);
%subplot(1,3,3);
%imshow(mask);
end
