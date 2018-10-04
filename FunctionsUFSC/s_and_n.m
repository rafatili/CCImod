function [S_mix, S, N] = s_and_n(S, N, SNRdb)
%%
% Adds noise to the speech signal at a given signal to noise ratio (SNR)
%
% S_mix = s_and_n(S, N, SNRdb)
%
%   -S_mix is the noisy signal at the specified SNR in dB.
%   -S and N are respectively the speech and noise arrays.

%% evaluate SNR
P_S = norm(S,2)^2;    %sum(pwelch(S)); % signal power
P_N = norm(N,2)^2;   %sum(pwelch(N)); % noise power

if P_N == 0; %noise signal is null;
    S_mix = S;
else
    SNR_in = P_S/P_N; %SNR of the input signals
    
    SNR = 10^(SNRdb/10);
    
    a = sqrt(SNR_in/SNR); % parameter to adjust SNR to wanted value
    N = a*N;
    
    S_mix = S+N;    %mixed signal
    P_mix = norm(S_mix,2)^2;    %power of the mixed signal
    
    %% normalize the signals so that the power of the output noisy signal is
    %% equal to the one of the input target audio
    S_mix = S_mix * sqrt(P_S/P_mix);
    S = S * sqrt(P_S/P_mix);
    N = N * sqrt(P_S/P_mix);
end