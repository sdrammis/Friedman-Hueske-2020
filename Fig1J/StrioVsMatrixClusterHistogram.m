%% Testing Data and How to Create Data for an Image
% define an empty structure to contain the centers
cellCenters = struct;
% define the strio and matrix centers
% ONLY ENTER DATA FOR STRIOSOMES THAT HAVE CELLS
strio1Centers = [2087 3871; 2141 3842];  % each entry is x,y coordinates (x is from left to right; y from top to bottom)
strio2Centers = [4877 5490; 4804 5872];
% ... continue for number of striosomes
strio3Centers = [5036 7393; 3524 7761; 4226 7811];
strio4Centers = [7127 6060; 6699 5978; 7297 5380; 6217 5052; 5931 4812];
strio5Centers = [9785 3796];
% strio6Centers = strio6Centers;
% strio7Centers = strio7Centers;
% strio8Centers = [];
% strio9Centers = [];
% strio10Centers = [];
% strio11Centers = [];
matrixCenters = matrixCenters;
% additionalArea = 56199384; % VERY IMPORTANT FOR MATRIX ANIMALS ONLY!!!!!!!!
% add this data to the empty structure
cellCenters.strio1Centers = strio1Centers;
cellCenters.strio2Centers = strio2Centers;
cellCenters.strio3Centers = strio3Centers;
cellCenters.strio4Centers = strio4Centers;
cellCenters.strio5Centers = strio5Centers;
% cellCenters.strio6Centers = strio6Centers;
% cellCenters.strio7Centers = strio7Centers;
% cellCenters.strio8Centers = strio8Centers;
% cellCenters.strio9Centers = strio9Centers;
% cellCenters.strio10Centers = strio10Centers;
% cellCenters.strio11Centers = strio11Centers;
cellCenters.matrixCenters = matrixCenters;
% SAVE CELLCENTERS

%% Compute Distances (with mean and STD) for Categories Strio vs Matrix (NOT USED IN THIS)
% NEED TO USE NORMALIZING FACTOR TO GET TRUE LENGTH!!!!!!
realWidth = 1.6996;
realHeight = 1.1279;
figureWidth = 16384;
figureHeight = 11264;
normFactor = realWidth/figureWidth; % may need to recalculate but that should be easy
areaNorm = normFactor*realHeight/figureHeight;
% NEED TO IMPORT CELLCENTERS OR USE DIRECTLY FROM CODE

% define an empty structure to contain the distance data
cellDistances = struct;
% compute lists of all distances within a category
matrixDistances = [];
strioDistances = [];
% make it possible to name all the entries in the cellCenters structure
categories = fieldnames(cellCenters);
% initializes strio count
cellDistances.strioCount = 0;
% iterate through all strios and matrix
for index = 1:numel(categories)
    category = categories{index};
    % special case for matrix because there is always just 1
    if category == 'matrixCenters'
        matrix = cellCenters.(category);
        % creates a cell count within the matrix just in case
        cellDistances.matrixCount = length(matrix);
        % appends all possible matrix cell distances to matrixDistances
        for i = 1:length(matrix(:,1))
            if i < length(matrix(:,1))
                for j = (i+1):length(matrix)
                    matrixDistances = [matrixDistances sqrt((matrix(i,1)-matrix(j,1))^2+(matrix(i,2)-matrix(j,2))^2)];
                end
            end
        end
    else
        strio = cellCenters.(category);
        % adds cells to strio count just in case
        cellDistances.strioCount = cellDistances.strioCount + length(strio);
        % appends all possible strio cell distances within a single strio
        % to strioDistances
        for i = 1:length(strio(:,1))
            if i < length(strio(:,1))
                for j = (i+1):length(strio)
                    strioDistances = [strioDistances sqrt((strio(i,1)-strio(j,1))^2+(strio(i,2)-strio(j,2))^2)];
                end
            end
        end
    end
end
% multiply by normalization factor to get true distance
matrixDistances = matrixDistances * normFactor;
strioDistances = strioDistances * normFactor;
% do these if statements to make sure there is enough data
% calculate means and STDs
if length(matrixDistances) > 1
    matrixMean = mean(matrixDistances);
else
    matrixMean = NaN;
end
if length(strioDistances) > 1
    strioMean = mean(strioDistances);
else
    strioMean = NaN;
end
matrixSTD = nanstd(matrixDistances);
strioSTD = nanstd(strioDistances);
% puts distances, means, and STDs in cellDistances
cellDistances.matrixDistances = matrixDistances;
cellDistances.strioDistances = strioDistances;
cellDistances.matrixMean = matrixMean;
cellDistances.strioMean = strioMean;
cellDistances.matrixSTD = matrixSTD;
cellDistances.strioSTD = strioSTD;
% puts additional matrix area intor cellDistances
% cellDistances.extraArea = additionalArea*areaNorm;
% SAVE CELLDISTANCES

%% Compute Histograms (NOT USED IN THIS)
fig1 = figure(1);
histogram(matrixDistances, 'BinWidth', 2);
fig2 = figure(2);
histogram(strioDistances, 'BinWidth', 2);