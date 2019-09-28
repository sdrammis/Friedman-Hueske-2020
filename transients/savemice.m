% Create file of spikes per mouse. Filter out bad spikes.

load('../dbs/micedb.mat');
% load('../dbs/twdb_here.mat');
conf = config();

for iMice=1:size(micedb,2)
    fprintf('Progress %d/%d ... \n', iMice, size(micedb,2));
    mouse = micedb(iMice);
    sessionIdxsTask1 = utils.get_mouse_sessions(twdb, mouse.ID, 1, 0, 'all', 0);
    sessionIdxsTask2 = utils.get_mouse_sessions(twdb, mouse.ID, 0, 0, 'all', 0);

    trialsTask1 = utils.get_trials(twdb, sessionIdxsTask1);
    trialsTask2 = utils.get_trials(twdb, sessionIdxsTask2);

    filename = [conf.MICE_DIR filesep mouse.ID '.mat'];
    save(filename, 'trialsTask1', 'trialsTask2');
    fprintf('Saved mouse %s.\n', mouse.ID);
end
 