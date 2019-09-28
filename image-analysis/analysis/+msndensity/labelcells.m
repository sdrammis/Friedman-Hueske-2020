function [strio, matrix] = labelcells(cells, strioMask, matrixMask, striosomality)
[m, n] = size(cells);
strio = zeros(m,n);
matrix = zeros(m,n);

cells = bwareaopen(cells, 100);
cellsprops = regionprops(cells, 'all');
centroids = [cellsprops.Centroid];
centroidsX = centroids(1:2:end-1);
centroidsY = centroids(2:2:end);

nCells = length(centroidsX);
for iCells=1:nCells
    x = round(centroidsX(iCells));
    y = round(centroidsY(iCells));
    if isnan(x) || isnan(y)
        continue;
    end
    cell = bwselect(cells, x, y);
    
    numStrio = nnz(strioMask & cell);
    numMatrix = nnz(matrixMask & cell);
    if numStrio == 0 && numMatrix == 0
        continue;
    end
    
    if numStrio > 0 && strcmp(striosomality, 'Strio')
        strio = strio | cell;
    elseif numMatrix > 0 && strcmp(striosomality, 'Matrix')
        matrix = matrix | cell;
    elseif numStrio >= numMatrix
        strio = strio | cell;
    elseif numMatrix > numStrio
        matrix = matrix | cell;
    end
end
end