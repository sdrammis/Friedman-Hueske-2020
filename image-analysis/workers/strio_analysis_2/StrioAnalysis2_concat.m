function StrioAnalysis2_concat(exid, doneDir, ~, manualDir, thresholdsJSON)
load(sprintf('%s/%s-data.mat', manualDir, exid));

centersMask = nan(imgWidth, imgHeight);
rimsMask = nan(imgWidth, imgHeight);

thresholds = jsondecode(thresholdsJSON);
for region=1:length(thresholds)
    threshold = thresholds(region);
    if isnan(threshold)
        continue;
    end
    
    [r1, r2, c1, c2] = get_slice_coords(region, imgWidth, imgHeight);
    centersMask(r1:r2, c1:c2) = centers{region,threshold};
    rimsMask(r1:r2, c1:c2) = rims{region,threshold};
end
save(sprintf('%s/%s-data.mat', doneDir, exid), 'centersMask', 'rimsMask', '-v7.3');
end

function [r1, r2, c1, c2] = get_slice_coords(region, imgWidth, imgHeight)
switch region
    case 1
        r1 = 1;
        r2 = floor(imgHeight/2);
        c1 = 1;
        c2 = floor(imgWidth/2);
    case 2
        r1 = 1;
        r2 = floor(imgHeight/2);
        c1 = floor(imgWidth/2)+1;
        c2 = imgWidth;
    case 3
        r1 = floor(imgHeight/2)+1;
        r2 = imgHeight;
        c1 = 1;
        c2 = floor(imgWidth/2);
    case 4
        r1 = floor(imgHeight/2)+1;
        r2 = imgHeight;
        c1 = floor(imgWidth/2)+1;
        c2 = imgWidth;
end
end

