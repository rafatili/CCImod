function [ stimulus ] = ufscACEprocessFFT( x,p, varargin )
%UFSCACEPROCESSFFT performs ACE processing
%INPUT x: input audio
%      p: MAP structure (.Left or .Right)
%      vargin{1} is a flag. If value is 1 electrodogram is ploted
%OUTPUT stimulus: electric stimuli structure   

[x, p] = ACE_preEmphasis(x, p);
[ v ] = ACE_FFTfilterbank( x, p );
[ v ] = ACE_maximaSelection( v, p );
[v, sub, sat] = ACE_compression( v, p );
[ q ] = ACE_mapping( v, p );
[ stimulus ] = ACE_stimuli( q );

if ~isempty(varargin)
    if varargin{1} == 1;
        %% Plot Electrodogram
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        q.electrodes(q.is_idle) = 0;
        u=plot_electrodogram(q,['Electrodogram: ' p.lr_select ' ear']);
        if strcmp(p.lr_select,'left');
            pos = 'northeast';
        else
            pos = 'southeast';
        end
        movegui(u.h_figure, pos)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if length(varargin) > 1
            warning('first argument is used as a flag for plotting the electrodogram. All other arguments are ignored');
        end
    end
end
end

