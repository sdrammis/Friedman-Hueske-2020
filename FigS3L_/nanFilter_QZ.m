% 07/08/2019
% Author: QZ
function [arr1,arr2,nanIdxs,cellArr] = nanFilter_QZ(array1,array2,cellArray)
% arrays should be of the same length
nanIdxs = unique([find(isnan(array1)),find(isnan(array2))]);
arr1 = array1;
arr2 = array2;
cellArr = cellArray;
arr1(nanIdxs) = [];
arr2(nanIdxs) = [];
cellArr(nanIdxs) = [];
end