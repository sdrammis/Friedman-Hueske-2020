function [mean,zscores]=get_data_info(output,filename)
new=[];
count=1;
for i=1:length(output)
    if output{i,1}<0||isnan(output{i,1})
        output{i,1}=NaN;
    else
        new=[new,output{i,1}];
        count=count+1;
    end
end
%zscores=zscore(new);
x=cell2mat(output(:,1));
mean=nanmean(cell2mat(output(:,1)));
zscores = (x - nanmean(x))/nanstd(x);
save(filename)
plot(zscores)
end
