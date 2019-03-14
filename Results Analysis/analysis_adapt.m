close all; clearvars; clc;

load('/home/rafael/CCImod/Results/old/Marina Brum_INT.mat');
Ntot = resultados.numTotalPalavras;
Nok = resultados.numAcertos;
rate = Nok./Ntot;
snr = resultados.snr_vecValues;
snr = snr(1:end-1,:);

UP = rate(:,1:3);
snrUP = snr(:,1:3);

WF = rate(:,4:6);
snrWF = snr(:,4:6);

EE = rate(:,7:9);
snrEE = snr(:,7:9);

snrvec = min(snr(:)):2:max(snr(:)); % all values of SNR
cm = colormap('lines');

%% total de palavras
N = length(snrvec);
intel = nan*ones(length(snrvec),3);
snrX = nan*ones(length(snrvec),3);
Npoints = zeros(length(snrvec),3);
NR = {'UP','WF','EE'};

for jj = 1:3
    for ii = 1:N
        cols = (jj-1)*3+(1:3);
        Aok = Nok(:,cols);
        Atot = Ntot(:,cols);
        idx = find(snr(:,cols) == snrvec(ii));
        if ~isempty(idx)
            try
                intel(ii,jj) = sum(Aok(idx))/sum(Atot(idx))*100;
                Npoints(ii,jj) = length(idx);
            catch
                disp(idx);
            end
        end
    end
    lin = find(~isnan(intel(:,jj))); % linhas que não são NaN
    yyaxis left
    hp = plot(snrvec(lin), intel(lin,jj),'-');
    hp.Color = cm(mod(jj,64),:);
    hold on
    yyaxis right
    hb = bar(snrvec(lin),Npoints(lin,jj));
    hb.FaceColor = cm(mod(jj,64),:);
    hb.FaceAlpha = .5;
end
yyaxis left
ylabel('% correct words')
legend(NR,'location','southwest')
yyaxis right
ylabel('number of samples')
ylim([1,15])
xlabel('SNR [dB]');
hold off
pause(1)
%%
%% sort arrays
[snrUP,sortIdx] = sort(snrUP(:),'descend');
UP = UP(sortIdx); % sort B using the sorting index
snr2 = setdiff(snrvec,snrUP)';
snrUP = [snrUP; snr2];
UP = [UP; nan*ones(size(snr2))];
%
[snrWF,sortIdx] = sort(snrWF(:),'descend');
WF = WF(sortIdx);
snr2 = setdiff(snrvec,snrWF)';
snrWF = [snrWF; snr2];
WF = [WF; nan*ones(size(snr2))];
%
[snrEE,sortIdx] = sort(snrEE(:),'descend');
EE = EE(sortIdx);
snr2 = setdiff(snrvec,snrEE)';
snrEE = [snrEE; snr2];
EE = [EE; nan*ones(size(snr2))];
%%
figure
boxplot(UP,snrUP,'PlotStyle','compact',...
    'LabelOrientation','horizontal','colors',cm(1,:))

hold on
boxplot(WF,snrWF,'PlotStyle','compact',...
    'LabelOrientation','horizontal','colors',cm(2,:))

hold on
boxplot(EE,snrEE,'PlotStyle','compact',...
    'LabelOrientation','horizontal','colors',cm(3,:))

