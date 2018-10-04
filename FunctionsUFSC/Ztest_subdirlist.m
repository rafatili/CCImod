speechdir = fullfile('Sounds','Speech','Alcaim1_');
%speechdir = fullfile('Sounds');
dirinfo = dir(speechdir);
dirinfo(~[dirinfo.isdir]) = [];  %remove non-directories

dirinfo(strcmp({dirinfo.name},'..')) = []; %remove ..

subdirinfo = cell(length(dirinfo),1);
count = 0; %count of files per directory
for K = 1 : length(dirinfo)
    thisdir = dirinfo(K).name;
    aux = [dir(fullfile(speechdir,thisdir, '*.WAV'));...
        dir(fullfile(speechdir,thisdir, '*.wav'))];
    lst = {aux.name}';
    subdirinfo(count+1:count+length(aux)) = fullfile(speechdir,thisdir,lst);
    count = count+length(aux);
end