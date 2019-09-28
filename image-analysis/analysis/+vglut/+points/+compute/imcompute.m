function [s, t, u] = imcompute(roiPoints, vglutImgPth, vglutDataPth, strioImgPth, strioMsksPth, strioThrshsPth, realsize)
% NOTE: All VGlut computation is only done on the bottom-middle region of
% the images because the ammount of data is so dense.
s = struct;
s.maxintensities = [];
s.areas = [];
s.group = [];
s.meanIntensity = [];
s.totalIntensity = [];
s.medianIntensity = [];
s.areaStrio = NaN;
s.areaMatrix = NaN;

t = struct;
t.maxintensitiesStrioHis = [];
t.maxintensitiesMatrixHis = [];
t.maxintensitiesStrioPDF = [];
t.maxintensitiesMatrixPDF = [];
t.maxintensitiesStrioCDF = [];
t.maxintensitiesMatrixCDF = [];

t.meanIntensityStrioHis = [];
t.meanIntensityMatrixHis = [];
t.meanIntensityStrioPDF = [];
t.meanIntensityMatrixPDF = [];
t.meanIntensityStrioCDF = [];
t.meanIntensityMatrixCDF = [];

t.medianIntensityStrioHis = [];
t.medianIntensityMatrixHis = [];
t.medianIntensityStrioPDF = [];
t.medianIntensityMatrixPDF = [];
t.medianIntensityStrioCDF = [];
t.medianIntensityMatrixCDF = [];

u = struct;
u.aveMaxIntensitiesStrio = [];
u.aveMaxIntensitiesMatrix = [];
u.aveAreasStrio = [];
u.aveAreasMatrix = [];
u.aveMeanIntensityStrio = [];
u.aveMeanIntensityMatrix = [];
u.aveTotalIntensityStrio = [];
u.aveTotalIntensityMatrix = [];
u.aveMedianIntensityStrio = [];
u.aveMedianIntensityMatrix = [];

% Load the vglut data CSV file.
opts = delimitedTextImportOptions("NumVariables", 3);
opts.DataLines = [1, Inf];
opts.Delimiter = "\t";
opts.VariableNames = ["centroid", "boundaryX", "boundaryY"];
opts.VariableTypes = ["string", "string", "string"];
opts = setvaropts(opts, [1, 2, 3], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
vglutdata = readtable(vglutDataPth, opts);

% Read in the vglut image.
imvglut = imread(vglutImgPth);

[m,n] = size(imvglut);
pixelsize = realsize / (m*n);

% Construct strio masks.
[striomsk, matrixmsk] = vglut.points.compute.compstriomasks(...
    strioImgPth, vglutImgPth, strioMsksPth, strioThrshsPth, realsize);

% Compute the areas of the strio and matrix masks.
roistrio = utils.crop(striomsk, roiPoints);
if sum(roistrio(:)) ~= 0
    s.areaStrio = sum(sum(roistrio));
end
roimatrix = utils.crop(matrixmsk, roiPoints);
if sum(roimatrix(:)) ~= 0
    s.areaMatrix = sum(sum(roimatrix));
end

% Compute the vglut data values.
for iData=1:size(vglutdata,1)
    % NOTE: Boundary data is 0 indexed because it's computed in Java ImageJ.
    boundaryX = str2num(vglutdata{iData,'boundaryX'}) + 1;
    boundaryY = str2num(vglutdata{iData,'boundaryY'}) + 1;
    centroid = str2num(vglutdata{iData,'centroid'}) + 1;
    
    if isempty(boundaryX) || isempty(boundaryY)
        % NOTE: There is a bug in the Java saving of the stringified array
        % where it will not save the entire array (eg. "[100, 100, 101,").
        % This happens infrequently so we ignore it fore now
        continue;
    end

    boundaryX = [boundaryX boundaryX(1)];
    boundaryY = [boundaryY boundaryY(1)];
    minX = min(boundaryX);
    maxX = max(boundaryX);
    minY = min(boundaryY);
    maxY = max(boundaryY);
    imROI = imcrop(imvglut, [minX minY (maxX-minX) (maxY-minY)]);
    
    dotBoundary = zeros(size(imROI));
    prev = [];
    for k = 1:length(boundaryX)
        rpt = boundaryX(k)-minX+1;
        cpt = boundaryY(k)-minY+1;
        dotBoundary(cpt,rpt) = 1;
        if isempty(prev)
            prev = [rpt cpt];
            continue;
        end
        
        rpt_ = rpt;
        cpt_ = cpt;
        if prev(1) > rpt_
            while rpt_ < prev(1)
                rpt_ = rpt_ + 1;
                dotBoundary(cpt,rpt_) = 1;
            end
        elseif prev(1) < rpt_
            while rpt_ > prev(1)
                rpt_ = rpt_ - 1;
                dotBoundary(cpt,rpt_) = 1;
            end
        elseif prev(2) > cpt_
            while cpt_ < prev(2)
                cpt_ = cpt_ + 1;
                dotBoundary(cpt_,rpt) = 1;
            end
        elseif prev(2) < cpt_
            while cpt_ > prev(2)
                cpt_ = cpt_ - 1;
                dotBoundary(cpt_,rpt) = 1;
            end
        end
        prev = [rpt cpt];
    end
    dotMaskWithBoundary = imfill(dotBoundary, 'holes');    
    b = bwboundaries(dotMaskWithBoundary);
    b = b{1};
    dotMask = dotMaskWithBoundary;
    for i=1:size(b,1)
        dotMask(b(i,1),b(i,2)) = 0;
    end
    vglutdot = imROI(logical(dotMask));

    r = round(centroid(2));
    c = round(centroid(1));
    group = "unknown";
    if striomsk(r, c)
        group = "strio";
    elseif matrixmsk(r, c)
        group = "matrix";
    end

    s.maxintensities = [s.maxintensities max(vglutdot)];
    s.meanIntensity = [s.meanIntensity mean(vglutdot)];
    s.totalIntensity = [s.totalIntensity sum(vglutdot)];
    s.medianIntensity = [s.medianIntensity median(vglutdot)];
    s.areas = [s.areas sum(dotMask(:))*pixelsize];
    s.group = [s.group group]; 
end

[maxIntStrioHist, maxIntStrioPDF, maxIntStrioCDF] = comphist(s.maxintensities(strcmp(s.group,'strio')));
t.maxintensitiesStrioHis = maxIntStrioHist;
t.maxintensitiesStrioPDF = maxIntStrioPDF;
t.maxintensitiesStrioCDF = maxIntStrioCDF;

[maxIntMatrixHist, maxIntMatrixPDF, maxIntMatrixCDF] = comphist(s.maxintensities(strcmp(s.group,'matrix')));
t.maxintensitiesMatrixHis = maxIntMatrixHist;
t.maxintensitiesMatrixPDF = maxIntMatrixPDF;
t.maxintensitiesMatrixCDF = maxIntMatrixCDF;

% [aStrioHist, aStrioPDF, aSrioCDF] = comphist(s.areas(strcmp(s.group,'strio')));
% t.areasStrioHis = aStrioHist;
% t.areasStrioPDF = aStrioPDF;
% t.areasStrioCDF = aSrioCDF;
% 
% [aMatrixHist, aMatrixPDF, aMatrixCDF] = comphist(s.areas(strcmp(s.group,'matrix')));
% t.areasMatrixHis = aMatrixHist;
% t.areasMatrixPDF = aMatrixPDF;
% t.areasMatrixCDF = aMatrixCDF;

[meanIntStrioHist, meanIntStrioPDF, meanIntSrioCDF] = comphist(s.meanIntensity(strcmp(s.group,'strio')));
t.meanIntensityStrioHis = meanIntStrioHist;
t.meanIntensityStrioPDF = meanIntStrioPDF;
t.meanIntensityStrioCDF = meanIntSrioCDF;

[meanIntMatrixHist, meanIntMatrixPDF, meanIntMatrixCDF] = comphist(s.meanIntensity(strcmp(s.group,'matrix')));
t.meanIntensityMatrixHis = meanIntMatrixHist;
t.meanIntensityMatrixPDF = meanIntMatrixPDF;
t.meanIntensityMatrixCDF = meanIntMatrixCDF;
 
% [totIntStrioHist, totIntStrioPDF, totIntSrioCDF] = comphist(s.totalIntensity(strcmp(s.group,'strio')));
% t.totalIntensityStrioHis = totIntStrioHist;
% t.totalIntensityStrioPDF = totIntStrioPDF;
% t.totalIntensityStrioCDF = totIntSrioCDF;
% 
% [totIntMatrixHist, totIntMatrixPDF, totIntMatrixCDF] = comphist(s.totalIntensity(strcmp(s.group,'matrix')));
% t.totalIntensityMatrixHis = totIntMatrixHist;
% t.totalIntensityMatrixPDF = totIntMatrixPDF;
% t.totalIntensityMatrixCDF = totIntMatrixCDF;

[medIntStrioHist, medIntStrioPDF, medIntSrioCDF] = comphist(s.medianIntensity(strcmp(s.group,'strio')));
t.medianIntensityStrioHis = medIntStrioHist;
t.medianIntensityStrioPDF = medIntStrioPDF;
t.medianIntensityStrioCDF = medIntSrioCDF;

[medIntMatrixHist, medIntMatrixPDF, medIntMatrixCDF] = comphist(s.medianIntensity(strcmp(s.group,'matrix')));
t.medianIntensityMatrixHis = medIntMatrixHist;
t.medianIntensityMatrixPDF = medIntMatrixPDF;
t.medianIntensityMatrixCDF = medIntMatrixCDF;

u.numPointsStrio = length(s.maxintensities(strcmp(s.group,'strio')));
u.numPointsMatrix = length(s.maxintensities(strcmp(s.group,'matrix')));
u.aveMaxIntensitiesStrio = constantValues(s.maxintensities(strcmp(s.group,'strio')));
u.aveMaxIntensitiesMatrix = constantValues(s.maxintensities(strcmp(s.group,'matrix')));
u.aveAreasStrio = constantValues(s.areas(strcmp(s.group,'strio')));
u.aveAreasMatrix = constantValues(s.areas(strcmp(s.group,'matrix')));
u.aveMeanIntensityStrio = constantValues(s.meanIntensity(strcmp(s.group,'strio')));
u.aveMeanIntensityMatrix = constantValues(s.meanIntensity(strcmp(s.group,'matrix')));
u.aveTotalIntensityStrio = constantValues(s.totalIntensity(strcmp(s.group,'strio')));
u.aveTotalIntensityMatrix = constantValues(s.totalIntensity(strcmp(s.group,'matrix')));
u.aveMedianIntensityStrio = constantValues(s.medianIntensity(strcmp(s.group,'strio')));
u.aveMedianIntensityMatrix = constantValues(s.medianIntensity(strcmp(s.group,'matrix')));
end

function ret = constantValues(arr)
if length(arr) <= 1
    ret = [];
    return;
end

arr = double(arr);
m = mean(arr);
s = std(arr);
stdError = utils.std_error(arr);
ret = { m, s, stdError };
end

function [his, pdf, cdf] = comphist(arr)
BIN_EDGES = 0:255;

if length(arr) <= 1
    his = []; pdf = []; cdf = [];
    return;
end

his = histcounts(arr, BIN_EDGES);
pdf = his / sum(his);
cdf = cumsum(his / sum(his));
end

