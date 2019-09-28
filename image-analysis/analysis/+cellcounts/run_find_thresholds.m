IMAGES_PATH = '/smbshare/analysis3/strio_matrix_cv/Alexander_Emily_Erik/FINAL EXPORTED IMAGES';
DATA_PATH = '/smbshare/analysis3/strio_matrix_cv/Alexander_Emily_Erik/analysis_output_copy/cell_counts';
OUTPUT_DIR = '/smbshare/analysis3/strio_matrix_cv/analysis_output/cell_counts_debug';

LOW_THRESHS = {-0.2, -0, 0.2};
HIGH_THRESHS = {1.3, 1.5, 1.7};

T = cell2table({ -1, -1, [], [], []});
T.Properties.VariableNames = {'mouseID', 'sliceNum', 'overlap', 'noOverlap', 'unsureOverlap' };

dirContents = dir(DATA_PATH);
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
        imgNameRed = [slice '_texa_' num2str(stack) '.tiff'];
        imgSrcRed = [IMAGES_PATH '/cell_counts_'  num2str(n) '/' imgNameRed];
        if isfile(imgSrcGreen)
            exp = n;
            break;
        end
    end
    if exp == 0
        sprintf('Could not find file image. \n');
        continue;
    end
    
    dataRed = load([DATA_PATH '/' file]);
    cellsRed = bwareaopen(dataRed.redCells, 500);
    imgGreen = imread(imgSrcGreen);
    imgRed = imread(imgSrcRed);
    
    fprintf(['Finding cells file... ' file '\n']);
    
    splitA = split(slice, '-');
    splitB = split(splitA{4}, '_');
    splitC = split(splitB{2}, 'slice');
    sliceNum = str2double(splitC{2});
    mouseID = str2double(splitB{1});
    sliceDir = sprintf('%s/mouse%d_slice%d_stack%s', OUTPUT_DIR, mouseID, sliceNum, stack);
    mkdir(sliceDir);
    
    [mixedCells1, maybeMixedCells1, notMixedCells1] = ...
        find_overlap(cellsRed, imgGreen, LOW_THRESHS{1}, HIGH_THRESHS{1});
    [mixedCells2, maybeMixedCells2, notMixedCells2] = ...
        find_overlap(cellsRed, imgGreen, LOW_THRESHS{2}, HIGH_THRESHS{2});
    [mixedCells3, maybeMixedCells3, notMixedCells3] = ...
        find_overlap(cellsRed, imgGreen, LOW_THRESHS{3}, HIGH_THRESHS{3});
    
    [m, n] = size(imgGreen);
    windowHeight = floor(m / 9);
    windowWidth = floor(n / 9);
    numRows = floor(m / windowHeight);
    numCols = floor(n / windowWidth);
    for r=1:numRows
        for c=1:numCols
            x1 = (c-1) * windowWidth + 1;
            x2 = c * windowWidth;
            y1 = (r-1) * windowHeight + 1;
            y2 = r * windowHeight;
            
            ROI = imcrop(imgGreen, [x1 y1 x2-x1 y2-y1]);
            
            cellsRedROI = imcrop(cellsRed, [x1 y1 x2-x1 y2-y1]);
            if sum(sum(cellsRedROI)) == 0
                continue;
            end
            
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            subplot(2, 3, 1);
            render_subfig(ROI, mixedCells1(y1:y2, x1:x2), maybeMixedCells1(y1:y2, x1:x2), notMixedCells1(y1:y2, x1:x2));
            title(sprintf('(%.2f, %.2f)', LOW_THRESHS{1}, HIGH_THRESHS{1}));
            subplot(2, 3, 2);
            render_subfig(ROI, mixedCells2(y1:y2, x1:x2), maybeMixedCells2(y1:y2, x1:x2), notMixedCells2(y1:y2, x1:x2));
            title(sprintf('(%.2f, %.2f)', LOW_THRESHS{2}, HIGH_THRESHS{2}));
            subplot(2, 3, 4);
            render_subfig(ROI, mixedCells3(y1:y2, x1:x2), maybeMixedCells3(y1:y2, x1:x2), notMixedCells3(y1:y2, x1:x2));
            title(sprintf('(%.2f, %.2f)', LOW_THRESHS{3}, HIGH_THRESHS{3}));
            subplot(2, 3, 5);
            imshow(cellsRed(y1:y2, x1:x2));
            title('Red cells');
            subplot(2, 3, 3);
            imshow(mat2gray(imgGreen(y1:y2, x1:x2)));
            title('Green channel');
            subplot(2, 3, 6);
            imshow(mat2gray(imgRed(y1:y2, x1:x2)));
            title('Red channel');
            saveas(f, sprintf('%s/r%d-c%d.fig', sliceDir, r, c));
            saveas(f, sprintf('%s/r%d-c%d.png', sliceDir, r, c));
            close all;
        end
    end
end

function render_subfig(ROI, mixedCells, maybeMixedCells, notMixedCells)
imshow(mat2gray(ROI));
hold on;
mixedBounds = bwboundaries(mixedCells);
maybeMixedBounds = bwboundaries(maybeMixedCells);
notMixedBounds = bwboundaries(notMixedCells);
for k=1:size(mixedBounds, 1)
    thisBoundary = mixedBounds{k};
    plot(thisBoundary(:,2), thisBoundary(:,1), 'r', 'LineWidth', 2);
end
for k=1:size(maybeMixedBounds, 1)
    thisBoundary = maybeMixedBounds{k};
    plot(thisBoundary(:,2), thisBoundary(:,1), 'y', 'LineWidth', 2);
end
for k=1:size(notMixedBounds, 1)
    thisBoundary = notMixedBounds{k};
    plot(thisBoundary(:,2), thisBoundary(:,1), 'c', 'LineWidth', 2);
end
hold off;
end



