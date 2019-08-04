function [bbox, aI] = applyObjectDetector(I, varargin)
    % Summary: applies the pre-trained object detector to the supplied
    % image and returns the ROI

    % Update based on parameters
    saveImage = false;
    minarea=100;
    maxarea=9999;
    
    aI = I;
    
    for i = 1:nargin-1
        % save image with annotated ROI
        if strcmp(varargin{i}, 'Save')
            saveImage = varargin{i+1};
        end
        % min area
        if strcmp(varargin{i}, 'MinArea')
            minarea = varargin{i+1};
        end
        % max area
        if strcmp(varargin{i}, 'MaxArea')
            maxarea = varargin{i+1};
        end
        
    end
    
    % load model - needs to be saved in models directory
    if exist('Models','dir')
        addpath('Models');
    end
    
    if ~exist('whiteCardDetector.xml', 'file')
        disp("Please save whiteCardDetector.xml to either working directory or models sub-directory")
        return
    end
    
    % load model
    detector = vision.CascadeObjectDetector("whiteCardDetector.xml");
    
    % return found area
    bbox = step(detector, I);
    
    if size(bbox,1) < 1        
        return
    end
        
    % basic area check
    for ib = 1:size(bbox)
        area = bbox(ib,3)*bbox(ib,4);        
        if sqrt(area) > minarea && sqrt(area) < maxarea
            keep(ib) = true;
        else
            keep(ib) = false;
        end
        
        % now reduce the size so that we lose the fuzzy edges        
        w=bbox(ib,3);h=bbox(ib,4);x1=bbox(ib,1)+floor(w/4);y1=bbox(ib,2)+floor(h/4);
        try
            bbox(ib,:) = [x1, y1, floor(w/2), floor(h/2)];                        
        catch
            x=1;
        end
    end
    
    bbox = bbox(keep,:);
    aI = insertObjectAnnotation(I,'rectangle',bbox, 'Detected Region');
    
    % Just save a sample of images
    if saveImage        
        if randi(20)
            % Make the BLOB dir if needed
            destDir = fullfile(pwd,"Data","Output","Object");
            if ~exist(destDir, 'dir')
                mkdir(destDir);
            end

            % Add the ROI
            aI = insertObjectAnnotation(I,'rectangle',bbox, 'Detected Region');

            % Save it
            [~, n,e] = fileparts(tempname);
            imwrite(aI, fullfile(destDir,strcat(n,'.jpg')));
        end
    end
end