% [cochlearOutput, ERB] = CIFilterBank(fs, nCochlearFilters, lowFreq, s)
% -----------------------------------------------
% fs: The sampling rate of the signal, s, in Hz.
% nCochlearFilters: The number of critical-band filters in the filterbank.
% lowFreq: Lowest center frequency of the filterbank.
% s: The signal to be filtered.
%
% cochlearOutput: The outputs of the filterbank, organized as a matrix of
%   dimensions (nCochlearFilters, length(s)).
% ERB: The equivalent rectangular bandwidth of each cochlear channel or
%   filter.
% -----------------------------------------------
% Filters the signal through an analysis/decomposition cochlear 
% filterbank that models the first stage of the human auditory 
% system.  The output is nCochlearFilters number of signals, and a
% corresponding vector containing the ERB values for each filter.

function [cochlearOutputs, filterbankCoefs] = CIFilterBank(s, fs, nCochlearFilters, lowFreq, bandwidths)

% Construct the cochlear filter bank and filter the signal through it.
[filterbankCoefs] = MakeCIFilters(fs, nCochlearFilters, lowFreq, bandwidths);
cochlearOutputs = ERBFilterBank(s, filterbankCoefs);

end