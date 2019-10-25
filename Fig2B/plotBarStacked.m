%stacked bar graph
% xlab cell aray of strings
function plotBar(barYData,yLab,xLab,titleStr, textLabs)

title(titleStr);
ylabel(yLab);

y = barYData;



b = bar(y, 'stacked');
%b.FaceColor = 'flat';
%mycolor = [0 0.4470 0.7410;.8500 0.3250 0.0980; 0 0.4470 0.7410;.8500 0.3250 0.0980; 0 0.4470 0.7410;.8500 0.3250 0.0980]; 
%for i = 1:size(y,2)
    %if mod(i,2) == 1 
      %  b.CData(i, :) = [1, 0, 0];
   % else
       % b.CData(i, :) = [0, 0, 1];
   % end
  % b.CData(i, :) = mycolor(i, :);
%end



set(gca,'XTickLabel',xLab,'XTick',1:numel(xLab));
xtickangle(45);
xt = get(gca,'XTick');


% scatter and text label
for i = 1:numel(xLab)
    text(xt(i),y(i),textLabs{i},'horiz','center','vert','bottom');
    %text(xt(i),y(i),'horiz','center','vert','bottom');
    dat = y(i);
    scatter(repmat(xt(i),length(dat),1),dat,'MarkerEdgeColor','m');
%end

end