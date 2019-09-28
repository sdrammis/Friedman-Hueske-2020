function detect(imgsDir_, outDir, debugDir)
% Finds MSN cell bodies and PV connection points.
% Outputs a data file per zstack image.

IMGS_ROOT = '/annex4/afried/resultfiles/FINAL_EXPORTED_IMAGES';

imgsDir = [IMGS_ROOT '/' imgsDir_];
dirContents = dir(imgsDir);
files = {dirContents(:).name};

regionIdxs = cellfun(@isempty, regexpi(files, 'Region [0-9]+.tiff'));
sliceIdxs = cellfun(@isempty, regexpi(files, 'slice[0-9]+.tiff'));
slices = files(~regionIdxs | ~sliceIdxs);

for i=1:length(slices)
    splits = split(slices{i}, '.');
    slce = splits{1};
    
    for stck=-20:20
        msnImgSrc = [imgsDir '/' slce '_msn_' num2str(stck) '.tiff'];
        pvImgSrc = [imgsDir '/' slce '_pv_' num2str(stck) '.tiff'];
        if ~isfile(msnImgSrc) || ~isfile(pvImgSrc)
            continue;
        end
        
        fprintf('Running detection on stack %d of slice "%s" \n', stck, slce);
        try
            [cellsMSN, blobsPV] = pvmsnconn.imdetect(msnImgSrc, pvImgSrc, debugDir);
        catch
            fprintf('Failed to run on msn=%s, pv=%s \n', msnImgSrc, pvImgSrc);
            continue;
        end
        save([outDir '/' slce '_' num2str(stck) '_res.mat'], 'cellsMSN', 'blobsPV', '-v7.3');
    end
end
end
