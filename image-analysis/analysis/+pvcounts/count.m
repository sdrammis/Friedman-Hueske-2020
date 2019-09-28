DATA_PATH = '/annex4/afried/resultfiles/analysis_output/pv_counts/data_young';
DIMS_PATH = './dbs/dimensions.mat';
OUT_DIR = '/annex4/afried/resultfiles/analysis_output/pv_counts/results';

outPath = [OUT_DIR '/pvcounts-young_' datestr(now,'mmddyy_HH-MM') '.csv'];
outFileID = fopen(outPath, 'a');

load(DIMS_PATH);
for iDim=1:height(dimensions)
    slice = dimensions.slice(iDim);
    dimensions.slice(iDim) = lower(slice);
end
M = pvmsnconn.buildregionsmap();
S = pvcounts.buildslicemap();

dirContents = dir(DATA_PATH);
files = {dirContents(:).name};

for iFile=1:length(files)
    file = files{iFile};
    if any(strcmp(file(1), {'.', '@'}))
        continue;
    end
    
    data = load([DATA_PATH '/' file]);
    
    % Find the mouse ID for the slice file.
    [mouseID, slice, stack] = find_mouseID(M, S, file);
    if isnan(str2double(mouseID))
        fprintf('Could not extract mouseID from file %s \n', file);
    end
    
    [r, c] = size(data.cells);
    rs = floor(r * .1);
    rt = floor(r * .9);
    cs = floor(c * .1);
    ct = floor(c * .9);
    AOI = data.cells(rs:rt, cs:ct);
    
    [cTL, cTM, cTR, cBL, cBM, cBR] = utils.split_quadrants6(AOI);
    [nAll, aAll] = count_(AOI);
    [nTL, aTL] = count_(cTL);
    [nTM, aTM] = count_(cTM);
    [nTR, aTR] = count_(cTR);
    [nBL, aBL] = count_(cBL);
    [nBM, aBM] = count_(cBM);
    [nBR, aBR] = count_(cBR); 
        
    d = dimensions(strcmp(dimensions.slice, slice),:);
    if isempty(d)
        fprintf('Could not get dimensions for slice %s \n', slice);
        continue;
    end
    
    pixelsize = ((d.width * d.height) / (r * c));
    fprintf(outFileID, ['%s, %s, %s, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, ', ...
        '%.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f\n'], ...
            mouseID, slice, stack, ...
            nAll, nTL, nTM, nTR, nBL, nBM, nBR, ...
            (aAll*pixelsize), (aTL*pixelsize),(aTM*pixelsize), ...
            (aTR*pixelsize),(aBL*pixelsize), (aBM*pixelsize), (aBR*pixelsize));
end

function [mouseID, slice, stack] = find_mouseID(M, S, fileName)
matchRegion = regexp(fileName, 'region [0-9]+', 'match');
if isempty(matchRegion)
    matchMouse = regexp(fileName, '-[0-9]+_slice', 'match');
    splits = split(matchMouse{1}, '_');
    mouseID = splits{1}(2:end);
    slice = regexprep(fileName, '_-?[0-9]+_res.mat', '');
else
    splits = split(matchRegion{1}, ' ');
    mouseID = M(splits{2});
    sliceNum = S(splits{2});
    slice = regexprep(fileName(1:end-8), 'region [0-9]+_-?[0-9]+', [mouseID '_' sliceNum]);
end
splits2 = split(fileName(1:end-8), '_');
stack = splits2{end};
end

function [count, area] = count_(cells)
cc = bwconncomp(cells);
count = cc.NumObjects;
area = size(cells,1) * size(cells,2);
end
