function StrioAnalysis_run(exid, imgSrc, realsize, ~, manualDir, doneDir, data)
RESIZE_SIZE = 0.1;

load(data, 'masks');
save(sprintf('%s/%s-masks.mat', doneDir, exid), 'masks')

imgDisp = img_read_visible(imgSrc);
if contains(exid, 'cc')
    img = imgaussfilt(img_read_visible(imgSrc));
else
    img = imgDisp;
end

imgInfo = imfinfo(imgSrc);
bitDepth = imgInfo.BitDepth;
if bitDepth == 16
    img = uint8(img / 256);
end

%% compute image processing variables
imagesize = size(img);
realdensity = imagesize(1)*imagesize(2)/realsize;
refdensity = 337641472/(7.7784*4.6431);  % pixel density of reference image 05292018StriazomeMatrixGraybielFriedman-Region 029_Cy5
noise1 = round(4500*realdensity/refdensity);
noise2 = round(3000*realdensity/refdensity);
gaussfact1 = 1;
gaussfact2 = 1;

%% run detection
for i=1:length(masks)
    ROI = img;
    mask = ~masks{i};
    ROI(mask) = 0;
    
    % Don't run thresholding on masks with 0 area.
    if sum(~mask(:)) == 0
        f = imshow(imresize(imgDisp, RESIZE_SIZE));
        saveas(f, sprintf('%s/%s-original-%d.png', manualDir, exid, i));
        
        for j=1:3
            saveas(f, sprintf('%s/%s-%d-%d.png', manualDir, exid, i, j));
        end
        close all;
        continue;
    end
    
    maskResized = imresize(~mask, RESIZE_SIZE);
    yellow = cat(3, maskResized*1, maskResized*1, maskResized*0);
    f = imshow(imresize(imgDisp, RESIZE_SIZE));
    hold on;
    h = imshow(yellow);
    set(h, 'AlphaData', 0.3);
    saveas(f, sprintf('%s/%s-original-%d.png', manualDir, exid, i));
    close all;
     
    loghisto1 = log(imhist(ROI));
    histo1 = exp(loghisto1);
    csum1 = cumsum(histo1);
    csumnorm1 = csum1/csum1(256);
    newcs = cumsum(diff(csumnorm1));
    newcsn = newcs/newcs(255);
    left = find(newcsn >= .85);
    left = left(1);
    right = find(newcsn >=.95);
    right = right(1)-1;
    difference = right - left;
%     thresh1 = .95*.9702*exp(-0.0001893*difference);
%     thresh2 = .95*.943*exp(-0.002085*difference);
%     thresholds1 = { thresh1 - 0.02, thresh1, thresh1 + 0.02 };
%     thresholds2 = { thresh2 - 0.02, thresh2, thresh2 + 0.02 };
    thresholds1 = {0.8, 0.7, 0.9};
    thresholds2 = {0.6, 0.5, 0.8};
    
    threshMap = containers.Map({'thresholds1', 'thresholds2'}, {thresholds1, thresholds2});
    fid = fopen(sprintf('%s/%s-threshs.json', manualDir, exid), 'w');
    if fid == -1, error('Cannot create JSON file'); end
    fwrite(fid, jsonencode(threshMap), 'char');
    fclose(fid);
    
    for j = 1:length(thresholds1)
        thresh1 = thresholds1{j};
        thresh2 = thresholds2{j};
        
        center = ROI > find(newcsn >= thresh1, 1);
        center = imgaussfilt(im2uint8(center),gaussfact1);
        center = im2bw(center,0);
        % removes small pixels in the image and updates the final image
        center = bwareaopen(center, noise1);
        
        centerAndRim = ROI > find(newcsn >= thresh2,1);
        centerAndRim = imgaussfilt(im2uint8(centerAndRim),gaussfact2);
        centerAndRim = im2bw(centerAndRim,0);
        % removes small pixels in the image and updates the final image
        centerAndRim = bwareaopen(centerAndRim, noise2);
        
        rim = xor(center, centerAndRim);
        
        centerResized = imresize(center, RESIZE_SIZE);
        rimResized = imresize(rim, RESIZE_SIZE);
        imgResized = imresize(imgDisp, RESIZE_SIZE);
        green = cat(3, centerResized*0, centerResized*1, centerResized*0);
        magenta = cat(3, rimResized*1,rimResized*0,rimResized*1);
        f = figure;
        imshow(imgResized);
        hold on
        h = imshow(green);
        hh = imshow(magenta);
        hold off
        set(h, 'AlphaData', centerResized * 0.2);
        set(hh, 'AlphaData', rimResized * 0.2);
        
        saveas(f, sprintf('%s/%s-%d-%d.png', manualDir, exid, i, j));
        close all;
    end
end
end
