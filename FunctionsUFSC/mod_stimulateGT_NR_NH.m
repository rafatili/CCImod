function [stimuli, NRgains] = mod_stimulateGT_NR_NH( mix, speech, noise , map, tech, vtype, plotflag )
% mod_stimulateGT_NR( mix, speech, noise , map, tech, plotflag )
%INPUT: mix     = noisy signal
%       speech  = target signal
%       noise   = noise signal
%       map     = patient's map
%       tech    = noise reduction technique: 'EnvEst', 'WF', 'BM' or 'none'
%       plotflag= plot electrodogram? 1 yes; 0  

%%  Call ACE processing routine
if (isfield(map,'Left') ==1)
    map.General.LeftOn = 1; %indicates the desire to stimulate the left channel
    map.Left.lr_select = 'left'; %%% left - - - Process the left implant first
    NRgains.left = NR_calc(speech, noise, map.Left, tech);
    stimuli = ufscACEprocessGT_NR_NH(mix, map.Left, NRgains.left, vtype, plotflag);
end

%% 2DO - right side equivalent
if (isfield(map,'Right') ==1)
    map.General.RightOn = 1; %indicates the desire to stimulate the right channel
    map.Right.lr_select = 'right'; %%% right - - - Process the right implant first
    NRgains.right = NR_calc(speech, noise, map.Right, tech);
    stimuli = ufscACEprocessGT_NR_NH(mix, map.Right, NRgains.right, vtype, plotflag);
end

return