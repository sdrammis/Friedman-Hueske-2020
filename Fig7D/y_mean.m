function [xnew, ynew] = y_mean(x,y, isEntropy, isVariance)
xnew = [];
ynew = [];
mthre = 0.05;
uniqx = unique(x);
prev_ymean = mean(y(x == uniqx(1)));
for idx=1:length(uniqx)
    ix = uniqx(idx);
    ysforx = y(ix == x);
    m = mean(ysforx);
%     if length(ysforx) > 3 && m > mthre
% %     ysforx = ysforx(1,ysforx(1,:)>0);
%         ysforx = ysforx - m;
%         s = std(ysforx);
%         bins = 1;
%       
%         if isEntropy
%             ent = getEntropy(ysforx,bins);
%             if ent > 0
%                 xnew = [xnew; ix];
%                 ynew = [ynew; (prev_ymean - mean(ysforx))/ent];
%                 prev_ymean = mean(ysforx);
%             end
%         elseif isVariance
%             if s > 0
%                 xnew = [xnew; ix];
% %                 ynew = [ynew; (prev_ymean - mean(ysforx))/std(ysforx)];
% %                 prev_ymean = mean(ysforx);
%                 ynew = [ynew; 1/s];
%             end
%         end
%     else
        xnew = [xnew; ix];
        ynew = [ynew; m];
%     end
end
end

