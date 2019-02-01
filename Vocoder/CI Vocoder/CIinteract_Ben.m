% Meine Ci-Interaktion
function out_signal = CIinteract_Ben(signal,m, distance_electrodes, lambda)
% baue gewichtungsmatrix mit den Gewichtungen pro Kanal auf

% lambda = 0.0072; %0.0036 [m] Verteilungskonstante
d = distance_electrodes; %0.0028[m] Abstand zwischen den Elektroden
% m = 5; % --> Abklingen auf 1% bei +/- 5 Kanäle
      
Nr_chans = size(signal,1);

mspatial_weight = eye(Nr_chans,Nr_chans)./2; %Wir addieren nachher nochmals die matrix dazu, so dass die Gewichte stimmen

weights_right = exp(-[1:m]*d/lambda);
weights_left = fliplr(weights_right);

for ii = 1:size(mspatial_weight,1)
    mspatial_weight(ii,ii+1:m+ii) = weights_right;
end
mspatial_weight = mspatial_weight(1:Nr_chans,1:Nr_chans);
% Spiegele oberen Teil der Matrix an Hauptdiagonaler in den unteren Teil
mspatial_weight=triu(mspatial_weight,-1)'+mspatial_weight; 

% Signal mit einer Zahl ungleich 0 pro zeiteinheit -> sequentielle
% Stimulation!
% signal = eye(12, 12).*rand(12);
% signal = eye(12,12);
% signal = repmat(signal, 1, 1);

puls_idx = signal>0;
out_signal = zeros(size(signal));
for ii = 1:size(signal,1); %Über alle Kanäle
    channel_active_idx = puls_idx(ii,:) > 0; % Finde alle Zeitpunkte, in denen der aktuelle Kanal aktiv ist
    %   Multitpliziere alle aktiven Zeitpunkte des Signales mit
    %   Gewichtungsfunktion pro Kanal
    out_signal(:,channel_active_idx) = bsxfun(@times, signal(ii,channel_active_idx),mspatial_weight(ii,:)');
    % out_signal(ii,:) = signal(:,channel_active_idx).*mspatial_weight(ii,:);
end
end

