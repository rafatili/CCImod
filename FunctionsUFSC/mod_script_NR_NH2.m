%test script for the modACE function
close all; clearvars;

p = initialize_ACE;
handles.parameters = p;
speechfile = 'M0002002.WAV';%'S_01_01.wav';

noisefile = '4talker-babble_ISTS.wav';
SNRdB = 0;

%% GENERATE Y noisy, X speech AND V noise SIGNALS
% y = x + v
if (isfield(p,'Left') ==1)
    f0 = p.Left.SamplingFrequency;
end
if (isfield(p,'Right') ==1)
    f0 = p.Right.SamplingFrequency;
end
sgnls = SignalY(speechfile, noisefile, SNRdB);
y = sgnls.Smix;
x = sgnls.target;
v = sgnls.noise;

%% noise reduction
tech = 'WF';%'EnvEst'; %noise reduction technique: 'EnvEst', 'WF', 'BM','none'
%% stimulate
plotflag = 0; %plot electrodogram
vtype = 'white'; %vocoder type (white || CIsim)
stimuli = mod_stimulateGT_NR_NH(y,x,v, handles.parameters, tech, vtype, plotflag); %use gammatone filters

%% reference vocoder
vtype = 'CIsim';
[vSig] = mod_stimulateGT_NR_NH(y,x,v, handles.parameters, tech, vtype, plotflag);

%% spectrograms figure
figure;
subplot(1,2,1)
spgrambw(stimuli,f0,'J');
colormap('hot');
title('vocoded - white');

subplot(1,2,2)
spgrambw(vSig,f0,'J');
colormap('hot');
title('vocoded - CIsim');

%% Preperation and presentation of original and vocoded signal
Silence = zeros(f0, 1);
Presentation = [y; Silence; vSig; Silence; stimuli];
player = audioplayer(Presentation, f0);
play(player);
