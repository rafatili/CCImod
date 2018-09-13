%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACE_Process - partials
% derived from ACE_Process function (UTD)

% Rafael Chiea Set '18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [vout, sub, sat] = ACE_compression( v, p )
%ACE_COMPRESSION 
%INPUT x: pre-emphasized audio
%      p: modified MAP from pre-emphasis function
%
%OUTPUT 
% vout:            Magnitude in range 0:1 (proportion of dynamic range).
% sub:          Logical FTM indicating the values that were below base_level.
% sat:          Logical FTM indicating the values that were above sat_level.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[vout, sub, sat] = logarithmic_compression(p, v);

end

