%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACE_Process - partials
% derived from ACE_Process function (UTD)

% Rafael Chiea Set '18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ stimulus ] = ACE_stimuli( q )
%ACE_STIMULI creates a structure to be used as the input of the Stream
%function

%INPUT v: time-frequency signal
%      p: modified MAP from pre-emphasis function
%OUTPUT q: structure with stimuli mapping information

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Output Stimulus sequence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stimulus.current_levels=q.current_levels;
stimulus.electrodes= q.electrodes; 
        
%stimulus.header=['Created using ' guiInputData.Strategy ' strategy from MATLAB for CCIMobile on ' datestr(now)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

