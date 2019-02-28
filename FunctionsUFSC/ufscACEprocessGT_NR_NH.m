function [ vocoded_signal ] = ufscACEprocessGT_NR_NH( x,p, NRgains, vtype, varargin )
%UFSCACEPROCESSFFT performs ACE processing
%INPUT x: input audio signal
%      p: MAP structure (.Left or .Right)
%      vargin{1} is a flag. If value is 1 electrodogram is ploted
%OUTPUT stimulus: electric stimuli structure   

[x1, p] = ACE_preEmphasis(x, p);
[ v ] = ACE_GammaToneFB( x1, p ); % GammaTone filterbank
[ v1 ] = ACE_filterNR( v, NRgains ); % apply noise reduction

fs = p.SamplingFrequency/p.block_shift;
rms_x = sqrt(mean(abs(x).^2,1));

fout = p.SamplingFrequency;

%% choose the vocoder type

switch(vtype) 
    case 'CIsim' %CI symulator from Braker 2009
        [vocoded_signal] = CI_Vocoder_Cochlear_envInput(v1,fs,'CI', rms_x, fout);
    
    case 'white' %white noise regular vocoder
        %% white noise carriers
        y1 = resample(v1', fout, fs)';
        L = length(y1);
        noise = wgn(L,1,0);
        %filterbank
        %filterbank
        lowFreq = p.LowerCutOffFrequencies(1);
        nFilters = p.NumberOfBands;
        bandwidths = flipud(p.band_widths);
        fs = p.SamplingFrequency;
        [carriers] = CIFilterBank(noise, fs, nFilters, lowFreq, bandwidths);
        carriers = flipud(carriers);
        
        varN = var(carriers,0,2);
        for ii = 1:length(varN)
            carriers(ii,:) = carriers(ii,:)/sqrt(varN(ii));
        end
        y2 = sum(carriers.*y1)';
        rms_y = sqrt(mean(abs(y2).^2,1));
        [vocoded_signal] = y2*rms_x/rms_y; %signal power is set equal to input signal
        
        %avoid clipping
        val = max(abs(vocoded_signal));
        if val>1,
            warning('Signal clipped! Amplitude is divided by %.2f',val);
            vocoded_signal = vocoded_signal/val; % Rafael Chiea - if signal clipped, gain is readjusted.
        end
end
        
        
if ~isempty(varargin)
    if varargin{1} == 1;
        %% Plot Electrodogram
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        u=figure;
        spgrambw(vocoded_signal, fout,'J');
        colormap('hot');
        
        if strcmp(p.lr_select,'left');
            pos = 'northeast';
            u.Name = 'Spectrogram: left ear';
        else
            pos = 'southeast';
            u.Name = 'Spectrogram: right ear';
        end
        movegui(u, pos)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if length(varargin) > 1
            warning('first argument is used as a flag for plotting the spectrodogram. All other arguments are ignored');
        end
    end
end