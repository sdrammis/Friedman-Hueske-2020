%crops mask
MSK_GEN_PTH = '/Users/kadendimarco/documents/striomatrix/Spine_Analysis/makeMask.js';

setenv('PATH', [getenv('PATH') ':/usr/local/bin']);

fname = 'exp1_2553_slice1_18-11-15-threshs.json';
execution = 'exp1_2553_slice1_18-11-15';

[status, cmdout] = system(['node ' MSK_GEN_PTH ' ' fname ' ' execution]);


for r=1:numRows
    for c=1:numCols

    end
end


msk = imread(execution);
%imshow(msk);

[croppedOGImage, row1, row2, col1, col2] = OGBorderRemover('exp1_2553_slice1_18-11-15-4-3.png');

croppedImage = maskBorderRemover(msk, row1, row2, col1, col2);
imshow(croppedImage)


% 
% jsonval = jsondecode(fileread(fname));
% 
% Mask1DArray = jsonval.regionMaskMap{1,1}{2,1}.mask;
% Mask2DArrayFlipped = reshape(Mask1DArray, [500,500]);
% Mask2DArray = Mask2DArrayFlipped.';
% 
% imshow(Mask2DArray)
