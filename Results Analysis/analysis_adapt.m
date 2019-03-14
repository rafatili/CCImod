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

figure
scatter(snrWF(:),WF(:))
hold on
scatter(snrEE(:),EE(:))
scatter(snrUP(:),UP(:))

figure
%boxplot(WF(:),snrWF(:),'color','r','style','compact')
boxplot(WF(:),snrWF(:),'color','r')


