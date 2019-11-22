function miceType = getFirstSessionType(twdb,miceType)

miceIDs = get_mouse_ids(twdb,0,'all','all','all','all','all','all',{});
for m = 1:length(miceIDs)
    mouseID = miceIDs{m};
    miceType_idx = first(twdb_lookup(miceType,'index','key','ID',mouseID));
    sessionOne_idx = cell2mat(twdb_lookup(twdb,'index','key','mouseID',mouseID,'key','sessionNumber',1));
    [~,firstSessionDate_idx] = min(datetime({twdb(sessionOne_idx).sessionDate}));
    firstSession_idx = sessionOne_idx(firstSessionDate_idx);
    firstSessionType = twdb(firstSession_idx).taskType;
    miceType(miceType_idx).firstSessionType = firstSessionType;
end