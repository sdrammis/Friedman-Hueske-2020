function [activityT1, activityT2, numEventsT1, numEventsT2] =  runnet(connectivity, eng)
ret =  py.run_net.run_net(py.list(connectivity),eng);
activityT1 = ret{1};
activityT2 = ret{2};
numEventsT1 = ret{3};
numEventsT2 = ret{4};
end
