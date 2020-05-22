function generatestriomasks(outdir)
STRIO_PATH = '/Volumes/annex4/afried/resultfiles/system-tree/strio_analysis/done';
IMGS_PATH = '/Volumes/smbshare/analysis3/strio_matrix_cv/Alexander_Emily_Erik/FINAL EXPORTED IMAGES';

mkdir(outdir);

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

  if ~isfile([STRIO_PATH '/' exid '-done.txt'])
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

  [strio, matrix] = compstriomasks(strioImgPth, strioMsksPth, strioThrshsPth, realsize);
  save([outdir '/' exid '-striomasks.mat'], 'strio', 'matrix');

  img = imreadvisible(strioImgPth);
  strioMaskColored = cat(3, strio*0, strio*1, strio*0);
  matrixMaskColored = cat(3, matrix*1, matrix*0, matrix*1);
  f = figure('units','normalized','outerposition',[0 0 1 1]);
  subplot(2,2,[1 3]);
  imshow(img);
  hold on;
  h1 = imshow(strioMaskColored);
  h2 = imshow(matrixMaskColored);
  hold off;
  set(h1,'AlphaData',img*0.2);
  set(h2,'AlphaData',img*0.3);
  subplot(2,2,2);
  imshow(strio);
  subplot(2,2,4);
  imshow(matrix);
  saveas(f, [outdir '/' exid '-debug.png']);
  close all;
end
end

