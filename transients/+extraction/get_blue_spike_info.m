function [spikeTimeMatrix, blueSpikeInfo] = get_blue_spike_info(blue, blue_ts, stdThresh, spkSvPath)

switch nargin
    case 2
        stdThresh = 1.5;
        [spikeTimeMatrix, blueSpikeInfo] = extraction.extract_spikes(blue, blue_ts, stdThresh, 0.5);
    case 3
        [spikeTimeMatrix, blueSpikeInfo] = extraction.extract_spikes(blue, blue_ts, stdThresh, 0.5);
    case 4
        [spikeTimeMatrix, blueSpikeInfo] = extraction.extract_spikes(blue, blue_ts, stdThresh, 0.5, true, spkSvPath);
end

end