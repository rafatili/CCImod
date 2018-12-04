function [SRT, mean_idx] = calcSRTx( snr_seq )
%CALCSRTX calculate SRT based on SNR sequence
%   Calculate SRT based on SNR sequence resulted from adaptative
%   psychoacoustical experiment (Levit, 1971)

% find points of changes in direction to separate runs
snr_clean = snr_seq(diff([0;snr_seq])~=0); %removes subsequent equal values
d = sign(diff(snr_clean));
aux = d(2:end) + d(1:end-1);
idx = find(aux==0)+1;

% calculates the mean of every second run
odd_idx = idx(1:2:end);
even_idx = idx(2:2:end);

L = length(even_idx);
SRT = zeros(L,1);
mean_idx = zeros(L,1);
for ii = 1:L
    SRT(ii) = (snr_clean(even_idx(ii)) + snr_clean(odd_idx(ii)))/2;
    mean_idx(ii) = (even_idx(ii) + odd_idx(ii))/2;
end
%% test plots    
plot(snr_clean); hold on; 
plot(idx,snr_clean(idx),'o')
plot(mean_idx, SRT, 'x')
end

