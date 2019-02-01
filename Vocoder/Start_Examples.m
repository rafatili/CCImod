% 
% This script demonstrates the use of the CI Vocoder 
% from Bräcker, T. et al. (2009): Simulation und Vergleich von
% Sprachkodierungsstrategien in Cochlea-Implantaten. 
% Zeitschrift der Audiologie, 48(4):158-169.
% 
% Author:   Florian Langner
% Version:  1.00
% Date:     12.03.15
% 

clc; clear all; close all;
addpath('CI Vocoder');

% Load the wav files into Matlab
[Original_Male, fs] = wavread('well-talk-about-it-soon.wav');
[Original_Female] = wavread('youre-on-the-right-track.wav');

% Use the Vocoder with CI simulation and the MED-EL simulation
Vocoded_Male_MEDEL = CI_Vocoder_MEDEL(Original_Male, fs, 'CI');
Vocoded_Female_MEDEL = CI_Vocoder_MEDEL(Original_Female, fs, 'CI');

% Use the Vocoder with CI simulation and the Cochlear Nucleus simulation
Vocoded_Male_Cochlear = CI_Vocoder_Cochlear(Original_Male, fs, 'CI');
Vocoded_Female_Cochlear = CI_Vocoder_Cochlear(Original_Female, fs, 'CI');

% Use the Vocoder with CI simulation and Cochlear Nucleus simulation, but
% with a bigger pulse-width (example how to override the default optional parameter usage with 
% 'key-value' pairs.)
Vocoded_Male_Cochlear_pulse_width = CI_Vocoder_Cochlear(Original_Male, fs, 'CI', 'len_pulse', 3);

% Preperation and presentation of original and vocoded signal
Silence = zeros(fs, 1)';
Presentation = [Original_Male' Silence Vocoded_Male_MEDEL' Silence Vocoded_Male_Cochlear' Silence ...
                Original_Female' Silence Vocoded_Female_MEDEL' Silence Vocoded_Female_Cochlear'];
player = audioplayer(Presentation, fs);
play(player);

% End of File