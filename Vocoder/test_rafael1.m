%test if the output of the vocoder is equal for signals with different
%phases and same envelope;

clearvars;

vocoder_type = 'CI';
[signal, fs0] = wavread('S_01_01.wav');
fs = 16000;
signal = resample(signal,fs,fs0);

% Input parser (make all parameters except the first three optional)
p = inputParser; %creates Input parser structure
p.addRequired('signal', @(x) isnumeric(x));
p.addRequired('fs', @isnumeric);
p.addRequired('vocoder_type', @ischar); % Can be 'CI', 'EAS' or 'Acoustic'

% PPS-Rate over all channels. To obtain PPS per Channel divide this number by
% number of center_frequencies_hz_stimulation
p.addParamValue('voc_sampling_frequency_hz', 22000, @isnumeric); % 55000

% Bandwidth of Filters
p.addParamValue('filters_per_ERBaud', 1, @isnumeric);

% Order of Gammatonefilterbank (stimulation and auralisation analysis % filterbank)
p.addParamValue('gamma_order_stimulation', 3, @isnumeric);
p.addParamValue('gamma_order_auralisation', 3, @isnumeric);

% Lowest cutoff frequency of Gammatonefilterbank
p.addParamValue('lower_cutoff_frequency_hz', 150, @isnumeric);

% One specified center frequency
p.addParamValue('specified_center_frequency_hz',  1938, @isnumeric);

% Upper cutoff frequency of Gammatonefilterbank
p.addParamValue('upper_cutoff_frequency_hz', 8000, @isnumeric);

% Middle frequency of analysis-Filterbanks
p.addParamValue('center_frequencies_hz_stimulation', [250 375 500 625 750 875 1000 1125 1250 1438 1688 1938 2188 2500 2875 3313 3813 4375 5000 5688 6500 7438], @isnumeric);

% Default pulse-lenght is 2 Samples, which equals 36 microsec at f_sampling = 55100 Hz.
p.addParamValue('len_pulse', 2, @isnumeric); 

% Higher version with 12 Electrodes using greenwoods equation and Cochlear Nucleus Greendwood mapping with 22 active elctrodes
p.addParamValue('center_frequencies_hz_auralisation', [664 775 902 1046 1210 1396 1608 1849 2123 2435 2789 3192 3651 4173 4766 5441 6208 7081 8074 9204 10488 11950], @isnumeric);

% Use existing electrode pattern
p.addParamValue('use_electrode_pattern', 0, @isnumeric); 

% Spatial Spread in mm
p.addParamValue('spatial_spread', 3, @isnumeric);

% Switch for compression (0= off (default), 1 = on)
p.addParamValue('bcompress', 0, @isnumeric); 

% exponential decay constant for spatial spread
p.addParamValue('lambda', 0.009, @isnumeric); 

%Distance between adjunct electrodes [m] for calculation of spatial spread
p.addParamValue('distance_electrodes', 0.0007, @isnumeric); 

% Validation
p.parse(signal, fs, vocoder_type);
parameter = p.Results;

%% Create Electric stimulation pattern
% Create analyse -Filterbank
analyzer_stim = Gfb_Analyzer_new(parameter.voc_sampling_frequency_hz,         ...
                                    parameter.lower_cutoff_frequency_hz,     ...
                                    parameter.specified_center_frequency_hz, ...
                                    parameter.upper_cutoff_frequency_hz,     ...
                                    parameter.filters_per_ERBaud,            ...
                                    parameter.gamma_order_stimulation, ...
                                    parameter.center_frequencies_hz_stimulation);

% Resampling to pps-frequency
if fs ~= parameter.voc_sampling_frequency_hz;  sig = resample(signal,parameter.voc_sampling_frequency_hz,fs);  end

% Get rms value for level adaption of final signal:
rms_y = sqrt(mean(abs(sig).^2,1));

% First analysis-filterbank
[y1, analyzer_stim] = Gfb_Analyzer_process(analyzer_stim,sig');

%% CI simulation
% Calculate envelope after first filerbank
hue_signal_new = abs(y1);
plot(hue_signal_new')

%% signal resynthesis
car_sel = 'hilbert'; % type of carrier
switch car_sel
    case 'white'
        %% white noise carriers
        L = length(y1);
        noise = wgn(L,1,0);
        carriers = real(Gfb_Analyzer_process(analyzer_stim,noise'));
        varN = var(carriers,0,2);
        for ii = 1:length(varN)
            carriers(ii,:) = carriers(ii,:)/sqrt(varN(ii));
        end
    case 'hilbert'
        %% signal's original phase as carriers
        thetas = angle(y1);
        carriers = cos(thetas);
end

%% reconstituted signal
xout = sum(hue_signal_new.*carriers)';
xout = resample(xout, fs, parameter.voc_sampling_frequency_hz);

xout = xout*sum(signal.^2)/sum(xout.^2);
%% test
[vSig] = CI_Vocoder_Cochlear(signal,fs,vocoder_type);
[vX] = CI_Vocoder_Cochlear(xout,fs,vocoder_type);

plot(vSig); hold on; plot(vX); %plot(signal)

% Preperation and presentation of original and vocoded signal
Silence = zeros(2*fs, 1)';
Presentation = [signal' Silence vSig' Silence vX'];
player = audioplayer(Presentation, fs);
%play(player);
