function [imgRzd] = maskBorderRemover(Image, row1, row2, col1, col2, xSize, ySize, rowOG, colOG)
firstRzd = imresize(Image, [rowOG, colOG]);
croppedImage = firstRzd(row1:row2, col1:col2, :);
imgRzd = imresize(croppedImage, [xSize, ySize]);