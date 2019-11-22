function twdb = twdb_add_HD_DB(fileDir)
%adds individual .txt file to database
twdb = [];
path = strsplit(fileDir,'/');
filename = path{end};

data = strsplit(filename,'_');

if length(data) >= 5
    twdb(end+1).mouseID = data{1};
    if isequal(data{2},'2t')
        twdb(end).taskType = 'tt';
    else
        twdb(end).taskType = lower(data{2});
    end
    
    if isequal(twdb(end).taskType,'tt')
        twdb(end).rewardTone = 1;
        twdb(end).costTone = 2;
    elseif isequal(twdb(end).taskType,'2tr')
        twdb(end).rewardTone = 2;
        twdb(end).costTone = 1;
    else
        movefile(fileDir,'/Users/seba/Dropbox (MIT)/UROP/HD_exp/Behavioral Other Data Spike DB')
        twdb = [];
        return
    end
    
    twdb(end).sessionNumber = str2num(data{3});
    twdb(end).sessionDate =  [data{4}(1:4),'-',data{4}(5:6),'-',data{4}(7:8)];
    twdb(end).sessionYear = str2num(data{4}(1:4));
    twdb(end).sessionMonth = str2num(data{4}(5:6));
    twdb(end).sessionDay = str2num(data{4}(7:8));
    twdb(end).sessionTime =  [data{4}(10:11),':',data{4}(12:end)];
    twdb(end).sessionHour =  str2num(data{4}(10:11));
    twdb(end).sessionMinute =  str2num(data{4}(12:end));
    twdb(end).boxN = str2num(data{5}(4));
    
    fileExt = filename(end-2:end);
    if isequal(fileExt,'txt')
        twdb(end).eventData = load(fileDir);
    elseif isequal(fileExt,'mat')
        load(fileDir)
        twdb(end).eventData = fp_data;
    end
    
    twdb(end).filename = filename;
end