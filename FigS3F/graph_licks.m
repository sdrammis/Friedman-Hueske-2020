function graph_licks(engaged, notEngaged, unknown)

%{
     for i = 1:length(engaged)
        if istable(engaged{i}) && istable(notEngaged{i})
            notEngaged{i}.NewEngagement = zeros(height(notEngaged{i}), 1);
            engaged{i}.NewEngagement = ones(height(engaged{i}), 1);
        elseif ~istable(engaged{i}) && istable(notEngaged{i})
            notEngaged{i}.NewEngagement = zeros(height(notEngaged{i}), 1);
            names = notEngaged{i}.Properties.VariableNames;
            engaged{i} = cell2table(cell(0,21), 'VariableNames', names);
        elseif istable(engaged{i}) && ~istable(notEngaged{i})
            engaged{i}.NewEngagement = ones(height(engaged{i}), 1);
            names = engaged{i}.Properties.VariableNames;
            notEngaged{i} = cell2table(cell(0,21), 'VariableNames', names);
        end  
    end
%}
    
        if istable(engaged) && istable(notEngaged)
            notEngaged.NewEngagement = zeros(height(notEngaged), 1);
            engaged.NewEngagement = ones(height(engaged), 1);
        elseif ~istable(engaged) && istable(notEngaged)
            notEngaged.NewEngagement = zeros(height(notEngaged), 1);
            names = notEngaged.Properties.VariableNames;
            engaged = cell2table(cell(0,21), 'VariableNames', names);
        elseif istable(engaged) && ~istable(notEngaged)
            engaged.NewEngagement = ones(height(engaged), 1);
            names = engaged.Properties.VariableNames;
            notEngaged = cell2table(cell(0,21), 'VariableNames', names);
        else
            if isempty(notEngaged{1})
                engaged{1}.NewEngagement = ones(height(engaged{1}), 1);
                names = engaged{1}.Properties.VariableNames;
                notEngaged{1} = cell2table(cell(0,21), 'VariableNames', names);
            elseif isempty(engaged{1})
                notEngaged{1}.NewEngagement = zeros(height(notEngaged{1}), 1);
                names = notEngaged{1}.Properties.VariableNames;
                engaged{1} = cell2table(cell(0,21), 'VariableNames', names);
            else
                engaged{1}.NewEngagement = ones(height(engaged{1}), 1);
                notEngaged{1}.NewEngagement = zeros(height(notEngaged{1}), 1);
            end
        end  
    
    if ~isempty(unknown)
        unknown.NewEngagement = ones(height(unknown), 1) * -1;
        if istable(engaged)
            trials = [engaged; notEngaged; unknown];
        else
            trials = [engaged{1}; notEngaged{1}];
        end      
    else
        if istable(engaged)
            trials = [engaged; notEngaged];
        else
            trials = [engaged{1}; notEngaged{1}];
        end
    end


    trials = sortrows(sortrows(trials, 'IDXofTrial'), 'SessionNumber');

    stimulus1 = trials.StimulusID == 1;
    licksResponse = trials.ResponseLickFrequency(stimulus1); 
    engagement = trials.NewEngagement(stimulus1);

    n = length(engagement);
    maxY = 10;
    p = patch([0 n n 0], ...
        [0 0 maxY maxY], 'r', 'EdgeColor', 'none');
    alpha(p, 0.25);

    for i=1:n
        x = [i-0.5 i+0.5 i+0.5 i-0.5];
        y = [0 0 maxY maxY];  
        z = [-2 -2 -2 -2];

        switch engagement(i)
            case 1
                p = patch(x, y, z, 'g', 'EdgeColor', 'none');
                %alpha(p, 0.75);
            case -1
                p = patch(x, y, z, 'b', 'EdgeColor', 'none');
                %alpha(p, 0.75);
        end
    end

    createPatches(1:n, licksResponse', 0.5, 'b', 1);
    xlim([0 n]);
    ylim([0 maxY]);

    ylabel('Resp Lick Freq');
    xlabel('Trials');

    

end