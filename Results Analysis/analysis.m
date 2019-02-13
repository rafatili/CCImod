clc; close all; clearvars;

olddir = pwd;
cd('Results')
filename = uigetfile();
cd(olddir)

load(filename)

snr = resultados.snr;
L = length(resultados.snr);

Ntot = resultados.numTotalPalavras;
Nok = resultados.numAcertos;
rate = Nok./Ntot;
idx = find(~isnan(rate));
rate = rate(idx);

rate = reshape(rate,length(rate)/(2*L),2*L);

WF = rate(:,1:L);
Env = rate(:, (L+1):end);

%% plot
figure('Color', 'w');
c = colormap(lines(2));

