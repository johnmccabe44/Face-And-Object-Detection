function ShowMisclassifications(missClassifications, imageFolder)
%SHOWMISCLASSIFICATIONS Summary of this function goes here
%   Detailed explanation goes here
    figure;
    if size(missClassifications,1) > 4
        lim = 4;
    else
        lim= size(missClassifications,1)
    end
    for ix = 1:lim
        % Original Image
        oImage = imread(char(missClassifications{ix,1}));
        pos = (2*(ix-1))+1;
        subplot(lim,2,pos);        
        imshow(oImage);
        title(["Miss-classified image:",missClassifications{ix,2}]);
        
        % Sample of Misclassified Image
        imgSet = imageSet(char(fullfile(imageFolder,num2str(missClassifications{ix, 3}))));        
        nImage = imread(imgSet(1).ImageLocation{1});        
        pos = (2*(ix-1))+2;
        subplot(lim,2,pos);
        imshow(nImage);
        title(["Example of mistaken image",missClassifications{ix,3}]);

    end
end

