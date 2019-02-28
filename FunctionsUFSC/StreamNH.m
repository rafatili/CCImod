function StreamNH( stim,f0 )
%Plays the signal stim at frequency f0.

audio = audioplayer(stim,f0);
play(audio);
pause(length(stim)/f0)

end

