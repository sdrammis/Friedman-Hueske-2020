function imdetect(stain, imsrc, datapth, debugpth)

try
    im = imread(imsrc);
catch
    warning('Could not open file %s! - skipping\n', imsrc);
    return;
end

splits1 = strsplit(imsrc, '\');
imname = splits1{end};
splits2 = strsplit(imname, '.');
name = splits2{1};

% Only consider the dorsal lateral (bottom middle) region.
% Load points from spreadsheet computed by hand.
load('./dbs/vglutregions.mat');
region = vglutregions(lower(vglutregions.Name) == lower(imname),:);
if isempty(region)
   fprintf('OH NO: Could not find region points for image %s!!!\n', imsrc); 
   return;
end
cs = region.X1;
ct = region.X2;
rs = region.Y1;
rt = region.Y2;
if isnan(cs) || isnan(ct) || isnan(rs) || isnan(rt)
    return;
end 

% Run the Java ImageJ detection program
if stain == 1
    javaMethod('run', VGlutIJ, imsrc, datapth, rs, rt, cs, ct);
else
    javaMethod('run', VGlutIJ2, imsrc, datapth, rs, rt, cs, ct);
end

% Import imagej script CSV output
opts = delimitedTextImportOptions("NumVariables", 3);
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";
opts.VariableNames = ["centroid", "boundaryX", "boundaryY"];
opts.VariableTypes = ["string", "string", "string"];
opts = setvaropts(opts, [1, 2, 3], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
data = readtable(datapth, opts);
clear opts

% Save the bottom middle region zoomed out.
f = figure;
subplot(1,2,1);
imshow(mat2gray(im));
subplot(1,2,2);
imshow(mat2gray(im));
hold on;
for iData=1:height(data)
    boundaryX = str2num(data{iData,'boundaryX'});
    boundaryY = str2num(data{iData,'boundaryY'});
    
    if isempty(boundaryX) || isempty(boundaryY)
        % NOTE: There is a bug in the Java saving of the stringified array
        % where it will not save the entire array (eg. "[100, 100, 101,").
        % This happens infrequently so we ignore it fore now
        continue;
    end
    
    plot(boundaryX, boundaryY, 'r');
end
ylim([rs rt]);
xlim([cs ct]);
saveas(f, [debugpth '\' name '-full'], 'png');
close all;

% Saved the bottom middle region zoomed in. 
f = figure;
zoomSideLen = 300;
subplot(1,2,1);
imshow(mat2gray(imcrop(im, [cs rs zoomSideLen zoomSideLen])));
subplot(1,2,2);
imshow(mat2gray(imcrop(im, [cs rs zoomSideLen zoomSideLen])));
hold on;
for iData=1:height(data)
    boundaryX = str2num(data{iData,'boundaryX'});
    boundaryY = str2num(data{iData,'boundaryY'});    
    if isempty(boundaryX) || isempty(boundaryY)
        % NOTE: There is a bug in the Java saving of the stringified array
        % where it will not save the entire array (eg. "[100, 100, 101,").
        % This happens infrequently so we ignore it fore now
        continue;
    end
    
    centroid = str2num(data{iData,'centroid'});
    x = centroid(1);
    y = centroid(2);
    if x >=cs && x <= cs + zoomSideLen && y >= rs && y <= rs + zoomSideLen
        plot(boundaryX-cs, boundaryY-rs, 'r');
    end    
end
saveas(f, [debugpth '\' name '-zoom'], 'png');
close all;
end
