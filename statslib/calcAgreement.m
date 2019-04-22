function agree = calcAgreement(X,Y,varargin)
% calculates the percent agreement between the columns of X and Y
% varargin(1) is the absolute value of the limit error. Default is 1.
% Loizou, Speech Enhancement (2013) section 10.4.1

% By Rafael Chiea, 22/04/2019

if nargin == 3;
    lim = vararguin{1};
else
    lim = 1;
end

[r,~] = size(X);

dXY = abs(X-Y);

count = sum(dXY <= 1);
agree = count/r*100; 
