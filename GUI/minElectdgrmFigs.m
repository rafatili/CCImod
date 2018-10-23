function minElectdgrmFigs(pauseTime)
fhl = findobj( 'Type', 'Figure', 'Name', 'Electrodogram: left ear' );
jFrameL = get(handle(fhl), 'JavaFrame');

fhr = findobj( 'Type', 'Figure', 'Name', 'Electrodogram: right ear' );
jFrameR = get(handle(fhr), 'JavaFrame');


pause(pauseTime);
if ~isempty(jFrameL)
    jFrameL.setMinimized(1);
end
if ~isempty(jFrameR)
    jFrameR.setMinimized(1);
end
end

