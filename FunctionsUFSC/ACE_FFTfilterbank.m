%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACE_Process - partials
% derived from ACE_Process function (UTD)

% Rafael Chiea Set '18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ v ] = ACE_FFTfilterbank( x, p )
%ACE_FFTfilterbank 
%INPUT x: pre-emphasized audio
%      p: modified MAP from pre-emphasis function
%OUTPUT v:time-frequency decomposed signal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FFT_filterbank_proc: Quadrature FIR filterbank implemented with FFT.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = buffer(x, p.block_size, p.block_size - p.block_shift, []);
v = u .* repmat(p.window, 1, size(u,2));	% Apply window
u = fft(v);									% Perform FFT to give Frequency-Time Matrix
u(p.num_bins+1:end,:) = [];					% Discard the symmetric bins.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Power_sum_envelope_proc: Power-sum envelopes for FFT filterbank.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v = u .* conj(u);						% Power (magnitude squared) of each bin.
u = p.weights * v;						% Weighted sum of bin powers.
u = sqrt(u);							% Magnitude.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Gain_proc: Apply gain in dB for each channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v = u .* repmat(p.gains, 1, size(u,2));



end

