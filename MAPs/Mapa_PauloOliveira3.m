% MAP file structure for CCI Platform

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: CRSS-CILab, UT-Dallas
%   Authors: Hussnain Ali
%      Date: 2015/09/28
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MAP.General.SubjectName      = 'Paulo Dias de Oliveira';       % Optional: Subject Name
MAP.General.SubjectID        = 'S08';              % Optional: Random Subject ID
MAP.General.MapTitle         = 'S08_ACE_900Hz';    % Optional: Map Title

MAP.General.NumberOfImplants = 1;                  % '1' for Unilateral and '2' for Bilateral
MAP.General.ImplantedEar     = 'Left';        % 'Left' for left side; 'Right' for right side; 'Bilateral' for both sides
MAP.General.StimulateEars    = 'Left';        % 'Left' for left only; 'Right' for right only; 'Both'|'Bilateral' for both sides; 'NULL' for no stimulation

%% Left Ear Parameters
%  remove this section if left side does not exist
MAP.Left.ImplantType        = 'CI24RE';     %Implant chip type, e.g., CI24RE(CS/CA), CI24R, CI24M, CI22M, ST
MAP.Left.SamplingFrequency  = 16000;        % Fixed
MAP.Left.NumberOfChannels   = 22;           % 22 fixed for imlants from Cochlear Ltd.
MAP.Left.Strategy           = 'ACE';        % 'ACE' or 'CIS' or 'Custom'
MAP.Left.Nmaxima            = 8;            % Nmaxima 1 - 22 for n-of-m strategies
MAP.Left.StimulationMode    = 'MP1+2';      % Electrode Configuration/Stimulation mode e.g., MP1, MP1+2, BP1, BP1+2, CG,....etc.
MAP.Left.StimulationRate    = 900;         % Stimulation rate per electrode in number of pulses per second (pps)
MAP.Left.PulseWidth         = 25;           % Pulse width in us
MAP.Left.IPG                = 8;            % Inter-Phase Gap (IPG) fixed at 8us (could be variable in future)
MAP.Left.Sensitivity        = 2.3;          % Microphone Sensitivity (adjustable in GUI)
MAP.Left.Gain               = 25;           % Global gain for envelopes in dB - standard is 25dB (adjustable in GUI)
MAP.Left.Volume             = 10;           % Volume Level on a scale of 0 to 10; 0 being lowest and 10 being highest (adjustable in GUI)
MAP.Left.Q                  = 20;           % Q-factor for the compression function
MAP.Left.BaseLevel          = 0.0156;       % Base Level
MAP.Left.SaturationLevel    = 0.5859;       % Saturation Level
MAP.Left.ChannelOrderType   = 'base-to-apex'; % Channel Stimulation Order type: 'base-to-apex' or 'apex-to-base'
MAP.Left.FrequencyTable     = 'Default';    % Frequency assignment for each band "Default" or "Custom"
MAP.Left.Window             = 'Hanning';     % Window type
MAP.Left.El_CF1_CF2_THR_MCL_Gain = [
  % El  F_Low   F_High  THR     MCL     Gain
    22  188     313     136     178     0.0
    21	313     438     136     176     0.0
    20	438     563     136     174     0.0
    19	563     688     136     172     0.0
    18	688     813     136     170     0.0
    17	813     938     136     168     0.0
    16	938     1063    137     166     0.0
    15	1063    1188    134     164     0.0
    14	1188    1313    131     163     0.0
    13	1313    1563    129     161     0.0
    12	1563    1813    126     160     0.0
    11	1813    2063    124     159     0.0
    10	2063    2313    123     157     0.0
    9	2313    2688    123     156     0.0
    8	2688    3063    123     154     0.0
    7	3063    3563    123     153     0.0
    6	3563    4063    123     152     0.0
    5	4063    4688    126     156     0.0
    4	4688    5313    130     160     0.0
    3	5313    6063    134     164     0.0
    2	6063    6938    146     167     0.0
    1	6938    7938    137     167     0.0
    ];
MAP.Left.NumberOfBands          = size(MAP.Left.El_CF1_CF2_THR_MCL_Gain, 1);    % Number of active electrodes/bands
MAP.Left.Electrodes             = MAP.Left.El_CF1_CF2_THR_MCL_Gain(:, 1);       % Active Electrodes
MAP.Left.LowerCutOffFrequencies = MAP.Left.El_CF1_CF2_THR_MCL_Gain(:, 2);       % Low cut-off frequencies of filters
MAP.Left.UpperCutOffFrequencies = MAP.Left.El_CF1_CF2_THR_MCL_Gain(:, 3);       % Upper cut-off frequencies of filters
MAP.Left.THR                    = MAP.Left.El_CF1_CF2_THR_MCL_Gain(:, 4);       % Threshold Levels (THR)
MAP.Left.MCL                    = MAP.Left.El_CF1_CF2_THR_MCL_Gain(:, 5);       % Maximum Comfort Levels (MCL)
MAP.Left.BandGains              = MAP.Left.El_CF1_CF2_THR_MCL_Gain(:, 6);       % Individual Band Gains (dB)
MAP.Left.Comments               = '';                                           % Optional: comments