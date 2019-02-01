function [ vocoded_signal ] = ufscACEprocessGT_NR_NH( x,p, NRgains, varargin )
%UFSCACEPROCESSFFT performs ACE processing
%INPUT x: input audio signal
%      p: MAP structure (.Left or .Right)
%      vargin{1} is a flag. If value is 1 electrodogram is ploted
%OUTPUT stimulus: electric stimuli structure   

[x1, p] = ACE_preEmphasis_NH(x, p);
[ v ] = ACE_GammaToneFB( x1, p ); % GammaTone filterbank
[ v1 ] = ACE_filterNR( v, NRgains ); % apply noise reduction

fs = p.SamplingFrequency/p.block_shift;
rms_x = sqrt(mean(abs(x).^2,1));

fout = p.SamplingFrequency;

vocoder_type = 'CI';
[vocoded_signal] = CI_Vocoder_Cochlear_envInput(v1,fs,vocoder_type, rms_x, fout);