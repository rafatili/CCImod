clc; close all; clearvars;

olddir = pwd;
cd('Results')
fnames = uigetfile('*_INT.mat','MultiSelect', 'on');
cd(olddir)

%% creates figures
bpf = figure; %boxplot figure
bpf.Name = 'Data distribution';
hf = figure; %individual intelligibility performance
hf.Name = 'Total of correct words over total of words';

if iscell(fnames)
    Lfiles = length(fnames);
else
    Lfiles = 1;
    fnames = {fnames};
end

maxcols = 3; %max. number of subplot columns
if Lfiles<maxcols;
    spCs = Lfiles;  %number of subplot columns
    spRs = 1;       %number of subplot rows
else
    spCs = maxcols;
    spRs = ceil(Lfiles/maxcols);
end

aWF = zeros(Lfiles,5); %considering 5 snr values
aEnv = zeros(Lfiles,5);

for ii = 1:Lfiles;

    filename = fnames{ii};
    %
    load(filename)
    
    if isfield(resultados,'snr')
        snr = resultados.snr;
    else
        snr = -15:-5:-35; %on the first simulation this info was not saved
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
    
    %% boxplot
    %reorganize the rate matrix
    [row,col] = size(rate);
    rate2 = zeros(row,col+L);
    dummycol = nan*ones(row,1);
    
    labelo = cell(1,col+L);
    labelo(1,:) = {''};
    
    X1 = [0 1 2];
    Xpos = zeros(1,3*L);
    for jj = 0:L-1;
        rate2(:,jj*3+1) = WF(:,L-jj);
        rate2(:,jj*3+2) = dummycol;
        rate2(:,jj*3+3) = Env(:,L-jj);
        
        labelo(1,jj*3+2) = {strcat(num2str(snr(L-jj)),'')};
        Xpos(jj*3+(1:3)) = X1 + jj*10;
    end
    
    %boxplot
    figure(bpf)
    subplot(spRs,spCs,ii)
    
    c0 = colormap(lines(2));
    c = [c0(1,:); ones(1,3); c0(2,:)];
    C = repmat(c,L,1);  % this is the trick for coloring the boxes
    % regular plot
    boxplot(rate2*100, 'positions', Xpos, 'colors', C, 'plotstyle', 'compact', ...
        'labels', labelo, 'LabelOrientation','horizontal'); % label only two categories
    
    ax = gca;
    ax.XLim = ax.XLim + [-1,+1]*5;
    ttl = sprintf('S%d',ii); %('%s', filename(1:end-8));
    title(ttl)
    
    hold on;
    for jj = 1:2
        plot(NaN,1,'color', c0(jj,:), 'LineWidth', 4);
    end
    
    ylabel('Correct words(%)');
    xlabel('SNR [dB]');
    
    legend({'WF', 'EnvEst.'},'Location','northwest');
    ylim([-10,110])
    
    %% intelligibility graph 2
    AOK = sum(Nok); %Soma de todas as palavras corretas por SNR
    Atot = sum(Ntot); %Soma de todas as palavras por SNR
    
    aWF(ii,:) = AOK(1:L)./Atot(1:L);
    aEnv(ii,:) = AOK(L+1:end)./Atot(L+1:end);
    
    figure(hf)
    subplot(spRs,spCs,ii)
    plot(snr,100*aWF(ii,:),'o-');
    hold on
    plot(snr,100*aEnv(ii,:),'o-');
    
    ylabel('Correct words(%)');
    xlabel('SNR [dB]');
    legend({'WF', 'EnvEst.'},'Location','northwest');
    ttl = sprintf('S%d',ii); %('%s', filename(1:end-8));
    title(ttl)
    ylim([-10,110])
end

%% plots for all subjects together
if Lfiles > 1
    %% plot 1
    bp2 = figure; %figure for boxplot2
    %reorganize the rate matrix
    [row,col] = size(aWF);
    rate2 = zeros(row,col+L);
    dummycol = nan*ones(row,1);
    
    X1 = [0 1 2];
    Xpos = zeros(1,3*L);
    for jj = 0:L-1;
        rate2(:,jj*3+1) = aWF(:,L-jj);
        rate2(:,jj*3+2) = dummycol;
        rate2(:,jj*3+3) = aEnv(:,L-jj);
        
        Xpos(jj*3+(1:3)) = X1 + jj*10;
    end
    
    %boxplot
    figure(bp2)
    
    c0 = colormap(lines(2));
    c = [c0(1,:); ones(1,3); c0(2,:)];
    C = repmat(c,L,1);  % this is the trick for coloring the boxes
    % regular plot
    boxplot(rate2*100, 'positions', Xpos, 'colors', C, 'plotstyle', 'compact', ...
        'labels', labelo, 'LabelOrientation','horizontal'); % label only two categories
    
    ax = gca;
    ax.XLim = ax.XLim + [-1,+1]*5;
    ttl = 'All subjects';
    title(ttl)
    
    hold on;
    for jj = 1:2
        plot(NaN,1,'color', c0(jj,:), 'LineWidth', 4);
    end
    
    ylabel('Correct words(%)');
    xlabel('SNR [dB]');
    
    legend({'WF', 'EnvEst.'},'Location','northwest');
    ylim([-10,110])
    
    %% plot 2
    bp3 = figure; %figure for boxplot2
    %reorganize the rate matrix
    [row,col] = size(aWF);
    
    delta = aEnv - aWF;
    delta = fliplr(delta);
    %boxplot
    figure(bp3)
   
    % regular plot
    boxplot(delta*100, 'plotstyle', 'compact', ...
        'labels', fliplr(snr), 'LabelOrientation','horizontal'); % label only two categories
    
    ttl = 'All subjects';
    title(ttl)
    
    ylabel('$\Delta$ Correct words [\%] (Env - WF))', 'interpreter', 'Latex');
    xlabel('SNR [dB]');
    
    ylim([-10,110])
end
%% quality test

% there are 3 combinations for this test, 20 sentences for each
Qs = zeros(20,Lfiles,3); % comb 1

for ii = 1:Lfiles
    aux = fnames{ii};
    filename = sprintf('%s_QLT.mat', aux(1:end-8));
    
    if exist(filename, 'file')
        load(filename)
    
        SNRqlt = -10; %dB
        
        Qs(:,ii,1) = Qresultados.resultados(:,1);
        Qs(:,ii,2) = Qresultados.resultados(:,2);
        Qs(:,ii,3) = Qresultados.resultados(:,3);
    else
        Qs(:,ii,1) = NaN*ones(20,1);
        Qs(:,ii,2) = NaN*ones(20,1);
        Qs(:,ii,3) = NaN*ones(20,1);
    end
end

qf(1) = figure;
qf(2) = figure;
qf(3) = figure;

for ii = 1:3
    M = Qs(:,:,ii);
    nancols = all( isnan( M ), 1 );
    M( :, nancols) = []; %excludes participants that did not take the quality test
    subjectidx = 1:Lfiles;
    subjectidx(nancols) = [];
    
    figure(qf(ii))
    subplot(1,2,1)
    [~, Mfiles] = size(M);
    
    data = M(1:10,:);
    data = [data(:);data(:)];
    
    grp = zeros(2*10*Mfiles,1);
    labels = cell(Mfiles+1,1);
    for jj = 1:Mfiles
        grp((jj-1)*10+1:(jj-1)*10+10) = (jj-1)*ones(10,1);
        labels{jj} = sprintf('S%d', subjectidx(jj));
    end
    grp(10*Mfiles+1:end) = Mfiles;
    labels{end} = 'All';
    
    boxplot(data, grp, 'plotstyle', 'compact','labels', labels,'LabelOrientation','horizontal'); % label only two categories
    title(sprintf('%s with respect to %s', Qresultados.comb{ii,2}, Qresultados.comb{ii,1}))
    
    xlabel('Subjects')
    ylabel('Quality evaluation')
    ylim([-5,+5])
    
    %% test repetition data
    figure(qf(ii))
    subplot(1,2,2)
    data = M(11:end,:);
    data = [data(:);data(:)];
    
    grp = zeros(2*10*Mfiles,1);
    labels = cell(Mfiles+1,1);
    for jj = 1:Mfiles
        grp((jj-1)*10+1:(jj-1)*10+10) = (jj-1)*ones(10,1);
        labels{jj} = sprintf('S%d', subjectidx(jj));
    end
    grp(10*Mfiles+1:end) = Mfiles;
    labels{end} = 'All';
    
    boxplot(data, grp, 'plotstyle', 'compact','labels', labels,'LabelOrientation','horizontal'); % label only two categories
    title(sprintf('%s with respect to %s', Qresultados.comb{ii,2}, Qresultados.comb{ii,1}))
    
    xlabel('Subjects')
    ylabel('Quality evaluation')
    ylim([-5,+5])
end