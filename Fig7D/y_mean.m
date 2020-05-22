function [xnew, ynew] = y_mean(x,y)
xnew = [];
ynew = [];

uniqx = unique(x);
for ix=uniqx
   xnew = [xnew; ix];
   ynew = [ynew; mean(y(ix == x))];
end
end