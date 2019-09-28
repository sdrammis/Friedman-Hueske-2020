IMGS_DIR = '\\chunky.mit.edu\annex4\afried\resultfiles\FINAL_EXPORTED_IMAGES';
DATA_PTH = 'F:\vglut_points_output\data3';
DEBUG_PTH = 'F:\vglut_points_output\debug3';

STAIN = 1;
FILEEXPR = '.*vglut.tiff';
if STAIN == 1
    direxpr = 'experiment [1-6]';
else
    direxpr = 'VGLUT.*';
end

javaaddpath('./+vglut/+points/+detection');
javaaddpath('./+vglut/+points/+detection/loci_tools.jar');
javaaddpath('./+vglut/+points/+detection/ij.jar');

subdirs = dir(IMGS_DIR);
dirs = subdirs([subdirs.isdir]);
for k = 1 : length(dirs)
    dirname = dirs(k).name;
    disp(dirname);
    if isempty(regexp(dirname, direxpr, 'ONCE'))
        continue;
    end
       
    files = dir([IMGS_DIR '\' dirname]);
    for j = 1 : length(files)
        filename = files(j).name;
        if isempty(regexp(filename, FILEEXPR, 'ONCE'))
           continue; 
        end
        
        fprintf('Working on file %s ...\n',  filename);
        name = strrep(filename, '.tiff', '');
        imsrc = [IMGS_DIR '\' dirname '\' filename];
        datapth = [DATA_PTH '\' name '.csv'];
        vglut.points.detection.imdetect(STAIN, imsrc, datapth, DEBUG_PTH);
    end
end
