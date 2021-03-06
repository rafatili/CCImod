function stimuli = mod_stimulateFFT( filename , map, plotflag )

%%  Call ACE processing routine
if (isfield(map,'Left') ==1)
    map.General.LeftOn = 1; %indicates the desire to stimulate the left channel
    map.Left.lr_select = 'left'; %%% left - - - Process the left implant first
    audio_signal  = AudioSignal( filename, map.Left.lr_select );
    stimuli.left = ufscACEprocessFFT(audio_signal, map.Left, plotflag);
end

if (isfield(map,'Right') ==1)
    map.General.RightOn = 1; %indicates the desire to stimulate the right channel
    map.Right.lr_select = 'right'; %%% right - - - Process the right implant first
    audio_signal  = AudioSignal( filename, map.Right.lr_select );
    stimuli.right = ufscACEprocessFFT(audio_signal,map.Right, plotflag);
end
stimuli.map=map;

% (Optional) Save stimulus structure for later streaming
% [PATHSTR,NAME,EXT] = fileparts(filename);
% save (['stimuli_CCiMOBILE_', NAME], '-struct', 'stimuli');
% saveas(gcf, ['Electrodogram_CCiMOBILE_', NAME], 'fig'); % Save figure


return