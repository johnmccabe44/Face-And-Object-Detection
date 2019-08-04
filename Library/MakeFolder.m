function [result] = MakeFolder(fullpath)
%MAKEFOLDER Summary of this function goes here
%   Detailed explanation goes here

    [filepath,name,ext] = fileparts(fullpath);

    if exist(filepath,'dir')
        result = true;
    else
        try
            mkdir(filepath)
            result = true;
        catch
            result = false;
        end
    end
    
end

