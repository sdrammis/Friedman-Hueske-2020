% Load the miceType.mat file
% Strio and matrix masks are found in the ./mask-data folder.

% Load image real dimensions file
load('./dimensions.mat');

MASKS_DIR = '../new_gcamp-expr_R1Q1/masks-data';

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

f1 = figure;
plotbars( ...
{striosizeCT, striosizeHD, matrixsizeCT, matrixsizeHD}, ...
{'CT striosomes', 'HD striosomes', 'CT matrix', 'HD matrix'}, ...
cbrewer('qual', 'Set2', 10));
ylabel('Area mm^2');
saveas(f, './strio-volumes.fig')
 
%strioCTYng = [];
%strioCTOld = [];
%matrixCTYng = [];
%matrixCTOld = [];
%for iMouse=1:length(miceCT)
  %mouse = miceCT{iMouse};
  %age = mouse.firstSessionAge;
  %if isempty(age)
    %age = getperfage(mouse);
  %end

  %fprintf('CT age %d..\n', age);
 
  %striosize = striosizeCT(iMouse);
  %matrixsize = matrixsizeCT(iMouse);
  %if (age <= 8)
    %strioCTYng = [strioCTYng; striosize];
    %matrixCTYng = [matrixCTYng; matrixsize];
  %elseif (age >= 16)
    %strioCTOld = [strioCTOld; striosize];
    %matrixCTOld = [matrixCTOld; matrixsize];
  %end
%end

%strioHDYng = [];
%strioHDOld = [];
%matrixHDYng = [];
%matrixHDOld = [];
%for iMouse=1:length(miceHD)
  %mouse = miceHD{iMouse};
  %age = mouse.firstSessionAge;
  %if isempty(age)
    %age = getperfage(mouse);
  %end
  %health = mouse.Health;
 
  %fprintf('HD age %d..\n', age);

  %striosize = striosizeHD(iMouse);
  %matrixsize = matrixsizeHD(iMouse);
  %if (age <= 8)
    %strioHDYng = [strioHDYng; striosize];
    %matrixHDYng = [matrixHDYng; matrixsize];
  %elseif (age >= 16)
    %strioHDOld = [strioHDOld; striosize];
    %matrixHDOld = [matrixHDOld; matrixsize];
  %end
%end

%f2 = figure;
%plotbars( ...
%{strioCTYng, strioCTOld, strioHDYng, strioHDOld, ...
%matrixCTYng, matrixCTOld, matrixHDYng, matrixHDOld}, ...
%{'Strio CT Yng', 'Strio CT Old', 'Strio HD Yng', 'Strio HD Old', ...
%'Matrix CT Yng', 'Matrix CT Old', 'Matrix HD Yng', 'Matrix HD Old'}, ...
%cbrewer('qual', 'Set2', 10));
%set(gca, 'XTickLabelRotation', 90)
%saveas(f2, './bars-ages.png')
