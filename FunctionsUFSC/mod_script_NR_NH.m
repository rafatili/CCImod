%test script for the modACE function

p = initialize_ACE;
handles.parameters = p;
%speechfile = 'S_01_01.wav';
%% choose speech file
olddir = pwd; %
fpath = mfilename('fullpath'); % full path of the current function file
[pathstr] = fileparts(fpath); % directory of the current function file

[pathstr] = fileparts(pathstr); % root directory CCIMod

cd(fullfile(pathstr,'Sounds'))
[speech_filename, speech_pathname] = uigetfile('*.wav', 'Select a speech file');
if isequal(speech_filename,0)
    disp('No valid file selected, so file S_01_01.wav is loaded ')
    speechfile = 'S_01_01.wav';
else
    disp(['Speech file loaded is: ', fullfile(speech_pathname, speech_filename)])
    speechfile = speech_filename;
end

cd(olddir) %
%%
noisefile = 'ICRA_No01_16kHz_21s.wav';
SNRdB = Inf;

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
tech = 'none'; %noise reduction technique: 'EnvEst', 'WF', 'BM','none'
%% stimulate
plotflag = 1; %plot electrodogram
stimuli = mod_stimulateGT_NR_NH(y,x,v, handles.parameters, tech, plotflag); %use gammatone filters

%% reference vocoder
[vSig] = CI_Vocoder_Cochlear(y,f0,'CI');

%% spectrograms figure
figure;
subplot(1,2,1)
spgrambw(stimuli,f0,'J');
colormap('hot');
title('vocoded_mod');

subplot(1,2,2)
spgrambw(vSig,f0,'J');
colormap('hot');
title('vocoded_original');

%% Preperation and presentation of original and vocoded signal
Silence = zeros(f0, 1);
Presentation = [y; Silence; vSig; Silence; stimuli];
player = audioplayer(Presentation, f0);
play(player);
