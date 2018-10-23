function p = load_map2(mapFile)
% Load map file from directory
[map_pathname, map_filename, ext] = fileparts(mapFile);
map_filename = strcat(map_filename, ext);

%% Step 1: Read Patient Map file
map_address = fullfile(map_pathname, map_filename);
run(map_address);

%% Step 2: Check MAP for any errors, rate, pulse width, THR, and MCL values are checked here
p = check_map(MAP);