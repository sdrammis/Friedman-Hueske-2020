TMP_PTH = './tmp/msndensity_cc';

mouseID = '3816'; % slice3 -- stacks: -1, -2, 0, 1, 2
load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/dbs/micedb.mat');
load('./dbs/dimensions.mat');

e11Dlx1D1Mice = {'2447', '5233', '3348', '4229'};
e11Dlx1D2Mice = {'3337', '3343', '3084', '3085'};
e11Mash1D1Mice = {'3552', '3545', '3535', '3536'};
e11Mash1D2Mice = {'3128', '3131', '3130', '3562'};
strioMice = [e11Dlx1D1Mice e11Dlx1D2Mice e11Mash1D1Mice e11Mash1D2Mice];

imgSrcRed = [TMP_PTH '/2019-02-12\ d2\ tdtomato\ cell\ counts\ experiment\ 5-3816_slice3_texa_0.tiff'];
imgRed = imread(imgSrcRed);
msnCells = cellcounts.find.find_red_cells(imgRed, 2);

masksPth = [TMP_PTH '/cc5_3816_slice3_19-06-06-masks.mat'];
thrshsPth = [TMP_PTH '/cc5_3816_slice3_19-06-06-threshs.json'];
imgPth = [TMP_PTH '/2019-02-12\ d2\ tdtomato\ cell\ counts\ experiment\ 5-3816_slice3_strio.tiff'];
[strio, matrix] = utils.compstriomasks(imgPth, masksPth, thrshsPth, 2, 'cc');

if any(strcmp(strioMice, mouseID))
    striosomality = 'Strio';
else
    striosomality = 'Matrix';
end
[cellsStrio, cellsMatrix] = msndensity.labelcells(msnCells, strio, matrix, striosomality);
