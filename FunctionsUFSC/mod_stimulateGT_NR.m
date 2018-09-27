function mod_stimulateGT_NR( mix, speech, noise , map, plotflag )

%%  Call ACE processing routine
if (isfield(map,'Left') ==1)
    map.Left.lr_select = 'left'; %%% left - - - Process the left implant first
    tech = 'EnvEst'; %noise reduction technique: 'EnvEst', 'WF', 'none'
    NRgains = NR_calc(speech, noise, map.Left, tech);
    stimuli.left = ufscACEprocessGT_NR(mix, map.Left, NRgains, plotflag);
end

%% 2DO - right side equivalent
if (isfield(map,'Right') ==1)
    map.Right.lr_select = 'right'; %%% right - - - Process the right implant first
    audio_signal  = AudioSignal( filename, map.Right.lr_select );
    stimuli.right = ufscACEprocessGT(audio_signal,map.Right);
end
stimuli.map=map;

% (Optional) Save stimulus structure for later streaming
% [PATHSTR,NAME,EXT] = fileparts(filename);
% save (['stimuli_CCiMOBILE_', NAME], '-struct', 'stimuli');
% saveas(gcf, ['Electrodogram_CCiMOBILE_', NAME], 'fig'); % Save figure

%% Stream the stimulus to the CCI-Mobile Platform
%Stream (stimuli);

return