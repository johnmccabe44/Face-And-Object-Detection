function [predictedNumber] = getNumber(I, roi, varargin)
    % Summary: Gets the number from the passed roi
    % Parameters: I - Image
    %             roi - region of interest
    %             Confidence - 0-1 confidence level of detected character
    
    
    confidence = 0.75;
    saveImage = false;
    % Update based on parameters
    for i = 1:nargin-2
        
        % save image with annotated ROI
        if strcmp(varargin{i}, 'Confidence')
            confidence = varargin{i+1};
        end
        
        % save image with annotated ROI
        if strcmp(varargin{i}, 'Save')
            saveImage = varargin{i+1};
        end
    end
    
    % Get the roi - should only be one of these 
    Ibox = I(roi(2):roi(2)+roi(4)-1,roi(1):roi(1)+roi(3)-1);
    
    % resize to concentrate image
    % Ibox = imresize(Ibox,0.5);
    
    % now get the results
    ocrResults = ocr(Ibox, ...
                    'CharacterSet','0123456789', ...
                    'TextLayout','block');
    
    % filter the final results on confidence
    conf = (ocrResults.CharacterConfidences>confidence);

    if sum(conf) > 0
        % Keep all high confidence text and throw together
        try
            predictedNumber = str2double(deblank({ocrResults.Text(conf)}));
        catch
            predictedNumber = -3;    
        end
    else
        predictedNumber = -1;
    end    
    
    % Just save a sample of images
    if saveImage        
        if randi(20) == 10
            % Make the BLOB dir if needed
            destDir = fullfile(pwd,"Data","Output","OCR");
            if ~exist(destDir, 'dir')
                mkdir(destDir);
            end

            % Add the ROI
            aI = insertObjectAnnotation(double(I),'rectangle',roi, num2str(predictedNumber));

            % Save it
            [~,n,e] = fileparts(tempname);
            imwrite(aI, fullfile(destDir,strcat(n,'.jpg')));
        end
    end
    
end