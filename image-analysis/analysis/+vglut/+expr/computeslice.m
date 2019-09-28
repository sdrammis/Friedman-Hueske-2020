function [exprStrio, exprMatrix] = compexprslice(vglutPth, strioPth, masksPth, thrshsPth, realsize)
imgVglut = imread(vglutPth);

% Find the fibers of passage in the striosome.
imgStrio = utils.imreadvisible(strioPth);
imgInfo = imfinfo(strioPth);
bitDepth = imgInfo.BitDepth;
if bitDepth == 16
    imgStrio = uint8(imgStrio / 256);
end
imgStrioBlur = imgaussfilt(imgStrio, 40);
h = imhist(imgStrio);
m = find(h == max(h));
fibersOfPassage = ~(imgStrioBlur > m);

% Compute striosomes and bounding area.
[~, striosomes] = utils.compstriomasks(strioPth, masksPth, thrshsPth, realsize);
striosomes = imfill(striosomes, 'holes');
hull = bwconvhull(striosomes);

% Find the pixel size.
[m, n] = size(imgVglut);
pixelSize = realsize / (m*n);

% Compute strio expression.
strioMask = striosomes & ~fibersOfPassage;
strioVglut = imgVglut;
strioVglut(~strioMask) = 0;
exprStrio = sum(sum(strioVglut)) / nnz(strioMask) / pixelSize;

% Compute matrix expression.
matrixMask = hull & ~fibersOfPassage & ~striosomes;
matrixVglut = imgVglut;
matrixVglut(~matrixMask) = 0;
exprMatrix = sum(sum(matrixVglut)) / nnz(matrixMask) / pixelSize;
end

