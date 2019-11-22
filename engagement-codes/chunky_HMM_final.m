function chunky_HMM_final(arg)
    args = chunky_args(arg);
    load(args{1});
    mouseID = args{2};
    num_states = str2double(args{3});
    lick_threshold = str2double(args{4});
    window_size = args{5};
    transition_init = str2double(args{6});
    all_tones = str2double(args{7});
    outDir = args{8};
    if sum(isletter(window_size)) ~= length(window_size)
        window_size = str2double(window_size);
    end
    run_HMM_final(trialDataDB,mouseID,num_states,lick_threshold,window_size,...
        transition_init,all_tones,outDir);
end