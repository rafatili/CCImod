function Stream_2( stimuli )
%stream stimuli to implants

%% Stream the stimuli to the CCI-Mobile Platform
try
    Stream (stimuli);
catch
    warning('Stream failled. Verify the board connection.')
end

end

