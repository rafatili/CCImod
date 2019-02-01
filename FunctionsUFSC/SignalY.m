classdef SignalY < handle
    %SIGNAL class of signal under test info
    %   Smix = target + 1/SNR * noise
    
    properties
        Xfile;      %.wav file associated to target signal
        Nfile;      %.wav file associated to noise signal
        SNRdB;    %signal to noise ratio
        fs=16000;   %sample rate
        DB_dir = '';
        noise_dir = '';
        speech_dir = '';
        %        Tangle;   %angle of the target signal(degrees)
        %        Nangle;   %angle of the target signal(degrees)
    end
    
    properties(Access = private)
        PrvtSNR;
        Prvttarget;     %target signal data
        Prvtnoise;      %noise signal data
        PrvtSmix;     %noisy signal
    end
    
    properties(Dependent)
        SNR;
        target;     %target signal data
        noise;      %noise signal data
        Smix;     %noisy signal
    end
    
    methods
        function obj = SignalY(xf,nf,snrDB,varargin) %constructor
            if nargin > 3
                obj.fs = varargin{4};
            end
            if nargin > 0
                obj.Xfile = xf;
                obj.Nfile = nf;
                obj.SNRdB = snrDB;
                %obj.mix();
            end
        end
        %% Gets
        function snr = get.SNR(obj)
            snr = obj.PrvtSNR;
        end
        function trgt = get.target(obj)
            trgt = obj.Prvttarget;
        end
        function ns = get.noise(obj)
            ns = obj.Prvtnoise;
        end
        function out = get.Smix(obj)
            out = obj.PrvtSmix;
        end
        %% Sets
        function set.Xfile(obj,xf)
            if ischar(xf) && strcmpi(xf(end-3: end), '.wav')
                obj.Xfile = xf;
                obj.ldTarget();
                obj.mix();
            else
                error('xf must be valid wav file')
            end
        end
        function set.Nfile(obj,nf)
            if ischar(nf) && strcmpi(nf(end-3: end), '.wav')
                obj.Nfile = nf;
                obj.ldNoise;
                obj.mix();
            else
                error('nf must be valid wav file')
            end
        end
        function set.SNRdB(obj,snrDB)
            if isnumeric(snrDB)
                obj.SNRdB = snrDB;
                obj.ldSNR();
                obj.mix();
            else
                error('snrDB must be numeric')
            end
        end
        function set.fs(obj,fs)
            if isnumeric(fs)
                obj.fs = fs;
            else
                error('sample rate fs must be numeric')
            end
        end
        
        function ldTarget(obj)
            path = fullfile(obj.DB_dir,obj.speech_dir,obj.Xfile);
            [S, Fsmpl]=audioread(path);    %loads signal
            [~,c] = size(S);
            if c>1  % if wav is stereo, take only the first column
                S = S(:,1);
            end
            S=S-mean(S);
            if Fsmpl ~= obj.fs;
                obj.Prvttarget=resample(S,obj.fs,Fsmpl);
            else
                obj.Prvttarget=S;
            end
        end
        function ldNoise(obj)
            path = fullfile(obj.DB_dir,obj.noise_dir,obj.Nfile);
            [N, Fsmpl]=audioread(path);    %loads signal
            if size(N,2) > 1;
                N = N(:,1); %selects only one of the channels
            end
            N=N-mean(N);
            if Fsmpl ~= obj.fs;
                obj.Prvtnoise=resample(N,obj.fs,Fsmpl);
            else
                obj.Prvtnoise=N;
            end
        end
        
        function ldSNR(obj)
            obj.PrvtSNR=10^(obj.SNRdB/10);
        end
        
        function mix(obj)
            %mix sound + noise
            if (isempty(obj.target)||isempty(obj.noise)||isempty(obj.SNRdB))
                return;
            end
            %% equal size
            Ls=length(obj.target);
            Ln=length(obj.noise);
            
            
            if Ls>Ln
                rpt=fix(Ls/Ln);
                diff=rem(Ls,Ln);
                aux0=floor(rand(1,1)*(Ln-diff));
                obj.Prvtnoise=[repmat(obj.noise,rpt,1);obj.noise(aux0+1:aux0+diff)];
            else
                aux0=floor(rand(1,1)*(Ln-Ls));
                obj.Prvtnoise=obj.noise(aux0+1:aux0+Ls);    %noise file is ramdomly cut
            end
            %% mix at SNR
            [obj.PrvtSmix, obj.Prvttarget, obj.Prvtnoise]=s_and_n(obj.target, obj.noise, obj.SNRdB);
%%%%%%%%%%%% normalization is off so that the speech level is always the same            
%             maxim=max(abs(obj.PrvtSmix));
%             if maxim>1
%                 obj.PrvtSmix=obj.PrvtSmix/maxim;
%                 obj.Prvtnoise=obj.Prvtnoise/maxim;
%                 obj.Prvttarget=obj.Prvttarget/maxim;
%             end
        end
        
        function [srmr0,intel0] = intelsrmr(obj)
            if obj.fs~=8000 && obj.fs~=16000
                Fs1=16000;  %sample frequency for SRMR_CI function
                Xf=resample(obj.Smix,Fs1,obj.fs);
                X=resample(obj.target,Fs1,obj.fs);
            else
                Xf=obj.Smix;
                X=obj.target;
                Fs1=obj.fs;
            end
            srmr0=SRMR_CI(Xf,Fs1,'norm',1);
            
            %% calculates intelligibility
            SRMR_clean=SRMR_CI(X,Fs1,'norm',1);
            srmr_norm=srmr0/SRMR_clean;
            alpha=[-7.4535, 12.1742]'; %from Joao Santos thesis
            intel0=88.92./(1+exp(-(alpha(1)+alpha(2)*srmr_norm)));
        end
        
        function pesq0=pesq_calc(obj)
            score=PESQa(obj.target,obj.Smix,obj.fs);
            pesq0=score;
        end
    end
end

