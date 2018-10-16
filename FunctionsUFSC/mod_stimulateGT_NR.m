function stimuli = mod_stimulateGT_NR( mix, speech, noise , map, tech, plotflag )
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
    NRgains = NR_calc(speech, noise, map.Left, tech);
    stimuli.left = ufscACEprocessGT_NR(mix, map.Left, NRgains, plotflag);
end

%% 2DO - right side equivalent
if (isfield(map,'Right') ==1)
    map.General.RightOn = 1; %indicates the desire to stimulate the right channel
    map.Right.lr_select = 'right'; %%% right - - - Process the right implant first
    NRgains = NR_calc(speech, noise, map.Right, tech);
    stimuli.right = ufscACEprocessGT_NR(mix, map.Right, NRgains, plotflag);
end
stimuli.map=map;

% (Optional) Save stimulus structure for later streaming
% [PATHSTR,NAME,EXT] = fileparts(filename);
% save (['stimuli_CCiMOBILE_', NAME], '-struct', 'stimuli');
% saveas(gcf, ['Electrodogram_CCiMOBILE_', NAME], 'fig'); % Save figure

return