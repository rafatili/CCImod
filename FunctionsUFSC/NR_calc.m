function NRgains = NR_calc(speech, noise, p, tech)
%NRgains = NR_calc(speech, noise, p, tech)

%Speech
[speech, p] = ACE_preEmphasis(speech, p);
[ Es ] = NR_GammaToneFB( speech, p ); %filtragem usando GammaTone filterbank

%Noise
[noise, p] = ACE_preEmphasis(noise, p);
[ En ] = NR_GammaToneFB( noise, p ); %filtragem usando GammaTone filterbank

%% calculate gains
xi = Es./En; %time-frequency SNR

switch tech
    case 'BM'
        NRgains = xi>=1;
    case 'WF'
        NRgains = 1./(1 + 1./xi);
    case 'EnvEst'
        a = 2;
        NRgains = sqrt((a + 1./xi)./(a + 4./xi + 2./(xi.^2)));
    case 'none'
        NRgains = ones(size(xi));
    otherwise
        NRgains = ones(size(xi));
        warning('type input must be either "WF", "EnvEst" or "none". Any other input will be treated as "none"');
end

