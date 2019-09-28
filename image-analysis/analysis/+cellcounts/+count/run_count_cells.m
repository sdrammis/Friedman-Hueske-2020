IMAGES_PATH = '/annex2/analysis/strio_matrix_cv/Alexander_Emily_Erik/FINAL EXPORTED IMAGES';
OUTPUT_PATH_SORTED = '/annex2/analysis/strio_matrix_cv/Alexander_Emily_Erik/analysis_output_copy/cell_counts';
DEBUG_OUTPUT_PATH = '/annex2/analysis/strio_matrix_cv/analysis_output/cell_counts/cell_counts_v3';

NUM_EXPS = 5;
LOW_THRESH = -0.1;
HIGH_THRESH = 1.3;

T = cell2table({ -1, -1, [], [], []});
T.Properties.VariableNames = {'mouseID', 'sliceNum', 'overlap', 'noOverlap', 'unsureOverlap' };

dirContents = dir(OUTPUT_PATH_SORTED);
files = {dirContents(:).name};

for i=1:length(files)
    file = files{i};
    if isempty(regexpi(file, '.*_data\.mat'))
        continue;
    end
    
    fprintf(['Running file... ' file '\n']);
    
    splits = split(file, '_');
    slice = [splits{1} '_' splits{2}];
    stack = splits{3};
    
    exp = 0;
    imgSrcGreen = '';
    for n=1:NUM_EXPS
        imgNameGreen = [slice '_fitc_' num2str(stack) '.tiff'];
        imgSrcGreen = [IMAGES_PATH '/cell_counts_'  num2str(n) '/' imgNameGreen];
        if isfile(imgSrcGreen)
            exp = n;
            break;
        end
    end
    if exp == 0
        fprintf('Could not find file image: %s \n', imgSrcGreen);
        continue;
    end
    
    imgNameRed = [slice '_texa_' num2str(stack) '.tiff'];
    imgSrcRed = [IMAGES_PATH '/cell_counts_'  num2str(n) '/' imgNameRed];
    imgRed = imread(imgSrcRed);
    imgGreen = imread(imgSrcGreen);
    cellsRed = find_red_cells(imgRed, 2);
    
    fprintf(['Finding cells file... ' file '\n']);
    [mixedCells, maybeMixedCells, notMixedCells] = ...
        label_cells(cellsRed, imgGreen, LOW_THRESH, HIGH_THRESH);
    
    % Save red cells detected for easy debugging.
    f1 = figure;
    cellsRedBounds = bwboundaries(cellsRed);
    imshow(mat2gray(imgRed));
    hold on;
    for k=1:size(cellsRedBounds, 1)
        thisBoundary = cellsRedBounds{k};
        plot(thisBoundary(:,2), thisBoundary(:,1), 'r', 'LineWidth', 2);
    end
    saveas(f1, [DEBUG_OUTPUT_PATH '/red_cells-' slice '_' num2str(stack) '.fig']);
    close all;
    
    % Save labeled cells image for debugging.
    f2 = figure;
    imshow(mat2gray(imgGreen));
    hold on;
    mixedBounds = bwboundaries(mixedCells);
    maybeMixedBounds = bwboundaries(maybeMixedCells);
    notMixedBounds = bwboundaries(notMixedCells);
    hold on;
    for k=1:size(mixedBounds, 1)
        thisBoundary = mixedBounds{k};
        plot(thisBoundary(:,2), thisBoundary(:,1), 'r', 'LineWidth', 2);
    end
    hold on;
    for k=1:size(maybeMixedBounds, 1)
        thisBoundary = maybeMixedBounds{k};
        plot(thisBoundary(:,2), thisBoundary(:,1), 'y', 'LineWidth', 2);
    end
    hold on;
    for k=1:size(notMixedBounds, 1)
        thisBoundary = notMixedBounds{k};
        plot(thisBoundary(:,2), thisBoundary(:,1), 'c', 'LineWidth', 2);
    end
    saveas(f2, [DEBUG_OUTPUT_PATH '/cell_labels-' slice '_' num2str(stack) '.fig']);
    close all;
    
    splitA = split(slice, '-');
    splitB = split(splitA{4}, '_');
    splitC = split(splitB{2}, 'slice');
    sliceNum = str2double(splitC{2});
    mouseID = str2double(splitB{1});
    
    [topLeftRed, topMidRed, topRightRed, ...
        botLeftRed, botMidRed, botRightRed] = split_quadrants6(cellsRed);
    [topLeftMixed, topMidMixed, topRightMixed, ...
        botLeftMixed, botMidMixed, botRightMixed] = split_quadrants6(mixedCells);
    [topLeftMaybe, topMidMaybe, topRightMaybe, ...
        botLeftMaybe, botMidMaybe, botRightMaybe] = split_quadrants6(maybeMixedCells);
    [topLeftGood, topMidGood, topRightGood, ...
        botLeftGood, botMidGood, botRightGood] = split_quadrants6(notMixedCells);
    
    numTopLeftOverlap = count_unique(topLeftRed, topLeftMixed);
    numTopMidOverlap = count_unique(topMidRed, topMidMixed);
    numTopRightOverlap = count_unique(topRightRed, topRightMixed);
    numBotLeftOverlap = count_unique(botLeftRed, botLeftMixed);
    numBotMidOverlap = count_unique(botMidRed, botMidMixed);
    numBotRightOverlap = count_unique(botRightRed, botRightMixed);
    
    numTopLeftNoOverlap = count_unique(topLeftRed, topLeftGood);
    numTopMidNoOverlap = count_unique(topMidRed, topMidGood);
    numTopRightNoOverlap = count_unique(topRightRed, topRightGood);
    numBotLeftNoOverlap = count_unique(botLeftRed, botLeftGood);
    numBotMidNoOverlap = count_unique(botMidRed, botMidGood);
    numBotRightNoOverlap = count_unique(botRightRed, botRightGood);
    
    numTopLeftUnsure = count_unique(topLeftRed, topLeftMaybe);
    numTopMidUnsure = count_unique(topMidRed, topMidMaybe);
    numTopRightUnsure = count_unique(topRightRed, topRightMaybe);
    numBotLeftUnsure = count_unique(botLeftRed, botLeftMaybe);
    numBotMidUnsure = count_unique(botMidRed, botMidMaybe);
    numBotRightUnsure = count_unique(botRightRed, botRightMaybe);
    
    overlap = [numTopLeftOverlap numTopMidOverlap numTopRightOverlap;
        numBotLeftOverlap numBotMidOverlap numBotRightOverlap];
    noOverlap = [numTopLeftNoOverlap numTopMidNoOverlap numTopRightNoOverlap;
        numBotLeftNoOverlap numBotMidNoOverlap numBotRightNoOverlap];
    unsureOverlap = [numTopLeftUnsure numTopMidUnsure numTopRightUnsure;
        numBotLeftUnsure numBotMidUnsure numBotRightUnsure];
    
    idx = find(T.mouseID == mouseID & T.sliceNum == sliceNum);
    if isempty(idx)
        T = [T; { mouseID, sliceNum, overlap, noOverlap, unsureOverlap }];
        continue;
    end
    T.overlap(idx) = { cell2mat(T.overlap(idx)) + overlap };
    T.noOverlap(idx) = { cell2mat(T.noOverlap(idx)) + noOverlap };
    T.unsureOverlap(idx) = { cell2mat(T.unsureOverlap(idx)) + unsureOverlap };
end

save('results.mat', 'T');
writetable(T, 'results');
% savejson('', table2struct(T), 'results.json');

function ret = count_unique(regionCells, regionMask)
cells = regionCells;
cells(~regionMask) = 0;
ret = length(unique(cells(:))) - 1;
end
