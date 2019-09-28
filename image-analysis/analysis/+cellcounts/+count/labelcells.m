function [mixedCells, maybeMixedCells, notMixedCells] = ...
    labelcells(cellsRed_, imgGreen, lowThresh, highThresh)

[m, n] = size(cellsRed_);
mixedCells = zeros(m, n);
maybeMixedCells = zeros(m, n);
notMixedCells = zeros(m, n);

% Remove detected cells that are too small to be cells.
cellsRed = bwareaopen(cellsRed_, 500);

% Find first initiall guess at cell colors.
% Problems arrise at the border where cells may be double labeled.
[mixedCells_, maybeMixedCells_, notMixedCells_] = ...
    cellcounts.findoverlap(cellsRed, imgGreen, lowThresh, highThresh);
 
% Fix errors of cells being double labeled across borders and finalize
% output.
cellsRedProps = regionprops(cellsRed, 'all');
cellsRedCentroids = [cellsRedProps.Centroid];
cellsRedCentroidsX = cellsRedCentroids(1:2:end-1);
cellsRedCentroidsY = cellsRedCentroids(2:2:end);
for i=1:length(cellsRedCentroidsX)
    cell = bwselect(cellsRed, cellsRedCentroidsX(i), cellsRedCentroidsY(i));
    isMixed = nnz(mixedCells_(cell)) > 0;
    isNotMixed = nnz(notMixedCells_(cell)) > 0;
    isMaybeMixed = nnz(maybeMixedCells_(cell)) > 0;

    % Order here is important. If the cells i labeled mix and not-mixed we
    % mark it as unsure. If the cell is labeled maybe and (mixed or
    % not-mixed) we mark it as the appropriate mixed/not-mixed. If a cell
    % wasn't labeled because it was outside the striatum mask, it should
    % not all the sudden become labeled (so check every cell for a label).
    if isMixed && isNotMixed
        maybeMixedCells = maybeMixedCells | cell;
    elseif isMixed
        mixedCells = mixedCells | cell;
    elseif isNotMixed
        notMixedCells = notMixedCells | cell;
    elseif isMaybeMixed
        maybeMixedCells = maybeMixedCells | cell;
    end
end
end

