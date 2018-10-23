function mapFile = chooseMAP()
%% choose map file
olddir = pwd; %
fpath = mfilename('fullpath'); % full path of the current function file
[pathstr] = fileparts(fpath); % directory of the current function file

[pathstr] = fileparts(pathstr); % root directory CCIMod

cd(fullfile(pathstr,'MAPs'))
[map_filename, map_pathname] = uigetfile('*.m', 'Select a patient map file');

mapFile = fullfile(map_pathname, map_filename);

if isequal(map_filename,0)
    disp('Please load a patient map file before proceeding')
else
    disp(['Map file loaded is: ', mapFile])
end

cd(olddir) %