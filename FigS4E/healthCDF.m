function [miceCDF1, miceCDF2, miceIDs] = healthCDF(twdb,health,taskReversal,engaged,wantedSessions,reverse,exceptions)

miceIDs = get_mouse_ids(twdb,taskReversal,health,'all','all','all','all',0,exceptions);

for id = 1:length(miceIDs)
    [CDF1, CDF2] = mouseCDF(twdb,miceIDs{id},taskReversal,engaged,wantedSessions,reverse);
    miceCDF1(id,1:length(CDF1)) = CDF1;
    miceCDF2(id,1:length(CDF2)) = CDF2;
end