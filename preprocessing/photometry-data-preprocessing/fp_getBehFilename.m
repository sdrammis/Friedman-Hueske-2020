function filename=fp_getBehFilename(sessionFolder,boxNum)
% sessionFolder='C:\Users\Delcasso\Desktop\MIT fp\DataSets\20171108-1521_test02'; % where all the data are
% boxNum=101;
matFilename=[sessionFolder filesep 'fpData.mat'];
load(matFilename);
nFiles=size(beh_filename,2);
for iFile=1:nFiles
    n=beh_filename{iFile};
   if ~isempty(findstr(n,sprintf('box%d.txt',boxNum)))
       fprintf('find %s',n);
       bData=beh_data{iFile};
       filename=n;
   end
end
