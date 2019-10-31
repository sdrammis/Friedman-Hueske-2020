function mouse_2778(twdb)

mouseID = '2778';
plot_corr = true;
plot_BIC = false;
get_e_c = false;
include_deevaluate = true;

mouseDict = make_mousDict;
mouse_info = mouseDict(mouseID);
changept = mouse_info{1,1};
estimate_E = mouse_info{1,2} ;
estimate_T = mouse_info{1,3} ;
thresholds = mouse_info{1,4};
w = mouse_info{1,5};
num_splits = mouse_info{1,6};
is_strio = mouse_info{1,7};
newEng = mouse_info{1,8};
    
if plot_BIC
    figure('Name',[mouseID])
    [Ts, Es,~,x,y] = changePointAnalysisBICLine_LR(twdb, mouseID, mouse_type, w, estimate_E, estimate_T, thresholds, changept);
end

Ts = {estimate_T,estimate_T,estimate_T};
Es = {estimate_E,estimate_E,estimate_E};

[engaged, notEngaged, ~, ~] = typesOfTrials_s2e2(twdb, mouseID, thresholds, Ts, Es, changept,include_deevaluate);

graph_splits(engaged,notEngaged,2);
try
    [e_2778,ne_2778] = split_engaged(engaged,notEngaged,changept);
catch
end

if plot_corr
    [miceTrials_2778,fluorTrials_2778,rewardTone_2778,costTone_2778] = get_all_trials_eng(twdb,mouseID,e_2778,ne_2778,changept,1) ;  
    
    m1_2778= miceTrials_2778{1,1};
    f1_2778 = fluorTrials_2778{1,1};
    m2_2778 = miceTrials_2778{2,1};
    f2_2778 = fluorTrials_2778{2,1};
    m3_2778 = miceTrials_2778{3,1};
    f3_2778 = fluorTrials_2778{3,1};
    m4_2778 = miceTrials_2778{4,1};
    f4_2778 = fluorTrials_2778{4,1};
    
    bin_size = 20;
    
    engagement_trace_correlation_LR_fin(bin_size,m1_2778,f1_2778,rewardTone_2778,costTone_2778,{'2778'},1,1,1,0,0,0,0,1,0,'Epoch 1');
    engagement_trace_correlation_LR_fin(bin_size,m2_2778,f2_2778,rewardTone_2778,costTone_2778,{'2778'},1,1,1,0,0,0,0,1,0,'Epoch 2');
                                                                                                        

end


