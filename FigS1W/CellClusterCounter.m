%% this code finds the most dense cluster of cells in any striosome and then finds the most dense region of matrix (circle centered on a matrix cell) with the same area containing all cells in that striosome for comparison

%% Initialize variables to be saved
maxRadius = [];
strioMaxCenter = [];
matrixMaxCenter = [];
maxStrioDensity = [];
maxMatrixDensity = [];
fullStrioClusterCount = [];
allStrioClusterCenters = [];
fullMatrixClusterCount = [];
allMatrixClusterCenters = [];

%% Finds the most dense striosome
% area normalization stuff
realWidth = 1.9797;
realHeight = 2.2672;
figureWidth = 21504;
figureHeight = 19456;
normFactor = realWidth/figureWidth; % may need to recalculate but that should be easy
areaNorm = normFactor*realHeight/figureHeight;
% NEED TO IMPORT CELLCENTERS

% make it possible to name all the entries in the cellCenters structure
categories = fieldnames(cellCenters);
% creates a temporary radius and corresponding density that will be compared across striosomes for
% maximum density (also a temporary strio max density center)
tempStrioDensity = 0;
tempRadius = 0;
tempStrioCenter = [];
% iterate through all strios
for index = 1:numel(categories)
    category = categories{index};
    % special case for matrix because there is always just 1
    if contains(category,'matrixCenters')
        % do nothing
    elseif contains(category, 'Centers')
        strio = cellCenters.(category);
        % gets area of that striosome
        % strioArea = cellCenters.(strcat(category(1:end-7),'Area'));
        % avoids striosomes with 1 or zero cells because impossible to
        % determine density and 2 because 2 is not a "cluster"
        if length(strio(:,1)) > 2
            % this is the way to find density based on "smallest" circle
            % around all points in a striosome
            strioAvgCell = mean(strio);
            strioDistances = (sum(((strio - [strioAvgCell(1,1)*ones(length(strio(:,1)),1) strioAvgCell(1,2)*ones(length(strio(:,1)),1)]).^2)')').^0.5;
            possibleMaxRadius = max(strioDistances);
            possibleMaxDensity = length(strio(:,1))/(pi*possibleMaxRadius^2);
            if possibleMaxDensity > tempStrioDensity
                tempStrioDensity = possibleMaxDensity;
                tempRadius = possibleMaxRadius;
                tempStrioCenter = strioAvgCell;
            end
            % this is the way to find radius of circle with same area as
            % the most dense striosome
%             possibleMaxDensity = length(strio(:,1))/strioArea;
%             possibleMaxRadius = sqrt(strioArea/pi);
%             if possibleMaxDensity > tempStrioDensity
%                 tempStrioDensity = possibleMaxDensity;
%                 tempRadius = possibleMaxRadius;
%                 tempStrioCenter = mean(strio);
%             end
            
        end

    end
end
% save these at the end
maxRadius = [maxRadius tempRadius];
strioMaxCenter = [strioMaxCenter; tempStrioCenter];
maxStrioDensity = [maxStrioDensity tempStrioDensity/cellCenters.areaNorm];

% finds the area in the matrix (centered around a matrix cell) that has highest density
% ask if that's okay (it's like best worst case for both strio and matrix)
% initializes values
tempMatrixCount = 0;
tempMatrixCenter = [];
matrix = cellCenters.matrixCenters;
% finds cells radius tempRadius away from every matrix cell
idx = rangesearch(matrix,matrix,tempRadius);
% finds cell with max number within tempRadius
for i = 1:length(idx)
    if length(idx{i}) > tempMatrixCount
        tempMatrixCount = length(idx{i});
        tempMatrixCenter = matrix(i,:);
    end
end
% save these at the end
matrixMaxCenter = [matrixMaxCenter; tempMatrixCenter];
maxMatrixDensity = [maxMatrixDensity tempMatrixCount/(pi*tempRadius^2*cellCenters.areaNorm)];
ratio = (maxStrioDensity-maxMatrixDensity)./(maxStrioDensity+maxMatrixDensity);

%% Cluster Counts 
% p*100 percent of max density at same radius and all clusters centered at 
% matrix vertex that contain p percent of max density at same radius
p = 0.3;
% initialize the cluster counts and cluster centers
matrixClusterCount = 0;
strioClusterCount = 0;
matrixClusterCenters = [];
strioClusterCenters = [];
% need to initialize the strio vector as well because we will combine all
strio = [];
% iterate through all strios
for index = 1:numel(categories)
    category = categories{index};
    % special case for matrix because there is always just 1
    if contains(category,'matrixCenters')
        matrix = cellCenters.(category);
        idx = rangesearch(matrix,matrix,tempRadius);
        % finds cells with density p*100 percent of max strio density in
        % matrix
        for i = 1:length(idx)
            if length(idx{i}) > p*tempStrioDensity*pi*tempRadius^2
                matrixClusterCount = matrixClusterCount + 1;
                matrixClusterCenters = [matrixClusterCenters; matrix(i,:)];
            end
        end
    elseif contains(category, 'Centers') && contains(category, 'strio')
        strio = [strio; cellCenters.(category);];
    end
end
idx = rangesearch(strio,strio,tempRadius);
% finds cells with density p*100 percent of max strio density in strios
for i = 1:length(idx)
    if length(idx{i}) > p*tempStrioDensity*pi*tempRadius^2
        strioClusterCount = strioClusterCount + 1;
        strioClusterCenters = [strioClusterCenters; strio(i,:)];
    end
end
fullStrioClusterCount = [fullStrioClusterCount strioClusterCount];
allStrioClusterCenters = [allStrioClusterCenters; 0 0; strioClusterCenters];
fullMatrixClusterCount = [fullMatrixClusterCount matrixClusterCount];
allMatrixClusterCenters = [allMatrixClusterCenters; 0 0; matrixClusterCenters];