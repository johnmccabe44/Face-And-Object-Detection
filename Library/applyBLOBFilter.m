function [IGB, roi] = applyBLOBFilter(I, varargin)
% Summary: Run BLOB analysis, apply a grayscale threshold and filter on
% minimum width
% Parameters: I - input image
%             Threshold - greyscale threshold
%             Width - minimum width of ROI
%             Save - 1 in 20 images to a BLOB directory

    % Default values
    threshold=210;
    width=100;
    height=20;
    saveImage = false;
    
    % Update based on parameters
    for i = 1:nargin-1
        
        % threshold
        if strcmp(varargin{i}, 'Threshold')
            threshold = varargin{i+1};
        end

        % width
        if strcmp(varargin{i}, 'Width')
            width = varargin{i+1};
        end

        % height
        if strcmp(varargin{i}, 'Height')
            height = varargin{i+1};
        end
        
        % save image with annotated ROI
        if strcmp(varargin{i}, 'Save')
            saveImage = varargin{i+1};
        end

    end
    
    % Apply the threshold
    IG = rgb2gray(I);
    IGB = IG>threshold;
    
    % Run BLOB analysis
    blobAnalyzer = vision.BlobAnalysis('MaximumCount', 500);
    
    % Get the ROI's
    [area, centroids, roi] = step(blobAnalyzer, IGB);
    
    % filter for ROI based on width
    k=zeros(1,size(area,1));
    
    % run through the areas taking out the invalid widths
    for k = 2 : size(area,1) %roi = results.Words{i}
        wordBBox = roi(k,:);
        
        % Show the location of the word in the original image 
        if wordBBox(3)>width && wordBBox(4)>height
            keep(k)=true;
        else
            keep(k)=false;
        end
    end    
    
    % Return just the areas of interest
    roi = roi(keep,:);
    
    % Just save a sample of images
    if saveImage        
        if randi(20) == 10
            % Make the BLOB dir if needed
            destDir = fullfile(pwd,"Data","Output","BLOB");
            if ~exist(destDir, 'dir')
                mkdir(destDir);
            end

            % Add the ROI
            aI = insertObjectAnnotation(double(IGB),'rectangle',roi, 'BLOB ROI');

            % Save it
            [~, n, ~] = fileparts(tempname);
            imwrite(aI, fullfile(destDir,strcat(n,'.jpg')));
        end
    end

end