IMAGES_PATH = '/Volumes/smbshare/analysis3/strio_matrix_cv/Alexander_Emily_Erik/FINAL EXPORTED IMAGES';
OUTPUT_PATH = '/Volumes/smbshare/analysis3/strio_matrix_cv/analysis_output/cell_counts_redv2';
NUM_DIRS = 5;

for k=1:NUM_DIRS
    dirContents = dir([IMAGES_PATH '/cell_counts_'  num2str(k)]);
    files = {dirContents(:).name};
    
    for i=1:length(files)
        file = files{i};
        if isempty(regexpi(file, '.*_slice[0-9]+\.tiff'))
            continue;
        end
        
        splits = split(file, '.');
        prefix = splits{1};
        
        for stack=-2:2
            imgNameRed = [prefix '_texa_' num2str(stack) '.tiff'];
            imgSrcRed = [IMAGES_PATH '/cell_counts_'  num2str(k) '/' imgNameRed];
            imgRed = imread(imgSrcRed);
            redCells = find_red_cells(imgRed, 0.78765625);
            
            imgNameGreen = [prefix '_fitc_' num2str(stack) '.tiff'];
            imgSrcGreen = [IMAGES_PATH '/cell_counts_'  num2str(k) '/' imgNameGreen];
            imgGreen = imread(imgSrcGreen);
            
            imgRedDisp = img_read_visible(imgSrcRed);
            imgGreenDisp = mat2gray(imgGreen);
                        
            red = cat(3,logical(redCells),redCells*0,redCells*0);
            fRed = figure('units','normalized','outerposition',[0 0 1 1]);
            imshow(imgRedDisp);
            hold on;
            h = imshow(red);
            hold off;
            set(h, 'AlphaData', redCells * 0.5  + ~redCells * 0);
            
            fGreen = figure('units','normalized','outerposition',[0 0 1 1]);
            imshow(imgGreenDisp);
            
            saveas(fRed, sprintf('%s/%s_%d_red.png', OUTPUT_PATH, prefix, stack));
            saveas(fGreen, sprintf('%s/%s_%d_green.png', OUTPUT_PATH, prefix, stack));
            save(sprintf('%s/%s_%d_data.mat', OUTPUT_PATH, prefix, stack), 'redCells', '-v7.3');
            close all;
        end
    end
end

