function subdir = subdirList(directory)
%returns a cell array with the path of all .wav and .WAV files
%in the directory and its subdirectories

dirinfo = dir(directory);
dirinfo(~[dirinfo.isdir]) = [];  %remove non-directories

dirinfo(strcmp({dirinfo.name},'.')) = []; %remove .
dirinfo(strcmp({dirinfo.name},'..')) = []; %remove ..

subdir = cell(length(dirinfo),1);
Ld = length(dirinfo);
for K = 1 : Ld
    thisdir = dirinfo(K).name;
    subdir{K} = fullfile(directory,thisdir);
end