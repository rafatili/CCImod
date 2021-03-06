function [vocoded_signal, mElectroderand] = CI_Vocoder_MEDEL(signal,fs,vocoder_type, varargin)
%% function [vocoded_signal, mElectroderand] = CI_Vocoder(signal,fs,vocoder_type, varargin)
% Simulates Cochlea Implant signal processing using pulsatile sampling of the
% signal envelope in 12 "Electrode channels". It is also possible to simulate
% electroacoustic hearing or acoustic hearing only (via low frequency bandpass).
% After simulation of cochlea implant signal processing the generated sequential
% pulse patterns across channels  is auralized.
%
% In the auralisation stage each pulse gets filtered with a narrow band filter.
% This narrow band filter  can be placed at the aproximated positions of real
% cochlear implant electrode arrays.
%
% Input parameters:
%	signal       = vector with time signal. Only one channel at a time can be
%	               vocoded.
%	fs           = sampling frequency of input signal
%	vocoder_type = Type of Vocoder: Possible choices: 'CI' for pure electric
%	               simulation, 'Acoustic' for simulation of low-frequency hearing or 'EAS'
%	               for electroacoustic simulation.
%
% Optional input parameters: 
%	All optional input parameters can be evoked with 'key'-'value' pairs. See below for the details
%
% Output parameters: 
%	vocoded_signal = vector with the vocoded signal
%	mElectroderand = (optional) outputs the used electrode randomization
%	across pulsatile sampling. This can be used to create a "syncronized"
%	electrode pattern across ears. Example usage:
% 	[vocoded_signal_left, mElectroderand] = CI_Vocoder(my_signal, 44100, % 	'CI'); %Logs electrode pattern
%	vocoded_signal_right = CI_Vocoder(my_signal, 44100, 'CI', 'use_electrode_pattern', mElectroderand);
%
% Input parser (make all parameters except the first three optional)
p = inputParser; %creates Input parser structure
p.addRequired('signal', @(x) isnumeric(x));
p.addRequired('fs', @isnumeric);
p.addRequired('vocoder_type', @ischar); % Can be 'CI', 'EAS' or 'Acoustic'

% PPS-Rate over all channels. To obtain PPS per Channel divide this number by
% number of center_frequencies_hz_stimulation
p.addParamValue('voc_sampling_frequency_hz', 55000, @isnumeric); % 55000

% Bandwidth of Filters
p.addParamValue('filters_per_ERBaud', 1, @isnumeric);

% Order of Gammatonefilterbank (stimulation and auralisation analysis filterbank)
p.addParamValue('gamma_order_stimulation', 3, @isnumeric);
p.addParamValue('gamma_order_auralisation', 3, @isnumeric);

% Lowest cutoff frequency of Gammatonefilterbank
p.addParamValue('lower_cutoff_frequency_hz', 70, @isnumeric);

% One specified center frequency
p.addParamValue('specified_center_frequency_hz',  1175, @isnumeric);

% Upper cutoff frequency of Gammatonefilterbank
p.addParamValue('upper_cutoff_frequency_hz', 8500, @isnumeric);

% Middle frequency of analysis-Filterbanks
p.addParamValue('center_frequencies_hz_stimulation', [120 235 384 579 836 1175 1624 2222 3019 4084 5507 7410], @isnumeric);

% Default pulse-lenght is 2 Samples, which equals 36 microsecs at f_sampling = 55100 Hz.
p.addParamValue('len_pulse', 2, @isnumeric); 

% Higher version with 12 Electrodes using greenwoods equation and an
% electrode insertion depth of 24 mm in a 32 mm cochlear duct (Flex24 Electrode)
p.addParamValue('center_frequencies_hz_auralisation', [390 550 759 1031 1384 1843 2440 3216 4225 5537 7243 9460], @isnumeric);

% Use existing electrode pattern
p.addParamValue('use_electrode_pattern', 0, @isnumeric); 

% Spatial spread in mm
p.addParamValue('spatial_spread', 5, @isnumeric);

% Switch for compression (0= off (default), 1 = on)
p.addParamValue('bcompress', 0, @isnumeric); 

% Exponential decay constant for spatial spread
p.addParamValue('lambda', 0.0036, @isnumeric); 

% Distance between adjunct electrodes [m] for calculation of spatial spread
p.addParamValue('distance_electrodes', 0.0028, @isnumeric); 

% Validation
p.parse(signal, fs, vocoder_type, varargin{:});
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

% Get rms value for level adation of final signal:
rms_y = sqrt(mean(abs(sig).^2,1));

% First analysis-filterbank
%1st analyse:
[y1, analyzer_stim] = Gfb_Analyzer_process(analyzer_stim,sig');

% CI simulation
% Calculate envelope after first filerbank
hue_signal_new = abs(y1);
if parameter.bcompress
    hue_signal_new = compress_instant(hue_signal_new);
end
size_y1 = size(y1,1);
len_y1 = length(y1(2,:));

% Calculate rms per analysis-channel:
rms_y_channels = sqrt(mean(abs(y1).^2,2));

% Create pulsatile pattern with correct sampling frequency and randomized sequence between electrodes
hue_pulse_prokanal_rand = zeros(size(y1));
pulse = ones(1,parameter.len_pulse); % Generate pulse
len_pulse = parameter.len_pulse;

% Step through sample by sample
n_samples = 1;
min_value = 0;

switch vocoder_type
    case 'CI'
    startkanal = 1;
    nrchans = size_y1;
    case 'EAS'
        startkanal = 4; % Using CI - pulsepattern from this channel onwards
        nrchans = size_y1-startkanal; 
    case 'Acoustic'
        startkanal = 3;
        nrchans = 4;
    otherwise
        error('This Vocoder configuration is not known');
end

if parameter.use_electrode_pattern ~= 0
	if size(parameter.use_electrode_pattern,2)~=length(parameter.center_frequencies_hz_stimulation)
		error('Matrix of electrode pattern must match length of center frequencies!');
	end
kk = 1;
while n_samples <= len_y1-1;
            rand_channel = parameter.use_electrode_pattern(kk,:);
            if nrchans < length(parameter.center_frequencies_hz_stimulation)
                rand_channel = rand_channel(rand_channel>startkanal-1); %Throw out all idx below startchannel
            end
            for n_kanaele = startkanal:nrchans;
                % Break before last sample
                if n_samples > len_y1-len_pulse;
                    break
                end
                % Pulsatile sampling if amplitude of envelope > Threshold (currently 0)
                if hue_signal_new(rand_channel(n_kanaele), n_samples) > min_value;
                    hue_pulse_prokanal_rand(rand_channel(n_kanaele),[n_samples : n_samples+len_pulse-1]) = ...
                        hue_signal_new(rand_channel(n_kanaele),[n_samples : n_samples+len_pulse-1]).*pulse; %sampling with puls
                end
                if hue_signal_new(rand_channel(n_kanaele), n_samples) > min_value && n_kanaele < nrchans
                    n_samples = n_samples+len_pulse; % Shift to next channel (sequential stimulation)
                end
                if n_samples == len_y1-1;
                    n_samples = n_samples+1;
                    break
                end
            end
            n_samples = n_samples+len_pulse; % Forwards to next pulse
            kk = kk+1;
end
else % Generate electrode pattern (randomized stimulation)
electrode_pattern = [];
kk = 1;
while n_samples <= len_y1-1;
            rand_channel = randperm(length(parameter.center_frequencies_hz_stimulation));
            if ~parameter.bcompress % compression increased the number rand_channel is generated by around 10.0000! So a dynamic growing table is not really useful
            electrode_pattern = [electrode_pattern; rand_channel];
            end
            if nrchans < length(parameter.center_frequencies_hz_stimulation)
                rand_channel = rand_channel(rand_channel>startkanal-1); %Throw out all idx below startchannel
            end
            for n_kanaele = startkanal:nrchans;
                % Break before last sample 
                if n_samples > len_y1-len_pulse;
                    break
                end
                % Pulsatile sampling if amplitude of envelope > Threshold (currently 0)
                if hue_signal_new(rand_channel(n_kanaele), n_samples) > min_value;
                    hue_pulse_prokanal_rand(rand_channel(n_kanaele),[n_samples : n_samples+len_pulse-1]) = ...
                        hue_signal_new(rand_channel(n_kanaele),[n_samples : n_samples+len_pulse-1]).*pulse; %sampling with puls
                end
                if hue_signal_new(rand_channel(n_kanaele), n_samples) > min_value && n_kanaele < nrchans
                    n_samples = n_samples+len_pulse; % Shift to next channel (sequential stimulation)
                end
                if n_samples == len_y1-1;
                    n_samples = n_samples+1;
                    break
                end
            end
            n_samples = n_samples+len_pulse; %Forwards to next pulse
            kk = kk+1;
end
end

% Now there is a pulsatile electrode pattern
zerofine = hue_pulse_prokanal_rand;

% Interaction between electrodes
zerofine = CIinteract_Ben(zerofine, parameter.spatial_spread, parameter.distance_electrodes, parameter.lambda);

% Look, if we have an acoustic path
if strcmp(vocoder_type, 'EAS') == 1
    zerofine(1:startkanal-1,:) = real(y1(1:startkanal-1,:)); %Replace envelope with real-Part of original signal
    parameter.center_frequencies_hz_auralisation(1:startkanal-1) = parameter.center_frequencies_hz_stimulation(1:startkanal-1); % First auralisation bandpass must be the same as in stimulation
end
if strcmp(vocoder_type, 'Acoustic') == 1
    % Only use the first three channels
    zerofine(1:startkanal,:) = real(y1(1:startkanal,:));
    zerofine(startkanal+1:end,:) = zeros(size(y1(startkanal+1:end,:)));
    rms_y_channels(startkanal+1:end) = 0; %Set rms to zero for all other frequency channels
    parameter.center_frequencies_hz_auralisation(1:startkanal) = parameter.center_frequencies_hz_stimulation(1:startkanal); % First auralisation bandpass must be the same as in stimulation
end

%% CI Auralisation

% Create analyse -Filterbank
analyzer_aural = Gfb_Analyzer_new(parameter.voc_sampling_frequency_hz,         ...
                                    parameter.lower_cutoff_frequency_hz,     ...
                                    parameter.specified_center_frequency_hz, ...
                                    parameter.upper_cutoff_frequency_hz,     ...
                                    parameter.filters_per_ERBaud,            ...
                                    parameter.gamma_order_auralisation, ...
                                    parameter.center_frequencies_hz_auralisation);
% Next Analyse-Filterbank (modulates puls-pattern to desired frequency region on basiliar 
% membrane)
zerofine = Gfb_Analyzer_process(analyzer_aural, zerofine);
% Scale to correct channel-rms
rms_y_channel_synthese = sqrt(mean(abs(zerofine).^2,2));
gainfaktor_channels = rms_y_channels./(rms_y_channel_synthese+eps);
zerofine = bsxfun(@times, zerofine,gainfaktor_channels);
% Signal-Synthesis:
synthesizer_aural = Gfb_Synthesizer_new (analyzer_aural, 1/100); %1/100 = Delay
synthesizer_y_aural = Gfb_Synthesizer_process(synthesizer_aural, zerofine);
% Scale to correct overall rms
rms_y_zerofine = sqrt(mean(abs(synthesizer_y_aural).^2,2));
gainfaktor_zerofine = rms_y./(rms_y_zerofine+eps);
synthesizer_y_aural = synthesizer_y_aural * gainfaktor_zerofine;
synthesizer_y_aural = resample(synthesizer_y_aural,fs,parameter.voc_sampling_frequency_hz);
val = max(abs(synthesizer_y_aural));
if val>1,
    warning('Signal clipped!');
end
vocoded_signal = synthesizer_y_aural'; %Make mono channel
% vocoded_signal = vocoded_signal(1:length(signal)); 
% Due to delay in some sampling frequencies and signal durations we get an extra sample.
% This line removes the extra sample. Normally we should just remove a zero
% sample at the end of the signal, but please check the size in order to be
% absolutely sure, that no vital portions of the signal get lost!

% Output arguments
if nargout == 2
	mElectroderand = electrode_pattern;
end
end
%EOF
