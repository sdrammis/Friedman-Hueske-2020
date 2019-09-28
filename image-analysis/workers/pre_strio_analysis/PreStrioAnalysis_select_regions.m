function PreStrioAnalysis_select_regions(exid, outDir, tmpDir, ~, imgSrc)
NUM_REGIONS = 4;
masks = cell(NUM_REGIONS, 1);

img = img_read_visible(imgSrc);

imgInfo = imfinfo(imgSrc);
bitDepth = imgInfo.BitDepth;
if bitDepth == 16
    img = uint8(img / 256);
end
imgOriginal = img;

[r, c] = size(img);
img = imresize(img, [floor(r/10), floor(c/10)]);
[rSmall, cSmall] = size(img);
selected = logical(zeros(rSmall, cSmall));

for i = 1:NUM_REGIONS
    imshow(img);
    region = imfreehand;
    mask = createMask(region);
    mask(selected) = 0;
    masks{i} = imresize(mask, [r c]);
    
    img = imsubtract(img, im2uint8(mask));
    selected = or(selected, mask);
end
close all;

% images for manual check
imwrite(imresize(imgOriginal, 0.1), sprintf('%s/%s-original.png', tmpDir, exid));
imwrite(img, sprintf('%s/%s-regions-removed.png', tmpDir, exid));
% data for next worker
save(sprintf('%s/%s-data.mat', outDir, exid), 'masks')
end
