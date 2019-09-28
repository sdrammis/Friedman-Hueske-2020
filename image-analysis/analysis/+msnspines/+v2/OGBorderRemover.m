function [ImageReSized, row1, row2, col1, col2, rowOG, colOG] = OGBorderRemover(imgStr, xSize, ySize)
rgbImage = imread(imgStr);

[rowOG,colOG] = size(rgbImage);

grayImage = min(rgbImage, [], 3);
%grayImage = min(imgStr, [], 3);
binaryImage = grayImage < 200;
binaryImage = bwareafilt(binaryImage, 1);
[rows, columns] = find(binaryImage);
row1 = min(rows);
row2 = max(rows);
col1 = min(columns);
col2 = max(columns);
% Crop
croppedImage = rgbImage(row1:row2, col1:col2, :);
%croppedImage = imgStr(row1:row2, col1:col2, :);
%imshow(croppedImage)

%dir returns everything in directory
%regular expression - put any text and then returns items with same input
%wildcard 

ImageReSized = imresize(croppedImage, [xSize,ySize]);