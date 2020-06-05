function plotEngagement(twdb)

[miceTrials,rewardTones] = get_mouse_trials(twdb,{'2782'},0,0);

trials = miceTrials{1};
stimulus1 = trials.StimulusID == rewardTones(1);
licksResponse = trials.ResponseLickFrequency(stimulus1); 
engagement = trials.Engagement(stimulus1);

figure
hold on
bar(licksResponse);
for i=1:length(engagement)
    x = [i-0.5 i+0.5 i+0.5 i-0.5];
    y = [0 0 max(ylim) max(ylim)];
    z = [-2 -2 -2 -2];
    if engagement(i) == 1
        p = patch(x, y, z, 'green', 'EdgeColor', 'none');
    elseif engagement(i) == 0
        p = patch(x, y, z, 'red', 'EdgeColor', 'none');
    else
        p = patch(x, y, z, 'black', 'EdgeColor', 'none');
    end
    alpha(p, 0.3);
end
ylabel('Resp Lick Freq');
xlabel('Trials');
title('2782')