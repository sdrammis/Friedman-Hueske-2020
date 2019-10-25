function scatter(twdb,n_learning_sections,n_session_sections,include_last,threshold)

%% CHECK USER PARAMETERS


%% GET DATA
% roc_data = load_roc_data(twdb, n_learning_sections, n_session_sections, 'IgnoreSplit');
r = ROC(twdb, n_learning_sections, n_session_sections, 'IgnoreSplit');

mice_types = {'WT', 'HD'};
n_mice_types = length(mice_types);

learning_major = n_learning_sections < n_session_sections;                  % learning major means learning sections over time are plotted over ROWS

if learning_major
    n_rows = n_mice_types * n_learning_sections;
    n_columns = n_session_sections;

    if include_last
        n_rows = n_rows + 1;
    end
else
    n_rows = n_mice_types * n_session_sections;
    n_columns = n_learning_sections;

    if include_last
        n_columns = n_columns + 1;
    end
end

%% PLOT DATA
figure()
for k = 1:n_mice_types
    mouse_type = mice_types{k};

    % t_data = roc_data{1}(mouse_type)
    % f_data = roc_data{2}(mouse_type)
    % d_data = roc_data{3}(mouse_type);
    % c_data = roc_data{4}(mouse_type);
    t_data = r.TDataUnsplit(mouse_type);
    f_data = r.FDataUnsplit(mouse_type);
    d_data = r.DDataUnsplit(mouse_type);
    c_data = r.CDataUnsplit(mouse_type);


    mice_n = size(t_data, 1);

    d_avg = cellfun(@mean, d_data);
    c_avg = cellfun(@mean, c_data);

    d_group_avg = mean(d_avg, 1);
    c_group_avg = mean(c_avg, 1);

    d_group_std = std(d_avg, 1);
    c_group_std = std(c_avg, 1);

    d_group_sem = d_group_std / sqrt(mice_n);
    c_group_sem = c_group_std / sqrt(mice_n);

    d_group_avg = reshape(d_group_avg, [n_learning_sections, n_session_sections]);
    c_group_avg = reshape(c_group_avg, [n_learning_sections, n_session_sections]);

    d_group_sem = reshape(d_group_sem, [n_learning_sections, n_session_sections]);
    c_group_sem = reshape(c_group_sem, [n_learning_sections, n_session_sections]);

    for i = 1:n_learning_sections
        for j = 1:n_session_sections
            t_arr = t_data(:, i, j)';
            f_arr = f_data(:, i, j)';
%
%             if learning_major
%                 index = ((k - 1) * (n_learning_sections + include_last) * n_session_sections) + ((i - 1) * n_session_sections) + j;
%             else
%                 index = ((k - 1) * (n_learning_sections + include_last) * n_session_sections) + ((i - 1) * n_session_sections) + j;
%             end

            index = ((k - 1) * (n_learning_sections + include_last) * n_session_sections) + ((i - 1) * n_session_sections) + j;

            subplot(n_rows, n_columns, index)
            plot_roc(t_arr, f_arr, d_group_avg(i, j), c_group_avg(i, j), 'SEMD', d_group_sem(i, j), 'SEMC', c_group_sem(i, j));
            title([mouse_type ' ROC; Learning ' num2str(i) '/' num2str(n_learning_sections) '; Section ' num2str(j) '/' num2str(n_session_sections)])
        end
    end

    if include_last % only tested with n_session_sections = 1; might have to subscript differently otherwise
        [t, f, d, c] = last_sessions_data(r, mouse_type, threshold);

        d_avg = mean(d);
        d_sem = std(d) / length(d);

        c_avg = mean(c);
        c_sem = std(c) / length(c);

        index = ((k - 1) * (n_learning_sections + include_last) * n_session_sections) + n_learning_sections + 1;

        subplot(n_rows, n_columns, index);
        plot_roc(t, f, d_avg, c_avg, 'SEMD', d_sem, 'SEMC', c_sem);
        title([mouse_type ' ROC; Last ' num2str(threshold) ' Sessions; Section ' num2str(j) '/' num2str(n_session_sections)])
    end
end
