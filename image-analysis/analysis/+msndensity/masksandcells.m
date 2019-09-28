STRIO_MASKS_PATH = '/annex4/afried/resultfiles/system-tree/strio_analysis/done';
IMAGES_PATH = '/annex4/afried/resultfiles/FINAL_EXPORTED_IMAGES';
DATABASE_PATH = '/annex4/afried/resultfiles/system-tree/db.json';
OUT_PATH = '/annex4/afried/resultfiles/analysis_output/msn_density/msn_density_v2';
EXPS_TO_RUN = {'exp1', 'exp2', 'exp3', 'exp4', 'exp5', 'exp6'};

load('./dbs/miceType.mat');
addpath(genpath('./utils'));
addpath(genpath('./lib'));

% Find slices to run on, must have strio masks.
fileObjs = dir([STRIO_MASKS_PATH '/*-done.txt']);
if isempty(fileObjs)
    return;
end

exids = erase({fileObjs.name}, '-done.txt');
for iExids=1:length(exids)
    exid = exids{iExids};
    
    % Only run on MSN cell dectection experiments
    if ~contains(exid, EXPS_TO_RUN)
        continue;
    end
    
    expr = utils.findexp(DATABASE_PATH, exid);
    slc = utils.findslice(DATABASE_PATH, exid);
    mouse = utils.findmouse(miceType, exid);
    
    % Compute strio mask.
    fprintf(['EXID ' exid ': Computing strio masks. \n']);
    imgStrio = [IMAGES_PATH '/' expr '/' slc '_strio.tiff'];
    masksStrio = [STRIO_MASKS_PATH '/' exid '-masks.mat'];
    thrshStrio = [STRIO_MASKS_PATH '/' exid '-threshs.json'];
    [strio, matrix] = utils.compstriomasks(imgStrio, masksStrio, thrshStrio, 2);
    
    for iStack=-10:10
        stck = num2str(iStack);
        
        imgPathMSN = [IMAGES_PATH '/' expr '/' slc '_msn_' stck '.tiff'];
        if ~isfile(imgPathMSN)
            continue;
        end
        
        % Find msn cell bodies for each slice stack.
        fprintf(['EXID ' exid ' Stack ' stck ' : Finding msn cell bodies. \n']);
        cells = utils.msn.findcellsZ(imgPathMSN, 2);
        
        % Label cell bodies as striosome or matrix.
        fprintf(['EXID ' exid ' Stack ' stck ' : Labeling msn cell bodies. \n']);
        striosomality = mouse.intendedStriosomality;
        [cellsStrio, cellsMatrix] = msndensity.labelcells(cells, strio, matrix, striosomality);
        
        % Save output debug figure.
        f = figure; 
        imshow(imoverlay(utils.imreadvisible(imgPathMSN), bwperim(cells), 'g'));
        saveas(f, [OUT_PATH '/debug_figs/' exid '_' stck '.fig']);
        close all;
              
        % Save assigned cells.
        save([OUT_PATH '/labeled_cells/' exid '_' stck '.mat'], 'cellsStrio', 'cellsMatrix', 'strio', 'matrix');  
    end
end
