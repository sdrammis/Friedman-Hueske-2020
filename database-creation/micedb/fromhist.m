function micedb = fromhist(micedb, histfile)
% Moves relevent data from Erik's histology tables into the mice database.
% (eg. date perfused, experiment IDs)

% Import data from histology animal spreadsheet
opts = spreadsheetImportOptions("NumVariables", 4);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:D46";
opts.VariableNames = ["Animal", "Perfusionbrainextractiondate", "Perfusionnotes", "Histologyexperiment"];
opts.VariableTypes = ["string", "datetime", "categorical", "string"];
opts = setvaropts(opts, [1, 4], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 3, 4], "EmptyFieldRule", "auto");
animalsheet = readtable(histfile, opts, "UseExcel", false);
clear opts

for i=1:height(animalsheet)
    row = animalsheet(i,:);
    
    splitID = strsplit(row.Animal, " ");
    ID = char(splitID(1));
    idx = find(strcmp(ID, {micedb.ID}));
    if isempty(idx)
        idx = length(micedb) + 1;
        micedb(idx).ID = ID;
    end
    
    micedb(idx).perfusionDate = datestr(row.Perfusionbrainextractiondate, 'yy/mm/dd');
    micedb(idx).expIDs = str2double(strsplit(row.Histologyexperiment, ";"));
end

% Input metadata of perfused mice that never ran the task (not in
% Sebastian's origian miceType.mat database).
others = {...
    {'2824', 'WT', 'Matrix', -2, '2016-10-24'}, ...
    {'2826', 'WT', 'Matrix', -2, '2016-07-04'}, ...
    {'2830', 'WT', 'Matrix', -2, '2016-10-24'}, ...
    {'4947', 'WT', 'Strio', 1, '2016-08-04'}...
    };
for i=1:length(others)
   mouseID = others{i}{1};
   health = others{i}{2};
   intendedStriosomality = others{i}{3};
   histologyStriosomality = others{i}{4};
   birthDate = others{i}{5};
   
   idx = find(strcmp(mouseID, {micedb.ID}));
   micedb(idx).Health = health;
   micedb(idx).intendedStriosomality = intendedStriosomality;
   micedb(idx).histologyStriosomality = histologyStriosomality;
   micedb(idx).birthDate = birthDate;
end
end