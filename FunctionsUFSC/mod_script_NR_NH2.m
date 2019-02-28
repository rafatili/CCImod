%test script for the modACE function
close all; clearvars;clc;

p = initialize_ACE;
handles.parameters = p;
speechfile = 'Lista2B_frase1.wav';%'S_01_01.wav';

noisefile = '4talker-babble_ISTS.wav'; %'ICRA_No01_16kHz_21s.wav'; 
SNRdB = -20;

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
%% vocoder WF
plotflag = 0; %plot electrodogram
vtype = 'CIsim'; %vocoder type (white || CIsim)
vWF = mod_stimulateGT_NR_NH(y,x,v, handles.parameters, tech, vtype, plotflag); %use gammatone filters

%% vocoder EnvEst
tech = 'EnvEst';
[vEnv] = mod_stimulateGT_NR_NH(y,x,v, handles.parameters, tech, vtype, plotflag);

%% vocoder clean speech
tech = 'none';
[vCl] = mod_stimulateGT_NR_NH(x,x,zeros(size(x)), handles.parameters, tech, vtype, plotflag);

%% spectrograms figure
figure;
subplot(1,3,1)
spgrambw(vCl,f0,'J');
colormap('hot');
title('vocoded - Clean');

subplot(1,3,2)
spgrambw(vWF,f0,'J');
colormap('hot');
title('vocoded - WF');

subplot(1,3,3)
spgrambw(vEnv,f0,'J');
colormap('hot');
title('vocoded - Env');

%% Preperation and presentation of original and vocoded signal
Silence = zeros(f0, 1);
Presentation = [vCl; Silence; vWF; Silence; vEnv];
player = audioplayer(Presentation, f0);
play(player);
