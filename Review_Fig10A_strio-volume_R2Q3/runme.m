% Load the miceType.mat file
% Strio and matrix masks are found in the ./mask-data folder.

% Load image real dimensions file
load('./dimensions.mat');

MASKS_DIR = './masks-data';

% Load the executions database
excsM = dbload('./db.json');
for iExc=1:length(excsM)
  excsM(iExc).slice = lower(excsM(iExc).slice);
end

striosizeHD = [];
striosizeCT = [];
matrixsizeHD = [];
matrixsizeCT = [];
miceCT = {};
miceHD = {};

% Iterate through slice names in DC regions spreadsheet
T = table2struct(readtable('regions.csv', 'Delimiter', ','));

listings = dir([MASKS_DIR '/*-striomasks.mat']);
for iListing=1:size(listings,1)
    filename = listings(iListing).name;
    splits = split(filename, '-striomasks.mat');
    
    exid = splits{1};
    exec = excsM(strcmp({excsM.exid},exid));
    slicename = exec.slice;

    region = T(strcmp({T.Name},[slicename '_vglut.tiff']));
    if isempty(region)
      continue;
    end

    w = dimensions.width(lower(dimensions.slice) == slicename);
    h = dimensions.height(lower(dimensions.slice) == slicename);
    if isempty(w) || isempty(h)
        fprintf('Could not find realsie for exid %s!!! \n', exid);
        continue;
    end
    realsize = w * h;

    fprintf('Running execution %s...\n', exid);

    masks = load([MASKS_DIR '/' filename]);
    striomask = masks.strio;
    matrixmask = masks.matrix;
    striodilated = imdilate(striomask, strel('disk',80,8));
    matrixsubed = (matrixmask - striodilated) > 0;

    xmin = region.X1;
    ymin = region.Y1;
    width = region.X2 - region.X1;
    height = region.Y2 - region.Y1;
    strioregion = imcrop(striodilated, [xmin ymin width height]);
    matrixregion = imcrop(matrixsubed, [xmin ymin width height]);

    [m,n] = size(masks.strio);
    pixelsize = realsize / (m*n);

    splits = strsplit(exid, '_');
    mouseID = splits{2};
    mouse = miceType(strcmp({miceType.ID}, mouseID));
    if isempty(mouse)
        continue;
    end

    striosize = sum(sum(strioregion)) * pixelsize;
    matrixsize = (((width+1) * (height+1)) * pixelsize) - striosize;

    striosomality = mouse.intendedStriosomality;
    health = mouse.Health;

    if strcmp(health, 'WT')
      striosizeCT = [striosizeCT; striosize];
      matrixsizeCT = [matrixsizeCT; matrixsize];
      miceCT{end+1} = mouse;
    elseif strcmp(health, 'HD')
      striosizeHD = [striosizeHD; striosize];
      matrixsizeHD = [matrixsizeHD; matrixsize];
      miceHD{end+1} = mouse;
    end
end

figure;
plotbars( ...
{striosizeCT, striosizeHD, matrixsizeCT, matrixsizeHD}, ...
{'CT striosomes', 'HD striosomes', 'CT matrix', 'HD matrix'}, ...
cbrewer('qual', 'Set2', 10));
ylabel('Area mm^2');