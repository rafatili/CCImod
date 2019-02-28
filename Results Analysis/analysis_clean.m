%analysis clean speech

clc; close all; clearvars;

olddir = pwd;
cd(fullfile('Results','CleanSpeech'));
fnames = uigetfile('*_INT_Clean.mat','MultiSelect', 'on');
cd(olddir)

if iscell(fnames)
    Lfiles = length(fnames);
else
    Lfiles = 1;
    fnames = {fnames};
end

aClean = zeros(Lfiles,1); %considering 1 snr value = Inf

for ii = 1:Lfiles;

    filename = fnames{ii};
    %
    load(filename)
    
    if isfield(resultados,'snr')
        snr = resultados.snr;
    else
        snr = Inf; %on the first simulation this info was not saved
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
       
    %% intelligibility graph 2
    AOK = sum(Nok); %Soma de todas as palavras corretas por SNR
    Atot = sum(Ntot); %Soma de todas as palavras por SNR
    
    aClean(ii,:) = AOK(1:L)./Atot(1:L);
end

if Lfiles > 1
    %% plot 1
    bp2 = figure; %figure for boxplot2
    %reorganize the rate matrix
    
    %boxplot
    figure(bp2)   
    % regular plot
    boxplot(aClean*100, 'plotstyle', 'compact','labels', 'Clean Speech','LabelOrientation','horizontal'); % label only two categories
    
    ax = gca;
    ax.XLim = ax.XLim + [-1,+1]*5;
    ttl = 'All subjects - Clean speech Intelligibility';
    title(ttl)
    
    ylim([-10,110])

end