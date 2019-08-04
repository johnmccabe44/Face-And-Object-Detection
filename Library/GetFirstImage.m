function [imgLocation] = GetFirstImage(rootFolder,imageIndex)
%GETFIRSTIMAGE Summary of this function goes here
%   Detailed explanation goes here

    try
        imgSet = imageSet(char(fullfile(rootFolder, num2str(imageIndex))));
        imgLocation = imgSet(1,1).ImageLocation(1);
    catch
        imgLocation = ""
    end

end

