function [ v, fcoefs ] = NR_GammaToneFB( x, p )
%ACE_GAMMATONEFB
%INPUT x: pre-emphasized audio
%      p: modified MAP from pre-emphasis function
%OUTPUT v:time-frequency decomposed energy of the signal

%filterbank
lowFreq = p.LowerCutOffFrequencies(1);
nFilters = p.NumberOfBands;
bandwidths = flipud(p.band_widths);
fs = p.SamplingFrequency;
[s, fcoefs] = CIFilterBank(x, fs, nFilters, lowFreq, bandwidths); 

%plotGammaToneFreqResp(fcoefs,fs) %plot filter frequency response

%envelope extraction
s = abs(hilbert(s'))';
N = length(s);
M = ceil(N/p.block_shift);

v = zeros(nFilters, M);
for ch = 1:nFilters
    u = buffer(s(ch,:), p.block_size, p.block_size - p.block_shift, []);
    u = mean(u.^2); 
    v(ch,:) = u(:);
end
v = flipud(v);