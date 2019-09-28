DATA_PATH = "/Users/Alexander/Desktop/VGlut_testing/out.csv";
IMG_PATH = "C:/Users/Alexander/Desktop/VGlut_testing/2018-09-02 alexandermatrixfirstcohort-2826_slice2_vglut.tiff";
%H:/vglut_points_output/Not Working Images/2018-09-02 alexandermatrixfirstcohort-2833_slice1_vglut.tiff
%% Import imagej script CSV output
opts = delimitedTextImportOptions("NumVariables", 3);
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";
opts.VariableNames = ["centroid", "boundaryX", "boundaryY"];
opts.VariableTypes = ["string", "string", "string"];
opts = setvaropts(opts, [1, 2, 3], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
data = readtable(DATA_PATH, opts);
clear opts

%% Display dots on original figure
f = figure;
imshow(mat2gray(imread(IMG_PATH)));
hold on;
for iData=1:10000
    boundaryX = str2num(data{iData,'boundaryX'});
    boundaryY = str2num(data{iData,'boundaryY'});
    plot(boundaryX, boundaryY);
end