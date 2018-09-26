%test script for the modACE function

p = initialize_ACE;
handles.parameters = p;
speechfile = 'S_01_01.wav';
noisefile = 'icra.wav';
SNRdB = 10;
%azimuth = 90; %azimuth angle in degrees

%% FUNCTION TO GENERATE Y noisy, X speech AND V noise SIGNALS

plotflag = 1; %plot electrodogram
mod_stimulateGT_NR(y,x,v, handles.parameters, plotflag); %use gammatone filters