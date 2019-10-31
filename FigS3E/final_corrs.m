function [R_bucket_1,R_bucket_2,R_bucket_3,slope_bucket_1,slope_bucket_2,slope_bucket_3 ] = final_corrs(mouse_info,cellType)
strio =  {'2610','2660','2703','2712','2734','2735','2778','2795'};
matrix  = {'3758','2705','2775','2713','3002'};

if isequal(cellType,'Strio')
    mice = strio;
elseif isequal(cellType,'Matrix')
    mice = matrix;
end

R_bucket_1 = [];
R_bucket_2 = [];
R_bucket_3 = [];
slope_bucket_1 = [];
slope_bucket_2 = [];
slope_bucket_3 =[];

    for i = 1:height(mouse_info)
        if ismember(mouse_info.MouseID{i},mice)
            if mouse_info.Proportions{i} < 33
                R_bucket_1 = [R_bucket_1; mouse_info.R{i}];
                slope_bucket_1 = [slope_bucket_1; mouse_info.Slope{i}];
            elseif mouse_info.Proportions{i} > 67
                 R_bucket_3 = [R_bucket_3; mouse_info.R{i}];
                slope_bucket_3 = [slope_bucket_3; mouse_info.Slope{i}];
            else 
                R_bucket_2 = [R_bucket_2; mouse_info.R{i}];
                slope_bucket_2 = [slope_bucket_2; mouse_info.Slope{i}];

            end
        end
            
    end
end

