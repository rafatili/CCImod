%test script for the modACE function

p = initialize_ACE;
handles.parameters = p;
faddress = 'S_01_01.wav';
plotflag = 1;
mod_stimulate(faddress, handles.parameters, plotflag);