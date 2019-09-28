conf = config();
% load('../dbs/light_twdb_2019-06-06.mat');

failed = {};
for row=1:size(twdb,2)
    session = twdb(row);
    if isempty(session.raw470Session) || isempty(session.raw405Session)
        continue;
    end

    try
        fprintf('Progress %d/%d ... \n', row, size(twdb,2));
        times470 = session.raw470Session(:,1);
        trace470 = session.raw470Session(:,2);
        times405 = session.raw405Session(:,1);
        trace405 = session.raw405Session(:,2);
        spikes = extraction.process_session(times470, trace470, times405, trace405);
    catch
        warning('Faile to run row %d!\n', row);
        failed{end+1} = row;
        continue;
    end

    index = session.index;
    mouseID = session.mouseID;
    taskType = session.taskType;
    sessionNumber = session.sessionNumber;
    fname = sprintf('idx%d_m%s_%s_s%d.mat', index, mouseID, taskType, sessionNumber);
    fprintf('Saving output %s ... \n', fname);
    save([conf.SPIKES_DIR filesep fname], 'spikes');
end
