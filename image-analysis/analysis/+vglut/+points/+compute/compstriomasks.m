function [strio, matrix] = compstriomasks(strioImgPth, vglutImgPth, strioMsksPth, strioThrshsPth, realsize, varargin)
FOP_MASKS_PTH = '/annex4/afried/resultfiles/analysis_output/vglut_kian/manual_masks';

excsM = utils.dbload('./dbs/db.json');
for iExc=1:length(excsM)
    excsM(iExc).slice = lower(excsM(iExc).slice);
end

load('./dbs/fopthreshs.mat');

splits = strsplit(vglutImgPth, '/');
name = strrep(splits{end}, '.tiff', '');
varargin = {};

% 1. Check if a manual mask has been create for fibers of passage.
fopMaskPth = [FOP_MASKS_PTH '/' name '_mask.tif'];
if exist(fopMaskPth, 'file') == 2
    fibersOfPassage = ~logical(imread(fopMaskPth));
    varargin = {'fibersOfPassage', fibersOfPassage};
end

% 2. Check if a threshold exists for the image.
t = fopthreshs{strcmp(fopthreshs.FileName, [name '.tiff']), 'TValue'};
if ~isempty(t)
   varargin = {'t', t}; 
end

% 3. Compute the masks
slicename = lower(name(1:end-6));
idx = twdb_lookup(excsM, 'index', 'key', 'slice', lower(slicename));
if isempty(idx)
    fprintf('No execution found for slice %s !! \n', slicename);
end
exid = excsM(idx{1}).exid;
if contains(exid, 'exp')
    stain = 1;
else
    stain = 2;
end

if stain == 2
    [strio, matrix] = vglut.points.compute.compstriomasks2(...
        strioImgPth, vglutImgPth, strioMsksPth, strioThrshsPth, realsize, varargin{:});
else
    [strio, matrix] = vglut.points.compute.compstriomasks1(...
        strioImgPth, strioMsksPth, strioThrshsPth, realsize, varargin{:});
end
end
