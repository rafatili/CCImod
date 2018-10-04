function [ v2 ] = ACE_filterNR( v, NRgains )
%[ v2 ] = ACE_filterNR( v, NRgains )
% input: v is the time-frequency signal from the filterbank function
%        NRgains is the noise reduction matrix of gains
%output: v2 is the speech-enhanced time-frequency signal
%
%By Rafael Chiea 09/2018

Sv = size(v);
Sg = size(NRgains);

if Sv~=Sg
    if Sv == fliplr(Sg);
        NRgains = NRgains';
    else
        warning('NRgains must be the same size as time-frequency signal v');
    end
end

v2 = v .* NRgains;