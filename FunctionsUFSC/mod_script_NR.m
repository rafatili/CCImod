%test script for the modACE function

p = initialize_ACE;
handles.parameters = p;
speechfile = 'S_01_01.wav';
noisefile = 'ICRA_No01_16kHz_21s.wav';
SNRdB = 10;

%% GENERATE Y noisy, X speech AND V noise SIGNALS
% y = x + v
sgnls = SignalY(speechfile, noisefile, SNRdB);
y = sgnls.Smix;
x = sgnls.target;
v = sgnls.noise;

%% noise reduction
tech = 'EnvEst'; %noise reduction technique: 'EnvEst', 'WF', 'BM','none'
%% stimulate
plotflag = 1; %plot electrodogram
mod_stimulateGT_NR(y,x,v, handles.parameters, tech, plotflag); %use gammatone filters