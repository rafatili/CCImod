% MAP file structure for CCI Platform

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: CRSS-CILab, UT-Dallas
%   Authors: Hussnain Ali, Rafael Chiea
%      Date: 2018/10/24
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MAP.General.SubjectName      = 'Adelaide de Souza Costa';       % Optional: Subject Name
MAP.General.SubjectID        = 'S02';              % Optional: Random Subject ID
MAP.General.MapTitle         = 'S02_ACE_1200Hz';    % Optional: Map Title

MAP.General.NumberOfImplants = 1;                  % '1' for Unilateral and '2' for Bilateral
MAP.General.ImplantedEar     = 'Right';        % 'Left' for left side; 'Right' for right side; 'Bilateral' for both sides
MAP.General.StimulateEars    = 'Right';        % 'Left' for left only; 'Right' for right only; 'Both'|'Bilateral' for both sides; 'NULL' for no stimulation

%% Right Ear Parameters
%  remove this section if right side does not exist
MAP.Right.ImplantType       = 'CI24RE';
MAP.Right.SamplingFrequency = 16000;            % Fixed
MAP.Right.NumberOfChannels  = 22;               % 22 fixed for imlants from Cochlear Ltd.
MAP.Right.Strategy          = 'ACE';            % 'ACE' or 'CIS' or 'Custom'
MAP.Right.Nmaxima           = 10;                % Nmaxima 1 - 22 for n-of-m strategies
MAP.Right.StimulationMode   = 'MP1+2';          % Electrode Configuration/Stimulation mode e.g., MP1, MP1+2, BP1, BP1+2, CG,....etc.
MAP.Right.StimulationRate   = 1200;             % Stimulation rate per electrode in number of pulses per second (pps)
MAP.Right.PulseWidth        = 25;               % Pulse width in us
MAP.Right.IPG               = 8;                % Inter-Phase Gap (IPG) fixed at 8us (could be variable in future)
MAP.Right.Sensitivity       = 2.3;              % Microphone Sensitivity (adjustable in GUI)
MAP.Right.Gain              = 25;               % Global gain for envelopes in dB - standard is 25dB (adjustable in GUI)
MAP.Right.Volume            = 10;               % Volume Level on a scale of 0 to 10; 0 being lowest and 10 being highest (adjustable in GUI)
MAP.Right.Q                 = 20;               % Q-factor for the compression function
MAP.Right.BaseLevel         = 0.0156;           % Base Level
MAP.Right.SaturationLevel   = 0.556;            % Saturation Level
MAP.Right.ChannelOrderType  = 'base-to-apex';   % Channel Stimulation Order type: 'base-to-apex' or 'apex-to-base'
MAP.Right.FrequencyTable    = 'Default';        % Frequency assignment for each band "Default" or "Custom"
MAP.Right.Window            = 'Hanning';         % Window type
MAP.Right.El_CF1_CF2_THR_MCL_Gain = [
  % El  F_Low   F_High  THR     MCL     Gain
    22  188     313     134     196     0.0
    21	313     438     134     196     0.0
    20	438     563     134     197     0.0
    19	563     688     135     197     0.0
    18	688     813     135     198     0.0
    17	813     938     135     199     0.0
    16	938     1063    136     200     0.0
    15	1063    1188    131     198     0.0
    14	1188    1313    126     197     0.0
    13	1313    1563    122     195     0.0
    12	1563    1813    117     194     0.0
    11	1813    2063    113     193     0.0
    10	2063    2313    112     190     0.0
    9	2313    2688    111     187     0.0
    8	2688    3063    111     185     0.0
    7	3063    3563    110     182     0.0
    6	3563    4063    110     180     0.0
    5	4063    4688    115     181     0.0
    4	4688    5313    120     182     0.0
    3	5313    6063    125     183     0.0
    2	6063    6938    130     184     0.0
    1	6938    7938    135     185     0.0
    ];
MAP.Right.NumberOfBands             = size(MAP.Right.El_CF1_CF2_THR_MCL_Gain, 1);   % Number of active electrodes/bands
MAP.Right.Electrodes                = MAP.Right.El_CF1_CF2_THR_MCL_Gain(:, 1);      % Active Electrodes
MAP.Right.LowerCutOffFrequencies    = MAP.Right.El_CF1_CF2_THR_MCL_Gain(:, 2);      % Low cut-off frequencies of filters
MAP.Right.UpperCutOffFrequencies    = MAP.Right.El_CF1_CF2_THR_MCL_Gain(:, 3);      % Upper cut-off frequencies of filters
MAP.Right.THR                       = MAP.Right.El_CF1_CF2_THR_MCL_Gain(:, 4);      % Threshold Levels (THR)
MAP.Right.MCL                       = MAP.Right.El_CF1_CF2_THR_MCL_Gain(:, 5);      % Maximum Comfort Levels (MCL)
MAP.Right.BandGains                 = MAP.Right.El_CF1_CF2_THR_MCL_Gain(:, 6);      % Individual Band Gains (dB)
MAP.Right.Comments                  = '';                                           % Optional: comments