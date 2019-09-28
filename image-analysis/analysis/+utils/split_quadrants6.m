function [topLeft, topMid, topRight, ...
        botLeft, botMid, botRight] = split_quadrants6(image)
[m, n] = size(image);

colPoint1 = floor(n/3);
colPoint2 = 2*colPoint1;
rowMidPoint = floor(m/2);

topLeft = image(1:rowMidPoint, 1:colPoint1);
topMid = image(1:rowMidPoint, colPoint1+1:colPoint2);
topRight = image(1:rowMidPoint, colPoint2+1:end);
botLeft = image(rowMidPoint+1:end, 1:colPoint1);
botMid = image(rowMidPoint+1:end, colPoint1+1:colPoint2);
botRight = image(rowMidPoint+1:end, colPoint2+1:end);
end

