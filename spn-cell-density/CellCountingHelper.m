%% Works with cursorinfo to approximate number of cells
% all you need to do is put a cursor on each cell body in matrix in each
% plane and name it cursor_info1, cursor_info2, ... etc
% ONLY COUNT EVERY OTHER PLANE FOR SAKE OF EASE; WILL MAXIMIZE TIME!!

%% For the first cursor info, just put all points into matrixCenters
matrixCenters = [];
for i = 1:length(cursor_info1)
    matrixCenters = [matrixCenters; cursor_info1(i).Position];
end

%% For all following cursor infos, this code compares to previously identified cells so you no longer need to keep track in your head or check by eye
% ALWAYS REMEMBER TO CHANGE THE NAME OF THE CURSOR INFO TO USE THE RIGHT
% ONE!!!!!!!!!!!!!!!!!!!!!
% this part finds all potential new cell centers for the next plane
potentialCenters = [];
for i = 1:length(cursor_info4) % CHANGE NAME
    potentialCenters = [potentialCenters; cursor_info4(i).Position]; % CHANGE NAME
end
badIndicesCell = rangesearch(potentialCenters, matrixCenters, 100);

% this part identifies all cell centers that you already calculated
badIndicesList = zeros(1, length(potentialCenters(:,1)));
for j = 1:length(badIndicesCell)
    if length(badIndicesCell{j}) ~= 0
        badIndicesList(badIndicesCell{j}) = 1;
    end
end

% this part...
newCenters = potentialCenters;
newCenters(badIndicesList==1,:) = [];
matrixCenters = [matrixCenters; newCenters];
