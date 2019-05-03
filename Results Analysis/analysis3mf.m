% analyse male and female voiced lists separetely

clc; close all; clearvars;

olddir = pwd;
cd('Results')
[fnames, pathname] = uigetfile('*_INT.mat','MultiSelect', 'on');
fnames = strcat(pathname,fnames);
cd(olddir)

%% creates figures
bpf = figure; %boxplot figure
bpf.Name = 'Data distribution';
hf = figure; %individual intelligibility performance
hf.Name = 'Total of correct words over total of words';
hf9 = figure; %individual intelligibility performance
hf9.Name = 'Total of correct words over total of words male/female lists';

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

aWFfem = zeros(Lfiles,5); %considering 5 snr values; correct word rate for female voiced list with WF
aEnvfem = zeros(Lfiles,5); % correct word rate for female voiced list with EnvEst
aWFmale = zeros(Lfiles,5); % correct word rate for male voiced list with WF
aEnvmale = zeros(Lfiles,5); % correct word rate for male voiced list with EnvEst

aWF = zeros(Lfiles,5); % correct word rate for all lists with WF
aEnv = zeros(Lfiles,5);% correct word rate for all lists with EnvEst

for ii = 1:Lfiles;

    filename = fnames{ii};
    %
    load(filename)
    aux=fileparts(filename);
    nhci = aux(end-1:end); %
    
    if isfield(resultados,'snr')
        snr = resultados.snr;
    else
        snr = -5:-5:-25; %on the first simulation this info was not saved
    end
    
    %% rearranges values from old experiments
    if ~isempty(find(snr == -30,1)) %check if data is from early acquisitions
        [pathstr,name,ext] = fileparts(filename);
        aux = load(fullfile(pathstr,strcat(name,'2',ext)));
        resultados.numTotalPalavras = [aux.resultados.numTotalPalavras(:,1:2), ...
            resultados.numTotalPalavras(:,1:3), ...
            aux.resultados.numTotalPalavras(:,3:4), ...
            resultados.numTotalPalavras(:,6:8)];
        resultados.numAcertos = [aux.resultados.numAcertos(:,1:2), ...
            resultados.numAcertos(:,1:3), ...
            aux.resultados.numAcertos(:,3:4), ...
            resultados.numAcertos(:,6:8)];  
        snr = -5:-5:-25;
    end
    
    %%
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
    AOKfem = sum(Nok(1:10,:)); %Soma de todas as palavras corretas por SNR (F)    
    Atotfem = sum(Ntot(1:10,:)); %Soma de todas as palavras por SNR (F)
    AOKmale = sum(Nok(11:20,:)); %Soma de todas as palavras corretas por SNR (M)
    Atotmale = sum(Ntot(11:20,:)); %Soma de todas as palavras por SNR (M)
    
    %intel rate per list
    aWFfem(ii,:) = AOKfem(1:L)./Atotfem(1:L);
    aEnvfem(ii,:) = AOKfem(L+1:end)./Atotfem(L+1:end);
    aWFmale(ii,:) = AOKmale(1:L)./Atotmale(1:L);
    aEnvmale(ii,:) = AOKmale(L+1:end)./Atotmale(L+1:end);
    
    %total intel rate 2 lists
    aWF(ii,:) = (AOKfem(1:L)+AOKmale(1:L))./(Atotfem(1:L)+Atotmale(1:L));
    aEnv(ii,:) = (AOKfem(L+1:end)+AOKmale(L+1:end))./(Atotfem(L+1:end)+Atotmale(L+1:end));
    
    figure(hf)
    subplot(spRs,spCs,ii)
    plot(snr,100*aWF(ii,:),'o-');
    hold on
    plot(snr,100*aEnv(ii,:),'d-');
    
    ylabel('Correct words(%)');
    xlabel('SNR [dB]');
    legend({'WF', 'EnvEst.'},'Location','northwest');
    ttl = sprintf('S%d',ii); %('%s', filename(1:end-8));
    title(ttl)
    ylim([-10,110])
    
    figure(hf9)
    subplot(spRs,spCs,ii)
    plot(snr,100*aWFfem(ii,:),'o-','color', c0(1,:));
    hold on
    plot(snr,100*aWFmale(ii,:),'d--','color', c0(1,:));
    hold on
    plot(snr,100*aEnvfem(ii,:),'o-','color', c0(2,:));
    hold on
    plot(snr,100*aEnvmale(ii,:),'d--','color', c0(2,:));
    
    ylabel('Correct words(%)');
    xlabel('SNR [dB]');
    legend({'WF female', 'WF male', 'EnvEst. female', 'EnvEst. male'},'Location','northwest');
    ttl = sprintf('S%d',ii); %('%s', filename(1:end-8));
    title(ttl)
    ylim([-10,110])
end

%% plots for all subjects together
if Lfiles > 1
    %% plot 1
    bp2 = figure; %figure for boxplot2
    %reorganize the rate matrix
    [row,col] = size(aWFfem);
    rate2 = zeros(2*row,col+L);
    dummycol = nan*ones(2*row,1);
    
    X1 = [0 1 2];
    Xpos = zeros(1,3*L);
    for jj = 0:L-1;
        rate2(:,jj*3+1) = [aWFfem(:,L-jj); aWFmale(:,L-jj)];
        rate2(:,jj*3+2) = dummycol;
        rate2(:,jj*3+3) = [aEnvfem(:,L-jj);aEnvmale(:,L-jj)];
        
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
    
    legend({'WF', 'EnvEst.'},'Location','southeast');
    ylim([-10,110])
    
    %% test if ditributions are different (Wilcoxon test) @ each SNR
    ptest = zeros(1,col); %result of the test (Wilcoxon)
%    p2test = zeros(1,col); %result of the test (T-test)
    
    for jj = 1:col;
        [p,h] = ranksum(rate2(:,(jj-1)*3+1),rate2(:,(jj-1)*3+3));
 %       [h2,p2] = ttest(rate2(:,(jj-1)*3+1),rate2(:,(jj-1)*3+3));
        if h == 0;            
            xx = Xpos((jj-1)*3+2);
            plot(xx,100, 'k+', 'LineWidth', 2)
            hold on
        end
%         if h2 == 0;            
%             xx = Xpos((jj-1)*3+2);
%             plot(xx,102, 'kd', 'LineWidth', 2)
%             hold on
%         end
        ptest(jj) = p;
 %       p2test(jj) = p2;
    end
    
%     %% plot 2
%     bp3 = figure; %figure for boxplot2
%     %reorganize the rate matrix
%     medR = median(rate2)*100;
%     minR = min(rate2)*100;
%     maxR = max(rate2)*100;
%       
%     xWF = Xpos(1:3:end);
%     xEE = Xpos(3:3:end);
%     
%     figure(bp3)
%     plot(xWF, rate2(:,1:3:end),'o','color',c0(1,:));
%     hold on;
%     plot(xEE, rate2(:,3:3:end),'d','color',c0(2,:));
%     
%     ttl = 'All subjects';
%     title(ttl)
%     
%     ylabel('Correct words [\%] (Env - WF))', 'interpreter', 'Latex');
%     xlabel('SNR [dB]');
%     
%     ylim([-10,110])
end
%% quality test

% there are 3 combinations for this test, 20 sentences for each
Qs = zeros(20,Lfiles,3); % comb 1

for ii = 1:Lfiles
    aux = fnames{ii};
    filename = sprintf('%s_QLT.mat', aux(1:end-8));
    
    if exist(filename, 'file')
        load(filename)
        aux = fileparts(filename);
        nhci = aux(end-1:end);
        
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

qf = figure;
qf2 = figure;

pCorr = zeros(Lfiles,Lfiles,3);
for ii = 1:3
    M = Qs(:,:,ii);
    nancols = all( isnan( M ), 1 );
    M( :, nancols) = []; %excludes participants that did not take the quality test
    subjectidx = 1:Lfiles;
    subjectidx(nancols) = [];
    
    figure(qf)
    subplot(2,3,ii)
    [~, Mfiles] = size(M);
    
    data01 = M(1:10,:);
    data1 = [data01(:);data01(:)];
    
    grp = zeros(2*10*Mfiles,1);
    labels = cell(Mfiles+1,1);
    for jj = 1:Mfiles
        grp((jj-1)*10+1:(jj-1)*10+10) = (jj-1)*ones(10,1);
        labels{jj} = sprintf('%s%d', nhci, subjectidx(jj));
    end
    grp(10*Mfiles+1:end) = Mfiles;
    labels{end} = 'All';
    
    boxplot(data1, grp, 'plotstyle', 'compact','labels', labels,'LabelOrientation','horizontal'); % label only two categories
    title(sprintf('%s with respect to %s', Qresultados.comb{ii,2}, Qresultados.comb{ii,1}))
    
    xlabel('Subjects')
    ylabel('Quality evaluation')
    ylim([-5,+5])
    
    %% test repetition data
    figure(qf)
    subplot(2,3,3+ii)
    data02 = M(11:end,:);
    data2 = [data02(:);data02(:)];
    
    grp = zeros(2*10*Mfiles,1);
    labels = cell(Mfiles+1,1);
    for jj = 1:Mfiles
        grp((jj-1)*10+1:(jj-1)*10+10) = (jj-1)*ones(10,1);
        labels{jj} = sprintf('%s%d', nhci, subjectidx(jj));
    end
    grp(10*Mfiles+1:end) = Mfiles;
    labels{end} = 'All';
    
    boxplot(data2, grp, 'plotstyle', 'compact','labels', labels,'LabelOrientation','horizontal'); % label only two categories
    %title(sprintf('%s with respect to %s', Qresultados.comb{ii,2}, Qresultados.comb{ii,1}))
    
    xlabel('Subjects')
    ylabel('Quality evaluation')
    ylim([-5,+5])
    
    %% agreement analysis
    pCorr = corr(data01,data02);
    agree = calcAgreement(data01,data02)';
    rpc = zeros(Lfiles,1);
    pWilcox = zeros(Lfiles,1);
    hWilcox = zeros(Lfiles,1);
    for jj=1:Lfiles
        if isequal(data01(:,jj),data02(:,jj))
            data02(:,jj) = data02(:,jj)+eps*randn(size(data02(:,jj)));    %introduz mínima diferença para evitar erro da função BlandAltman
        end
        [rpc(jj), f] = BlandAltman(data01(:,jj),data02(:,jj),'baStatsMode','non-parametric'); 
        close(f);
        [pWilcox(jj), hWilcox(jj)] = ranksum(data01(:,jj),data02(:,jj));
    end
    subject = (1:Lfiles)';
    pearson = diag(pCorr);
    fprintf(1,'%s with respect to %s\n', Qresultados.comb{ii,2}, Qresultados.comb{ii,1});
    disp(table(subject,pearson,agree,rpc,pWilcox,hWilcox))
    %disp(table(subject,rpc,pWilcox))
    %% plot test+retest
    figure(qf2)
    subplot(1,3,ii)
    [rows, Mfiles] = size(M);
    
    data = [M(:);M(:)];
    
    grp = zeros(2*20*Mfiles,1);
    labels = cell(Mfiles+1,1);
    for jj = 1:Mfiles
        grp((jj-1)*rows+1:(jj)*rows) = (jj-1)*ones(rows,1);
        labels{jj} = sprintf('%s%d', nhci, subjectidx(jj));
    end
    grp(rows*Mfiles+1:end) = Mfiles;
    labels{end} = 'All';
    
    boxplot(data, grp, 'plotstyle', 'compact','labels', labels,'LabelOrientation','horizontal'); % label only two categories
    title(sprintf('%s with respect to %s', Qresultados.comb{ii,2}, Qresultados.comb{ii,1}))
    
    xlabel('Subjects')
    ylabel('Quality evaluation')
    ylim([-5,+5])
end