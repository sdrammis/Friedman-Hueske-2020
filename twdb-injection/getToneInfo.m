function [tone_id,tone_on,tone_duration,tone_off,tone_vol] = getToneInfo(trial_data)


tone_id= NaN;
tone_on= NaN;
tone_duration = NaN;
tone_off = NaN;
tone_vol = NaN;

%Extraction of tone id and tone end
    if sum(trial_data(:,2)==21)%21 is tone 1 on id
        tone_id = 1;
        tone_on = trial_data(trial_data(:,2)==21,1);
        tone_duration = trial_data(trial_data(:,2)==23,1);
        tone_off = trial_data(trial_data(:,2)==24,1);
    elseif sum(trial_data(:,2)==25)%25 is tone 2 on id
        tone_id = 2;
        tone_on = trial_data(trial_data(:,2)==25,1);
        tone_duration = trial_data(trial_data(:,2)==27,1);
        tone_off = trial_data(trial_data(:,2)==28,1);
    elseif sum(trial_data(:,2)==93)%93 is tone 3 on id
        tone_id = 3;
        tone_on = trial_data(trial_data(:,2)==93,1);
        tone_duration = trial_data(trial_data(:,2)==95,1);
        tone_off = trial_data(trial_data(:,2)==96,1);
    elseif sum(trial_data(:,2)==128)%128 is morph tone 0 on id
        tone_id = 0;
        tone_on = trial_data(trial_data(:,2)==128,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==136,1)];
%         tone_off = trial_data(trial_data(:,2)==137,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
    elseif sum(trial_data(:,2)==104)%104 is morph tone 5 on id
        tone_id = 5;
        tone_on = trial_data(trial_data(:,2)==104,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==116,1)];
%         tone_off = trial_data(trial_data(:,2)==122,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
    elseif sum(trial_data(:,2)==105)%105 is morph tone 25 on id
        tone_id = 25;
        tone_on = trial_data(trial_data(:,2)==105,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==117,1)];
%         tone_off = trial_data(trial_data(:,2)==123,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
   elseif sum(trial_data(:,2)==106)%106 is morph tone 35 on id
        tone_id = 35;
        tone_on = trial_data(trial_data(:,2)==106,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==118,1)];
%         tone_off = trial_data(trial_data(:,2)==124,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
   elseif sum(trial_data(:,2)==107)%107 is morph tone 65 on id
        tone_id = 65;
        tone_on = trial_data(trial_data(:,2)==107,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==119,1)];
%         tone_off = trial_data(trial_data(:,2)==125,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
   elseif sum(trial_data(:,2)==108)%108 is morph tone 75 on id
        tone_id = 75;
        tone_on = trial_data(trial_data(:,2)==108,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==120,1)];
%         tone_off = trial_data(trial_data(:,2)==126,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
   elseif sum(trial_data(:,2)==109)%109 is morph tone 95 on id
        tone_id = 95;
        tone_on = trial_data(trial_data(:,2)==109,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==121,1)];
%         tone_off = trial_data(trial_data(:,2)==127,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
   elseif sum(trial_data(:,2)==132)%132 is morph tone 100 on id
        tone_id = 100;
        tone_on = trial_data(trial_data(:,2)==132,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==140,1)];
%         tone_off = trial_data(trial_data(:,2)==141,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
   elseif sum(trial_data(:,2)==136)%136 is 4kHz 20dB tone on id
        tone_id = 4000;
        tone_on = trial_data(trial_data(:,2)==136,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==140,1)];
%         tone_off = trial_data(trial_data(:,2)==141,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
        tone_vol = 20;
   elseif sum(trial_data(:,2)==137)%137 is 4kHz 40dB tone on id
        tone_id = 4000;
        tone_on = trial_data(trial_data(:,2)==137,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==140,1)];
%         tone_off = trial_data(trial_data(:,2)==141,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
        tone_vol = 40;
   elseif sum(trial_data(:,2)==138)%138 is 4kHz 60dB tone on id
        tone_id = 4000;
        tone_on = trial_data(trial_data(:,2)==138,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==140,1)];
%         tone_off = trial_data(trial_data(:,2)==141,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
        tone_vol = 60;
   elseif sum(trial_data(:,2)==139)%139 is 4kHz 80dB tone on id
        tone_id = 4000;
        tone_on = trial_data(trial_data(:,2)==139,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==140,1)];
%         tone_off = trial_data(trial_data(:,2)==141,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
        tone_vol = 80;
   elseif sum(trial_data(:,2)==140)%140 is 8kHz 20dB tone on id
        tone_id = 8000;
        tone_on = trial_data(trial_data(:,2)==140,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==140,1)];
%         tone_off = trial_data(trial_data(:,2)==141,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
        tone_vol = 20;
    elseif sum(trial_data(:,2)==141)%141 is 8kHz 40dB tone on id
        tone_id = 8000;
        tone_on = trial_data(trial_data(:,2)==141,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==140,1)];
%         tone_off = trial_data(trial_data(:,2)==141,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
        tone_vol = 40;
   elseif sum(trial_data(:,2)==142)%142 is 8kHz 60dB tone on id
        tone_id = 8000;
        tone_on = trial_data(trial_data(:,2)==142,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==140,1)];
%         tone_off = trial_data(trial_data(:,2)==141,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
        tone_vol = 60;
    elseif sum(trial_data(:,2)==143)%143 is 8kHz 80dB tone on id
        tone_id = 8000;
        tone_on = trial_data(trial_data(:,2)==143,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==140,1)];
%         tone_off = trial_data(trial_data(:,2)==141,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
        tone_vol = 80;
    elseif sum(trial_data(:,2)==144)%144 is 12kHz 20dB tone on id
        tone_id = 12000;
        tone_on = trial_data(trial_data(:,2)==144,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==140,1)];
%         tone_off = trial_data(trial_data(:,2)==141,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
        tone_vol = 20;
    elseif sum(trial_data(:,2)==145)%145 is 12kHz 40dB tone on id
        tone_id = 12000;
        tone_on = trial_data(trial_data(:,2)==145,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==140,1)];
%         tone_off = trial_data(trial_data(:,2)==141,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
        tone_vol = 40;
    elseif sum(trial_data(:,2)==146)%146 is 12kHz 60dB tone on id
        tone_id = 12000;
        tone_on = trial_data(trial_data(:,2)==146,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==140,1)];
%         tone_off = trial_data(trial_data(:,2)==141,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
        tone_vol = 60;
    elseif sum(trial_data(:,2)==147)%147 is 12kHz 80dB tone on id
        tone_id = 12000;
        tone_on = trial_data(trial_data(:,2)==147,1);
%         tone_duration = [tone_duration trial_data(trial_data(:,2)==140,1)];
%         tone_off = trial_data(trial_data(:,2)==141,1);
        tone_duration = 2000;
        tone_off = tone_on+tone_duration;
        tone_vol = 80;
   end