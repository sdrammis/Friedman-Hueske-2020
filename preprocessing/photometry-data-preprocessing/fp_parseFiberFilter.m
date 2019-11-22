function [date,fiberNum]=fp_parseFiberFilter(filename)
% filename='template-20171103-fiber-2.tif';
[~,filename,~] = fileparts(filename) ;
C = strsplit(filename,'-');
date=[C{2}];fiberNum=str2num([C{4}]);