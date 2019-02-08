function closeElectdgrmFigs
fhl = findobj( 'Type', 'Figure', 'Name', 'Electrodogram: left ear' );
fhr = findobj( 'Type', 'Figure', 'Name', 'Electrodogram: right ear' );
close(fhl)
close(fhr)

fhl = findobj( 'Type', 'Figure', 'Name', 'Spectrogram: left ear' );
fhr = findobj( 'Type', 'Figure', 'Name', 'Spectrogram: right ear' );
close(fhl)
close(fhr)
end
