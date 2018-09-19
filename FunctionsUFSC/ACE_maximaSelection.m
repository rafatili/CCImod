%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACE_Process - partials
% derived from ACE_Process function (UTD)

% Rafael Chiea Set '18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ v ] = ACE_maximaSelection( v, p )
%ACE_MAXIMASELECTION Selection of the N of M channels of greater amplitude
%in each time frame
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reject_smallest_amplitude channels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[num_bands, num_time_slots] = size(v);
if (p.num_rejected > 0)
    if (p.num_rejected > num_bands)
        error('Number to be rejected is greater than number of bands');
    end
    % If we treat the input matrix v as one long column vector,
    % then the indexes of the start of each column are:
    x0 = num_bands * [0:(num_time_slots-1)];
    for n = 1:p.num_rejected
        [~, k] = min(v);
        % m is x row vector containing the minimum of each column (time-slot).
        % k is x row vector containing the row number (channel number) of each minimum.
        % If we treat the input matrix v as one long column vector,
        % then the indexes of the minima are:
        xk = x0 + k;
        v(xk) = NaN;	% Reject the smallest values.
    end
end

end

