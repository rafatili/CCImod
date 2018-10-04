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
if isequal(map_filename,0)
    disp('No valid file selected, so file S_01_01.wav is loaded ')
    speechfile = 'S_01_01.wav';
else
    disp(['Speech file loaded is: ', fullfile(map_pathname, map_filename)])
    speechfile = speech_filename;
end

cd(olddir) %
%%
noisefile = 'ICRA_No01_16kHz_21s.wav';
SNRdB = -10;

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