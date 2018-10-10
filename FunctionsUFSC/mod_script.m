%test script for the modACE function

p = initialize_ACE;
handles.parameters = p;
faddress = 'S_01_01.wav';
plotflag = 1;
%stimuli = mod_stimulateFFT(faddress, handles.parameters, plotflag);
stimuli = mod_stimulateGT(faddress, handles.parameters, plotflag); %use gammatone filters

Stream_2(stimuli);