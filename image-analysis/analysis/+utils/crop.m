function J = crop(I, pts)
% pts: [x1 y1 x2 y2];
width = pts(3) - pts(1);
height = pts(4) - pts(2);
x = pts(1);
y = pts(2);
% y = size(I,1) - pts(2) - height;
rect = [x y width height];
J = imcrop(I, rect);
end

