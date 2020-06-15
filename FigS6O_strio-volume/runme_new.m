excsM = dbload('./db.json');
for iExc=1:length(excsM)
  excsM(iExc).slice = lower(excsM(iExc).slice);
end

fin = fopen('./strio-imgs/exids.txt');
fout = fopen('./strio-imgs/img-names.txt','w');

exid = fgetl(fin);
while ischar(exid)
    exid = strtrim(exid);
    row = excsM(strcmp(exid, {excsM.exid}));
    fnew = [row.experiment '/' row.slice '_strio.tiff'];
    disp(fnew)
    fprintf(fout, '%s\n', fnew);
    exid = fgetl(fin);
end
fclose(fin);
fclose(fout);

function mask = removeFibersOfPassage(img, varargin)
imgBlur = imgaussfilt(img, 30);
h = imhist(imgBlur);
m = find(h == max(h(2:end)));

if ~isempty(varargin)
    t = varargin{1};
else  
    t = floor(m / 2);
    mask = (imgBlur > t);
end
end
