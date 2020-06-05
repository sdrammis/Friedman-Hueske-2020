function [props] = graph_splits(engaged,notEngaged, num_splits)

props = [];
figure()
subplot(num_splits,1,1)
graph_licks(engaged{1}, notEngaged{1}, [])
prop1 = height(engaged{1}) / (height(engaged{1})+height(notEngaged{1}));
title(['Engagement prop: ', num2str(prop1*100)])

props = [prop1];
if num_splits > 1
    subplot(num_splits,1,2)
    graph_licks(engaged{2}, notEngaged{2}, [])
    prop2 = height(engaged{2}) / (height(engaged{2})+height(notEngaged{2}));
    title(['Engagement prop: ', num2str(prop2*100)])
    
   
    props = [prop1,prop2];
    if num_splits > 2
        subplot(num_splits,1,3)
        graph_licks(engaged{3}, notEngaged{3}, [])
        prop3 = height(engaged{3}) / (height(engaged{3})+height(notEngaged{3}));
        title(['Engagement prop: ', num2str(prop3*100)])
        
        props = [prop1,prop2,prop3];
        if num_splits > 3
            subplot(num_splits,1,4)
            graph_licks(engaged{4}, notEngaged{4}, [])
            prop4 = height(engaged{4}) / (height(engaged{4})+height(notEngaged{4}));
            title(['Engagement prop: ', num2str(prop4*100)])
            props = [prop1,prop2,prop3,prop4];
            
                if num_splits > 4
                    subplot(num_splits,1,5)
                    graph_licks(engaged{5}, notEngaged{5}, [])
                    prop5 = height(engaged{5}) / (height(engaged{5})+height(notEngaged{5}));
                    title(['Engagement prop: ', num2str(prop5*100)])
                    props = [prop1,prop2,prop3,prop4,prop5];
                end
        end
        
    end
end

end
