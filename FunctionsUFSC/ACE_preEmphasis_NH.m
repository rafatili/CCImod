%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACE_Process - partials
% derived from ACE_Process function (UTD)

% Rafael Chiea Set '18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x_out, pmod] = ACE_preEmphasis_NH(x, p)
% p is a MAP structure (.Left or .Right)
%x is the audio signal vector

% pmod is the modified p MAP
global fs; fs = p.SamplingFrequency; % 16000 Hz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Front-end scaling and pre-emphasis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p.front_end_scaling = 1.0590e+003; p.input_scaling =  5.5325e-004;
%Preemphasis
p.pre_numer =    1; %[0.5006   -0.5006];
p.pre_denom =    1; %[1.0000   -0.0012];

y = x * p.front_end_scaling;
z = filter(p.pre_numer, p.pre_denom, y);
x_out = z * p.input_scaling;

pmod = p;
