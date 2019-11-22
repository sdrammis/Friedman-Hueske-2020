function [mouse,task,session,dateTime,boxNum]=fp_parseBehavioralFilename(filename)

% filename='2658_tt_05_20170915-1412_box105.txt'
[~,filename,~] = fileparts(filename) ;
C = strsplit(filename,'_');
if length(C)~=5
    mouse=NaN;
    task=NaN;
    session=NaN;
    dateTime=NaN;
    boxNum=NaN;
else
    boxNum=0;
    mouse=[C{1}];
    task=[C{2}];
    session=str2num([C{3}]);
    dateTime=[C{4}];
    strBoxNum=[C{5}];
    boxNum=sscanf(strBoxNum,'box%d');
end
