clc; close all; clearvars;

olddir = pwd;
cd('Results')
filename = uigetfile();
cd(olddir)

load(filename)

if isfield(resultados,'snr')
    snr = resultados.snr;
else
    snr = -15:-5:-35;
end

L = length(snr);

Ntot = resultados.numTotalPalavras;
Nok = resultados.numAcertos;
rate = Nok./Ntot;
idx = find(~isnan(rate));

rate = rate(idx);
rate = reshape(rate,length(rate)/(2*L),2*L);
Nok = Nok(idx);
Nok = reshape(Nok,length(Nok)/(2*L),2*L);
Ntot = Ntot(idx);
Ntot = reshape(Ntot,length(Ntot)/(2*L),2*L);

WF = rate(:,1:L);
Env = rate(:, (L+1):end);

%% plot2
%reorganize the rate matrix
[row,col] = size(rate); 
rate2 = zeros(row,col+L);
dummycol = nan*ones(row,1);

labelo = cell(1,col+L);
labelo(1,:) = {''};

X1 = [0 1 2];
Xpos = zeros(1,3*L);
for ii = 0:L-1;
    rate2(:,ii*3+1) = WF(:,ii+1);
    rate2(:,ii*3+2) = dummycol;
    rate2(:,ii*3+3) = Env(:,ii+1);
    
    labelo(1,ii*3+2) = {strcat(num2str(snr(ii+1)),'')}; 
    Xpos(ii*3+(1:3)) = X1 + ii*10;
end

%boxplot
hf = figure('Color', 'w');
c0 = colormap(lines(2));
c = [c0(1,:); ones(1,3); c0(2,:)];
C = repmat(c,L,1);  % this is the trick for coloring the boxes
% regular plot
bp = boxplot(rate2*100, 'positions', Xpos, 'colors', C, 'plotstyle', 'compact', ...
    'labels', labelo, 'LabelOrientation','horizontal'); % label only two categories

ax = gca;
ax.XLim = ax.XLim + [-1,+1]*5; 
title('Dispersion')

hold on;
for ii = 1:2
    plot(NaN,1,'color', c0(ii,:), 'LineWidth', 4);
end

ylabel('Correct works(%)');
xlabel('SNR [dB]');

legend({'WF', 'EnvEst.'});

%% análise 2
AOK = sum(Nok); %Soma de todas as palavras corretas por SNR
Atot = sum(Ntot); %Soma de todas as palavras por SNR

aWF = AOK(1:L)./Atot(1:L);
aEnv = AOK(L+1:end)./Atot(L+1:end);

h = figure;
plot(snr,100*aWF,'o-');
hold on
plot(snr,100*aEnv,'o-');

ylabel('Correct words(%)');
xlabel('SNR [dB]');
legend({'WF', 'EnvEst.'});
title('Total of correct words over total of words')