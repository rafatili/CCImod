function closeElectdgrmFigs
fhl = findobj( 'Type', 'Figure', 'Name', 'Electrodogram: left ear' );
fhr = findobj( 'Type', 'Figure', 'Name', 'Electrodogram: right ear' );
close(fhl)
close(fhr)
end
