%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACE_Process - partials
% derived from ACE_Process function (UTD)

% Rafael Chiea Set '18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ q ] = ACE_mapping( v, p )
%ACE_MAPPING Maps the compressed time-frequency signal into electric
%stimuli
%INPUT v: time-frequency signal
%      p: modified MAP from pre-emphasis function
%OUTPUT q: structure with stimuli mapping information 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Collate_into_sequence: creates a chan-mag sequence from an FTM.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[num_bands, num_time_slots] = size(v);
cseq.channels = repmat(p.channel_order, num_time_slots, 1);
reord_env = v(p.channel_order,:);			% Re-order the channels (rows)
cseq.magnitudes = reord_env(:);				% Concatenate columns.

skip = isnan(cseq.magnitudes);
cseq.channels  (skip) = [];
cseq.magnitudes(skip) = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Channel_mapping: Map a channel-magnitude sequence to a pulse sequence.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~all(cseq.channels >= 0) || ~all(cseq.channels <= 22)
    error('Channel number out of range');
end;

electrodes			= [p.Electrodes; 0];
threshold_levels	= [p.THR; 0];
comfort_levels		= [p.MCL; 0];

idle_pulses = (cseq.channels == 0);
cseq.channels(idle_pulses) = length(electrodes);

% Create the fields in the order we like to show them in Disp_sequence:
q.electrodes	= electrodes(cseq.channels);
q.modes			= p.StimulationModeCode;

% Current level:
ranges			= comfort_levels - threshold_levels;
q_magnitudes	= cseq.magnitudes;
q_magnitudes	= min(q_magnitudes, 1.0);
q_t = threshold_levels(cseq.channels);
q_r = ranges(cseq.channels);
q.current_levels = round(q_t + q_r .* p.volume_level .* q_magnitudes);

% Idle pulses are marked by magnitudes less than zero.
q.is_idle = (q_magnitudes < 0);		% logical vector
% The current levels calculated above do not apply for idle pulses,
% set idle pulses current level to zero:
q.current_levels(q.is_idle)	= 0;
%q.electrodes(q.is_idle) = 0;

q.phase_widths		= p.PulseWidth;		% Constant phase width.
q.phase_gaps		= p.IPG;			% Constant phase gap.
% period_cycles		= round(5e6 /(p.StimulationRate*p.Nmaxima));
% q.periods			= 1e6 * period_cycles / 5e6;	% microseconds
% q.periods         = ((8e6/p.pulses_per_frame)-2*p.PulseWidth - p.IPG)/1000;
q.periods           = 1e6/(p.StimulationRate*p.Nmaxima);

end

