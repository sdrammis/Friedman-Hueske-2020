function MSNDendritesSpinesDetection_run(exid, imgSrc, realsize, ~, manualDir, ~, dataFileCellBody)
DENDRITE_THRESHOLDS = {0.93, 0.96, 0.98};
SPINES_THRESHOLDS = {15, 10, 5};
NUM_WINDOWS = 10;

img = imread(imgSrc);

imgInfo = imfinfo(imgSrc);
bitDepth = imgInfo.BitDepth;
if bitDepth == 16
    img = uint8(img / 256);
end

[n, m] = size(img);
data = load(dataFileCellBody);
cellsThresh = data.threshold - 0.05;
%cells = MSNDendritesSpinesDetection_cells(img, realsize, cellsThresh);
cells = data.cells;

for i=1:length(DENDRITE_THRESHOLDS)
    dendThresh = DENDRITE_THRESHOLDS{i};
    spinesThresh = SPINES_THRESHOLDS{i};
    
    regionsDir = sprintf('%s/%s/thresh_%d', manualDir, exid, i);
    mkdir(regionsDir);
    
    dendrites = MSNDendritesSpinesDetection_dendrites(img, realsize, cells, dendThresh);
    
    % IMPORTANT: Slide the same windows for cell bodies
    windowHeight = floor(n/NUM_WINDOWS);
    windowWidth = floor(m/NUM_WINDOWS);
    numRows = floor(n/windowHeight);
    numCols = floor(m/windowWidth);
    
    spines = []; % indices of spine locations: MAIN THING TO RETURN
    for r=1:numRows
        for c=1:numCols
            fprintf('(row, col)=(%d, %d) -- (%d, %d) \n', r, c, numRows, numCols);
            
            x1 = (c-1) * windowWidth + 1;
            x2 = c * windowWidth;
            y1 = (r-1) * windowHeight + 1;
            y2 = r * windowHeight;
            
            cellsROI = imcrop(cells, [x1 y1 x2-x1 y2-y1]);
            dendritesROI = imcrop(dendrites, [x1 y1 x2-x1 y2-y1]);
            imgROI = imcrop(img, [x1 y1 x2-x1 y2-y1]);
            
            spinesROI= MSNDendritesSpinesDetection_spines(imgROI, cellsROI, dendritesROI, spinesThresh);
            for j=1:size(spinesROI,1)
                spine = spinesROI(j,:);
                x = x1 + spine(1) - 1;
                y = y1 + spine(2) - 1;
                spines = [spines; x y];
            end
            
            f1 = figure;
            imshow(ind2rgb(imgROI, gray));
            if size(spinesROI, 1) > 0
                hold on;
                h1 = imshow(create_color_img(windowHeight, windowWidth, 255, 0, 0));
                hold on;
                scatter(spinesROI(:,1), spinesROI(:,2), 10, [0 1 0], 'filled');
                hold off;
                set(h1, 'AlphaData', dendritesROI * 0.3);
            end
            saveas(f1, sprintf('%s/%s-%d-%d.png', regionsDir, exid, r, c));
            
            f2 = figure;
            imshow(ind2rgb(imgROI, gray));
            saveas(f2, sprintf('%s/og-%s-%d-%d.png', regionsDir, exid, r, c));
            close all;
        end
    end
    save(sprintf('%s/%s-%d-data.mat', manualDir, exid, i), ...
        'dendrites', 'spines', 'dendThresh', 'spinesThresh', '-v7.3')
end
s = struct(...
    'dendThreshs', cell2mat(DENDRITE_THRESHOLDS), ...
    'spinesThreshs', cell2mat(SPINES_THRESHOLDS));
savejson('', s, sprintf('%s/%s-data.json', manualDir, exid));
end

