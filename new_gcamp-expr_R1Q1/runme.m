STRIO_PATH = '/annex4/afried/resultfiles/system-tree/strio_analysis/done';
IMGS_PATH = '/smbshare/analysis3/strio_matrix_cv/Alexander_Emily_Erik/FINAL EXPORTED IMAGES';

% Load image real dimensions file
load('./dimensions.mat');

% Load the executions database
excsM = dbload('./db.json');
for iExc=1:length(excsM)
  excsM(iExc).slice = lower(excsM(iExc).slice);
end

% Iterate through slice names in DC regions spreadsheet
T = table2struct(readtable('regions.csv', 'Delimiter', ','));
for iT=1:size(T,1)
  rowT = T(iT,:);
  slicename = strrep(rowT.Name, '_vglut.tiff', '');

  % Get slice execution information
  idx = twdb_lookup(excsM, 'index', 'key', 'slice', lower(slicename));
  if isempty(idx)
     fprintf('No execution found for slice %s !! \n', slicename); 
     continue;
  end
  idx = idx{1};
  experiment = excsM(idx).experiment;
  exid = excsM(idx).exid;

  strioImgPth = [IMGS_PATH '/' experiment '/' slicename '_strio.tiff'];
  strioMsksPth = [STRIO_PATH '/' exid '-masks.mat'];
  strioThrshsPth = [STRIO_PATH '/' exid '-threshs.json'];

  if ~isfile(strioMsksPth)
      fprintf('No masks exist for exid %s \n', exid);
      continue;
  end

  % Get the image pixel size.
  w = dimensions.width(lower(dimensions.slice) == slicename);
  h = dimensions.height(lower(dimensions.slice) == slicename);
  if isempty(w) || isempty(h)
      fprintf('Could not find realsie for exid %s!!! \n', exid);
      continue;
  end
  realsize = w * h;

  [strio, matrix] = compstriomasks1( strioImgPth, strioMsksPth, strioThrshsPth, realsize);
end

% 2. Find execution info for the slice
% 3. If there is strio data, compute it
% 4. Apply the strio/matrix masks to the GCaMP image
% 5. Apply the DC cut to the image
% 6. Compute densities
% 7. Compute grades across all densities

