function cellsFound = MSNDendritesSpinesDetection_cells_region(img, threshold, sizefactor)
[r,c] = size(img);
cellsFound = logical(zeros(r,c));

%% Thresholds the cropped image
threshed = img > threshold;
img(~threshed) = 0;

%% Preprocessing
removed = bwareaopen(img,round(1000*sizefactor));
cells = imfill(removed,'holes');
if sum(sum(cells))== 0
    return;
end

sideLen = round(50*sqrt(sizefactor));
centerLen = round(26*sqrt(sizefactor));
%% Finds the Cells
% initializes the total region of interest
cellsFound = cells;
selectedRegions = logical(zeros(r,c));
for i = 1:(r-sideLen)
    for j = 1:(c-sideLen)
        if cells(i,j) == 1
            % creates a submatrix of reference size 51 x 51
            sub = cells(i:i+sideLen,j:j+sideLen);
            % checks if the submatrix is all ones
            if sum(sum(sub)) == (sideLen+1)^2
                % index is the center of the submatrix
                rMid = i+centerLen;
                cMid = j+centerLen;
                % creates ROI around index that is reference size 101 x 101
                minr = max(rMid - sideLen, 1);
                maxr = min(rMid + sideLen, r);
                minc = max(cMid - sideLen, 1);
                maxc = min(cMid + sideLen, c);
                
                % adds to the total ROI
                selectedRegions(minr:maxr, minc:maxc) = 1;
            end
        end
    end
end
cellsFound(~selectedRegions) = 0;
end