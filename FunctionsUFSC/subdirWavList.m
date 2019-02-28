function subdir = subdirWavList(directory)
%returns a cell array with the path of all .wav and .WAV files
%in the directory and its subdirectories

dirinfo = dir(directory);
dirinfo(~[dirinfo.isdir]) = [];  %remove non-directories

dirinfo(strcmp({dirinfo.name},'..')) = []; %remove ..

subdir = cell(length(dirinfo),1);
count = 0; %count of files per directory
for K = 1 : length(dirinfo)
    thisdir = dirinfo(K).name;
    aux = [dir(fullfile(directory,thisdir, '*.WAV'));...
        dir(fullfile(directory,thisdir, '*.wav'))];
    lst = {aux.name}';
    lst = unique(lst);
    subdir(count+1:count+length(lst)) = fullfile(directory,thisdir,lst);
    count = count+length(aux);
end