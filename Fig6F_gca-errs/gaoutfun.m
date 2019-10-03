function [state,options,optchanged] = gaoutfun(options,state,flag)
persistent activityT1s activityT2s
optchanged = false;
connectivity = [];

switch flag
    case 'init'
        activityT1s = [];
        activityT2s = [];
        connectivity = mean(state.Population, 1);
    case 'iter'
        connectivity = mean(state.Population, 1);
    case 'done'
        assignin('base', 'ga_activityT1s', activityT1s);
        assignin('base', 'ga_activityT2s', activityT2s);
        return
end

if ~isempty(connectivity)
    [activityT1, activityT2] = runnet(connectivity,1);
    activityT1s = [activityT1s activityT1];
    activityT2s = [activityT2s activityT2];
end
end
