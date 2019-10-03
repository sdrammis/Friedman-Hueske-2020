function ws = weightsBase()
% Create the baseline weights for the network.
tone_pv1 = 0.1; tone_pv2 = 0.5; tone_msn1 = 4; tone_msn2 = 4; tone_msn3 = 4;
discrm_pv1 = 1.5; discrm_pv2 = 0.5; discrm_msn1 = 3; discrm_msn2 = 3; discrm_msn3 = 3;
eng_pv1 = 0.7; eng_pv2 = 3; 
noise_pv1 = 0.05; noise_pv2 = 0.5; noise_msn1 = 3.8; noise_msn2 = 3.8; noise_msn3 = 3.8;
pv1_msn1 = 0; pv1_msn2 = 0; pv1_msn3 = 0; % Controls T1/T2 separation
pv2_msn1 = -1; pv2_msn2 = -1; pv2_msn3 = -1; % Controls the baseline
ws = [tone_pv1 tone_pv2 discrm_pv1 discrm_pv2 eng_pv1 eng_pv2 noise_pv1 noise_pv2 ...
    tone_msn1 tone_msn2 tone_msn3 discrm_msn1 discrm_msn2 discrm_msn3 noise_msn1 noise_msn2 noise_msn3 ...
    pv1_msn1 pv1_msn2 pv1_msn3 pv2_msn1 pv2_msn2 pv2_msn3];
end

