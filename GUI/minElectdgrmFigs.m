function minElectdgrmFigs(pauseTime)
fhl = findobj( 'Type', 'Figure', 'Name', 'Electrodogram: left ear' );
jFrameL = get(handle(fhl), 'JavaFrame');

fhr = findobj( 'Type', 'Figure', 'Name', 'Electrodogram: right ear' );
jFrameR = get(handle(fhr), 'JavaFrame');

if isempty(fhl)
    fhl = findobj( 'Type', 'Figure', 'Name', 'Spectrogram: left ear' );
    jFrameL = get(handle(fhl), 'JavaFrame');
end
if isempty(fhr) 
    fhr = findobj( 'Type', 'Figure', 'Name', 'Spectrogram: right ear' );
    jFrameR = get(handle(fhr), 'JavaFrame');
end

pause(pauseTime);
if ~isempty(jFrameL)
    jFrameL.setMinimized(1);
end
if ~isempty(jFrameR)
    jFrameR.setMinimized(1);
end
end

