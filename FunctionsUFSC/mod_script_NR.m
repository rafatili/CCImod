%test script for the modACE function

p = initialize_ACE;
handles.parameters = p;
speechfile = 'S_01_01.wav';
noisefile = 'ICRA_No01_16kHz_21s.wav';
SNRdB = 0;
%azimuth = 90; %azimuth angle in degrees

%% GENERATE Y noisy, X speech AND V noise SIGNALS
% y = x + v
sgnls = SignalY(speechfile, noisefile, SNRdB);
y = sgnls.Smix;
x = sgnls.target;
v = sgnls.noise;

%% stimulate
plotflag = 1; %plot electrodogram
mod_stimulateGT_NR(y,x,v, handles.parameters, plotflag); %use gammatone filters