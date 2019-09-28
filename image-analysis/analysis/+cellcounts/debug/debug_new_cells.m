% img1 = imread('./debug-1.tiff');
% img2 = imread('./debug-2.tiff');
% img3 = imread('./debug-3.tiff');
% 
% img = img3;
% cells = find_red_cells(img, 2.1);
% figure;
% imshow(imoverlay(mat2gray(img), bwperim(cells), [0 1 0]));

green3 = imread('./debug-3-green.tiff');
green = green3;
[mixedCells, maybeMixedCells, notMixedCells] = ...
    label_cells(cells, green, -0.1, 1.3);
o1 = imoverlay(zscore(double(green)), bwperim(mixedCells), 'r');
o2 = imoverlay(o1, bwperim(maybeMixedCells), 'y');
o3 = imoverlay(o2, bwperim(notMixedCells), 'c');
figure;
imshow(o3);


