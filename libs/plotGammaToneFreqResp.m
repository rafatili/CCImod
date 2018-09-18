function plotGammaToneFreqResp( fcoefs, fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

y = ERBFilterBank([1 zeros(1,511)], fcoefs);
resp = 20*log10(abs(fft(y')));
freqScale = (0:511)/512*fs;

figure
semilogx(freqScale(1:256),resp(1:256,:));
axis([100 10000 -40 5])
xlabel('Frequência [Hz]'); ylabel('Resposta do filtro [dB]');

end

