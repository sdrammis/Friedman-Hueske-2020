function spikes_wrapper(photometryFolder, spikesFolder,twdbFile)
%photometryFolder: Directory containing photometry data
%spikesFolder: Directory to store the extracted spikes data
%twdb: Database to add data to

%Folder containing photometry data that has had spikes extracted
finishedFolder = 'C:\Users\sdrammis\Dropbox (MIT)\research\CHDI Database Codes\Functions\Spikes Extraction (JX, STA, SD)\phot';

load(twdbFile)

files = dir(photometryFolder);
for n=1:length(files)
    file = files(n).name;
    if ~isequal(file,'.') && ~isequal(file,'..') && ~isequal(file,'.DS_Store')
        photFile = [photometryFolder filesep files(n).name];
        
        process_folder(photFile,spikesFolder);

        movefile(photFile,[finishedFolder filesep files(n).name]);
    end
end
% 
save(twdbFile,'twdb','-v7.3')