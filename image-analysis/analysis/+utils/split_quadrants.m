function [medial, central, lateral, point1, point2] = split_quadrants(image)
[~, n] = size(image);

point1 = floor(n/3);
point2 = 2*point1;

medial = image(:, 1:point1);
central = image(:, point1+1:point2);
lateral = image(:, point2+1:end);
end

