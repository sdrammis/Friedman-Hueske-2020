function spines = MSNDendritesSpinesDetection_spines(img, cells, dendrites, threshold)
spines = [];

MASKED_THRESH = 40; % This threshold seems to work but can be changed.

imgMasked = img;
imgMasked(~dendrites) = 0;
imgMasked(~(imgMasked > MASKED_THRESH)) = 0;
imgMasked(logical(cells)) = 0;

% Create a skeleton of original mask by dendrites.
skeleton = bwmorph(imgMasked, 'skel', Inf);
% Remove really short dendrite branches.
B = bwmorph(skeleton, 'branchpoints');
E = bwmorph(skeleton, 'endpoints');
[y,x] = find(E);
Dmask = false(size(skeleton));
for k = 1:numel(x)
    D = bwdistgeodesic(skeleton,x(k),y(k));
    distanceToBranchPt = min(B);
    if distanceToBranchPt < threshold
        Dmask(D < distanceToBranchPt) = true;
    end
end
skelD = skeleton - Dmask;
skelD = bwmorph(skelD,'bridge');

% Keep all endpoints.
endpoints = bwmorph(skelD, 'endpoints');
if sum(sum(endpoints)) == 0
    return;
end

[endpointsRow, endpointsCol] = find(endpoints);
endindices = [endpointsRow endpointsCol];

% Keep only maxima near an endpoint and remove large chunks.
regionalmaxima = imregionalmax(imgMasked);
regionalmaximacopy = bwareaopen(regionalmaxima,10);
regionalmaxima = xor(regionalmaxima,regionalmaximacopy);

[maxIdxsRows,maxIdxsCols] = find(regionalmaxima & logical(imgMasked));
maxindices = [maxIdxsRows maxIdxsCols];

idx = rangesearch(maxindices,endindices,4);
for i=1:length(idx)
    rows = idx{i};
    k = length(idx{i});
    if k == 0
        continue;
    end
    
    for j=1:k
        index = maxindices(rows(j),:);
        x = index(2);
        y = index(1);
        
        if isempty(spines)
            spines = [spines; x y];
        elseif ismember([x y], spines, 'rows') == 0
            spines = [spines; x y];
        end
    end
end
end

