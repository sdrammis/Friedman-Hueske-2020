function detect(imdir_, outdir, debugdir)
IMGS_ROOT = '/annex4/afried/resultfiles';

imdir = [IMGS_ROOT '/' imdir_];
dirContents = dir(imdir);
files = {dirContents(:).name};
regionIdxs = cellfun(@isempty, regexpi(files, 'Region [0-9]+.tiff'));
sliceIdxs = cellfun(@isempty, regexpi(files, 'slice[0-9]+.tiff'));
slices = files(~regionIdxs | ~sliceIdxs);

for i=1:length(slices)
    splits = split(slices{i}, '.');
    slce = splits{1};
    
    for stck=-20:20
        imsrc = [imdir '/' slce '_pv_' num2str(stck) '.tiff'];
        if ~isfile(imsrc)
            continue;
        end
        
        fprintf('Running detection on stack %d of slice "%s" \n', stck, slce);
        try
            cells = utils.msn.findcellsZ(imsrc, 2);
            if ~isempty(debugdir)
                f = figure;
                imshow(imoverlay(mat2gray(imread(imsrc)), bwperim(cells), 'g'));
                saveas(f, [debugdir '/' slce '_' num2str(stck) '_debug.fig']);
            end
        catch
            fprintf('ERROR: Detection failed on stack %d of slice "%s" \n', stck, slce);
            continue;
        end
        save([outdir '/' slce '_' num2str(stck) '_res.mat'], 'cells', '-v7.3');
    end
end
end
