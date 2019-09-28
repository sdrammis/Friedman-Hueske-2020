function [dendriteArea, numDendPixels, dendLength, numSpines] = countexid(datadir, exid, realsize)
NUM_WINDOWS = 10;

fid = fopen([datadir '/' exid '-threshs.json']);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
val = jsondecode(str);
threshMap = val.regionThreshMap;

dataThresh1 = load([datadir '/' exid '-1-data.mat']);
dataThresh2 = load([datadir '/' exid '-2-data.mat']);
dataThresh3 = load([datadir '/' exid '-3-data.mat']);

[n, m] = size(dataThresh1.dendrites);
windowHeight = floor(n/NUM_WINDOWS);
windowWidth = floor(m/NUM_WINDOWS);

numDendPixels = 0;
totDendLength = 0;
numSpines = 0;
for i=1:length(threshMap)
    s =  strsplit(threshMap{i}{1}, '#');
    r = str2double(s{1});
    c = str2double(s{2}); % Question: are r & c indexed by 1 or 0?
    thresh = threshMap{i}{2};
    
    if isempty(thresh)
        continue;
    end
    
    switch thresh
        case 1
            dendrites = dataThresh1.dendrites;
            spines = dataThresh1.spines;
        case 2
            dendrites = dataThresh2.dendrites;
            spines = dataThresh2.spines;
        case 3
            dendrites = dataThresh3.dendrites;
            spines = dataThresh3.spines;
    end
    
    x1 = (c-1) * windowWidth + 1;
    x2 = c * windowWidth;
    y1 = (r-1) * windowHeight + 1;
    y2 = r * windowHeight;
    dendritesROI = imcrop(dendrites, [x1 y1 x2-x1 y2-y1]);
    numDendPixels = numDendPixels + sum(dendritesROI(:));
    
    dendSkel = bwmorph(bwskel(dendritesROI), 'spur', 15);
    dendLengthROI = sum(dendSkel(:));
    totDendLength = totDendLength + dendLengthROI;
    
    numSpinesROI = 0;
    for j=1:size(spines,1)
       spinesC = spines(j,1);
       spinesR = spines(j,2); 

       if spinesR >= y1 && spinesR <= y2 && spinesC >= x1 && spinesC <= x2
           numSpinesROI = numSpinesROI + 1;
       end
    end
    numSpines = numSpines + numSpinesROI;
end
dendriteArea = numDendPixels * (realsize / (n*m)); % mm^2
dendLength = totDendLength * sqrt((realsize / (n*m))); % mm
end
