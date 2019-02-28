%test if the output of the vocoder is equal for signals with different
%phases and same envelope;

clearvars;

vocoder_type = 'CI';
[signal, fs0] = wavread('S_01_01.wav');
fs = 16000;
signal = resample(signal,fs,fs0);

[vSig2] = CI_Vocoder_Cochlear_envInput(signal,fs,vocoder_type);
[vSig] = CI_Vocoder_Cochlear(signal,fs,vocoder_type);

%% Preperation and presentation of original and vocoded signal
Silence = zeros(2*fs, 1)';
Presentation = [signal' Silence vSig' Silence vSig2'];
player = audioplayer(Presentation, fs);
play(player);

%% spectrograms figure
figure;
subplot(1,3,1);
spgrambw(signal,fs,'J');
colormap('hot');
title('original');

subplot(1,3,2);
spgrambw(vSig,fs,'J');
colormap('hot');
title('original vocoder');

subplot(1,3,3);
spgrambw(vSig2,fs,'J');
colormap('hot');
title('mod vocoder');