function [strioAvgExpr, matrixAvgExpr, strioAvgExprWithFibers, matrixAvgExprWithFibers, strioSize] = ...
    vglut_get_slice_expression(vglutPth, strioPth, masksPth, thrshsPth, realsize)

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

[centers, centersAndRims] = utils.compstriomasks(strioPth, masksPth, thrshsPth, realsize);
hull = bwconvhull(centersAndRims);

imgVglut = imread(vglutPth);

[m, n] = size(imgVglut);
pixelSize = realsize / (m*n);

strioMask = imfill(centers, 'holes') & ~fibersOfPassage;
strioVglut = imgVglut;
strioVglut(~strioMask) = 0;
strioAvgExpr = sum(sum(strioVglut)) / nnz(strioMask) / pixelSize;

strioMaskWithFibers = imfill(centers, 'holes');
strioVglutWithFibers = imgVglut;
strioVglutWithFibers(~strioMaskWithFibers) = 0;
strioAvgExprWithFibers = sum(sum(strioVglutWithFibers)) / nnz(strioMaskWithFibers) / pixelSize;

centersAndRimsFilled = imfill(centersAndRims, 'holes');
matrixMask = hull & ~fibersOfPassage & ~centersAndRimsFilled;
matrixVglut = imgVglut;
matrixVglut(~matrixMask) = 0;
matrixAvgExpr = sum(sum(matrixVglut)) / nnz(matrixMask) / pixelSize;

matrixMaskWithFibers = hull & ~centersAndRimsFilled;
matrixVglutWithFibers = imgVglut;
matrixVglutWithFibers(~matrixMaskWithFibers) = 0;
matrixAvgExprWithFibers = sum(sum(matrixVglutWithFibers)) / nnz(matrixMaskWithFibers) / pixelSize;

strioSize = nnz(strioMaskWithFibers);
end

