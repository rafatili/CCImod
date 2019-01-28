close all;

map = initialize_ACE;

speechfile = fullfile('Sounds', 'Speech', 'Alcaim1_',...
    'M', 'M0001', 'M0001001.WAV');
noisefile = ...%fullfile('Sounds', 'Noise', 'ICRA_No01_16kHz_21s.wav');
    fullfile('Sounds', 'Noise', '4talker-babble_ISTS.wav');
    
SNR = -10;

sgnls = SignalY(speechfile, noisefile, SNR);
y = sgnls.Smix;
x = sgnls.target;
v = sgnls.noise;

figure;
plot([y,v,x]); legend({'y','v','x'})

%% stimulate
time = .2; % tempo de espera para evitar erro de nomeação das figuras

tech = 'EnvEst'; % 'EnvEst', 'WF', 'BM' or 'none'
[stimEnv, NREnv] = mod_stimulateGT_NR(y,x,v, map, tech, 1); 
h = gcf;
h.Name = tech;
pause(time)

tech = 'WF'; % 'EnvEst', 'WF', 'BM' or 'none'
[stimWF, NRWF] = mod_stimulateGT_NR(y,x,v, map, tech, 1); 
h = gcf;
h.Name = tech;
pause(time)

tech = 'BM'; % 'EnvEst', 'WF', 'BM' or 'none'
[stimWF, NRBM] = mod_stimulateGT_NR(y,x,v, map, tech, 1); 
h = gcf;
h.Name = tech;
pause(time)

stim2 = mod_stimulateGT(speechfile, map, 1);
h = gcf;
h.Name = 'clean';
pause(time)

[stim3, NR3] = mod_stimulateGT_NR(y,x,v, map, 'none', 1);
h = gcf;
h.Name = 'unprocessed';


%% NR eval
mNRenv = mean(mean(NREnv.left));
mNRwf = mean(mean(NRWF.left));
mNRbm = mean(mean(NRBM.left));

disp([mNRenv, mNRwf, mNRbm])
figure;
plot(NREnv.left');
title('Env - coefs')

figure;
plot(NRWF.left');
title('WF - coefs')

figure;
plot(NRBM.left');
title('BM - coefs')