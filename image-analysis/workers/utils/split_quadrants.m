function [medial, central, lateral, ...
    medialMask, centralMask, lateralMask] = split_quadrants(image)

[m, n] = size(image);

point1 = floor(n/3);
point2 = 2*point1;

medial = image(:, 1:point1);
central = image(:, point1+1:point2);
lateral = image(:, point2+1:end);

medialMask = [ones(m,point1) zeros(m, n-point1)];
centralMask = [zeros(m,point1) ones(m,point2-point1) zeros(m,n-point2)];
lateralMask = [zeros(m,point2) ones(m,n-point2)];
end

