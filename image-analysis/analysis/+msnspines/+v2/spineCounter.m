function [dendriteLens, numSpines] = spineCounter(exid, img, realsize) 
conf = msnspines.v2.config('local');
setenv('PATH', [getenv('PATH') conf.NODE_PTH]);

fname = [conf.DATA_DIR_DONE '/' exid '-threshs.json'];
[status, ~] = system(['node ' conf.MSK_GEN_PTH ' ' fname ' ' exid ' ' conf.MASK_TMP_DIR]);

fprintf(['node ' conf.MSK_GEN_PTH ' ' fname ' ' exid ' ' conf.MASK_TMP_DIR]);
if status ~= 0
    error('Node failed to create masks for %s!!\n', exid)
end

NUM_WINDOWS = 10;

jsonval = jsondecode(fileread(fname));
img = imread(img);

[n, m] = size(img);
windowHeight = floor(n/NUM_WINDOWS);
windowWidth = floor(m/NUM_WINDOWS);
numRows = floor(n/windowHeight);
numCols = floor(m/windowWidth);

dendriteLens = [];
numSpines = [];
for r=1:numRows
        for c=1:numCols
            fprintf('(row, col)=(%d, %d) -- (%d, %d) \n', r, c, numRows, numCols);
            bareSkeletonData = {};
            
            x1 = (c-1) * windowWidth + 1;
            x2 = c * windowWidth;
            y1 = (r-1) * windowHeight + 1;
            y2 = r * windowHeight;
            %xSize and ySize are sizes of original region
            xSize = abs(x1-x2)+1;
            ySize = abs(y1-y2)+1;
            %row1,col1,row2,col2 are dimensions to crop border, 
            %colOG and rowOG are sizes of client region
            ogtilepth = sprintf('%s/%s/thresh_1/%s-%d-%d.png', conf.DATA_DIR_MANUAL, exid, exid, r, c);
            [~, row1, row2, col1, col2, rowOG, colOG] = ...
                msnspines.v2.OGBorderRemover(ogtilepth, xSize, ySize);
            
            %find threshold and corresponding skeleton for each region
            thresh = [];
            for i = 1:length(jsonval.regionThreshMap)
               if strcmp(jsonval.regionThreshMap{i,1}{1,1}, sprintf('%d#%d', r, c))
                   thresh = jsonval.regionThreshMap{i,1}{2,1};
                   break;
               end
            end
         
            if isempty(thresh)
                continue;
            end
            
            bareSkeletonData = load(sprintf('%s/%s-%d-data.mat', conf.DATA_DIR_DONE, exid, thresh));
            bareSkeleton = bareSkeletonData.dendrites;
            spines = bareSkeletonData.spines;

            maskPth = [conf.MASK_TMP_DIR '/' sprintf('%s-%d-%d-msk.png', exid, r, c)];
            if exist(maskPth, 'file') == 2
                msk = imread(maskPth);
                croppedMaskRgb = msnspines.v2.maskBorderRemover(msk, row1, row2, col1, col2,xSize, ySize, rowOG, colOG);
                croppedMaskGray = rgb2gray(croppedMaskRgb);
                croppedMask = imbinarize(croppedMaskGray);
                dendritesROI = bareSkeleton(y1:y2,x1:x2);
                dendritesROI(~croppedMask) = 0;
            else
                dendritesROI = bareSkeleton(y1:y2,x1:x2);
            end
            
            dendSkel = bwmorph(bwskel(dendritesROI), 'spur', 15);
            dendLengthROI = sum(dendSkel(:)) * sqrt((realsize / (n*m)));
            dendriteLens = [dendriteLens dendLengthROI];

            numSpinesROI = 0;
            for j=1:size(spines,1)
                spinesC = spines(j,1);
                spinesR = spines(j,2); 

                if spinesR >= y1 && spinesR <= y2 && spinesC >= x1 && spinesC <= x2
                    numSpinesROI = numSpinesROI + 1;
                end
            end
            numSpines = [numSpines numSpinesROI];
       end
            
end
end

