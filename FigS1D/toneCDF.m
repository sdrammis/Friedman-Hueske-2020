function [tone_cdf,tone_licks] = toneCDF(trialData,tone,engaged)
%Returns CDF for amount of licks in response period for tone (where index is number of licks)

%Amount of Licks in trials per Tone
tone_licks = data_per_tone(trialData,tone,engaged,'ResponseLickFrequency'); %Amount of Licks in the Response Period for Tone 1
%Probability Density Functions of response licks for Tone (not counting 0 licks)

[tone_pdf, tone_licks] = tonePDF(tone_licks,7);

%Cumulative Density Function of response licks for Tone (not counting 0 licks)
tone_cdf = cumsum(tone_pdf);

% If no licks in response at all with tone, then by 1 lick CDF is 1
if isempty(tone_cdf)
    tone_cdf = 1;
end