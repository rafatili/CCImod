%%init.m
% function to initialize path and adapt to ML version
% run this before start testing

%restore defaut path
restoredefaultpath;

% loads directories to path
addpath(genpath(strcat(pwd,filesep)));
rmpath(genpath(strcat(pwd,filesep,'.git')));

% % check matlab version
% mv = version;
% mv = str2double(mv(1:3));
% 
% if mv < 9.1
%    addpath(strcat(home,'ML_version_comp',filesep));
% end
% cd('online_proc')
% clearvars;

clc;