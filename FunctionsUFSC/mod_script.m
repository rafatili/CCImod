%test script for the modACE function

p = initialize_ACE;
handles.parameters = p;
faddress = 'S_01_01.wav';
plotflag = 1;
%mod_stimulateFFT(faddress, handles.parameters, plotflag);
mod_stimulateGT(faddress, handles.parameters, plotflag); %use gammatone filters