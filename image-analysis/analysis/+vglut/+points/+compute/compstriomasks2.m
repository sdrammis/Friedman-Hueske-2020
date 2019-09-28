function [strio, matrix] = compstriomasks2(imgPth, vglutImgPth, masksPth, thrshsPth, realsize, varargin)
img = uint8(utils.imreadvisible(imgPth) / 256);

imgVglut = imread(vglutImgPth);
vglutImgInfo = imfinfo(vglutImgPth);
bitDepth = vglutImgInfo.BitDepth;
if bitDepth == 16
    imgVglut = uint8(imgVglut / 256);
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

imgBlur = imgaussfilt(imgVglut, 35);
h_ = imhist(imgVglut);
h = h_(2:end); % Remove 0 value.
m = find(h == max(h));
[pksh, locsh] = findpeaks(h(1:m+1));
locsh = locsh(pksh>5000);
dh = smooth([0; diff(h)], 15);
if isempty(varargin)
    [~,locsdh] = findpeaks(max(dh) - dh);
    flocs = flip(locsdh(locsdh < m));
    if isempty(flocs)
        t = m - 5;
    else
        t = (flocs(1) + locsh(end)) / 2;
    end
    fibersOfPassage = ~(imgBlur > t);
elseif strcmp(varargin{1}, 't')
    t = varargin{2};
    fibersOfPassage = ~(imgBlur > t);
else
    t = -1;
    fibersOfPassage = varargin{2};
end


%if t > 0
%    % Image for debugging purposes.
%    vglutImVis = utils.imreadvisible(vglutImgPth);
%    vh = imhist(vglutImVis);
%    vh = vh(vh > 0);
%    f = figure('units','normalized','outerposition',[0 0 1 1]);
%    subplot(2,2,[1 3]);
%    hold on;
%    findpeaks(h(1:m+1));
%    plot(dh);
%    findpeaks(max(dh)-dh);
%    plot(vh);
%    plot([t t], [0 3.5*10^6]);
%    subplot(2,2,2);
%    imshow(imgVglut);
%    subplot(2,2,4);
%    imshow(fibersOfPassage)
%end

hull = bwconvhull(centersAndRims);
centersAndRimsFilled = imfill(centersAndRims, 'holes');

strioFat = imgaussfilt(im2uint8(centersAndRimsFilled), 100);
strioFat(strioFat > 0) = 255;

strio = centersAndRimsFilled & ~fibersOfPassage;
matrix = hull & ~fibersOfPassage & ~strioFat;
end
