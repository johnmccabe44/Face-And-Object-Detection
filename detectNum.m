function [number] = detectNumber(fileName,varargin)
%DETECTNUMBER Summary of this function goes here
%   Detailed explanation goes here

    % default parameters
    threshold=150;
    confidence=0.5;
    returnType='one';
    
    % return matrix
    number=[];c=1;
    
    % local variables
    cellImages = {};
    
    % optional parameters
    for i = 1:nargin-1
        if strcmp(varargin{i}, "ReturnType")
            returnType = varargin{i+1};
        end        
        if strcmp(varargin{i}, "VideoStill")
            vI = varargin{i+1};
        end
    end
    
    try
        % Load the image
        [p,n,e] = fileparts(char(fileName));

        % Check its a supported file format
        if ismember(lower(e),{'.jpg','.jpeg','.png','.asf','.asx','.avi','.m4v','.mj2','.mp4','.mpg','.wmv','.mov','.avi'}) || isempty(p)
            % do nothing
        else
            disp("Warning: filetype not supported, please refer to README.txt for supported file formats");
            return
        end
        
        % If still then just read it
        if ismember(lower(e),{'.jpg','.jpeg','.png'})
            I = imread(char(fileName));            
        end
        
        % The this is a single frame video
        if isempty(p)
            I = vI;
        end
        
        if ismember(lower(e),{'.asf','.asx','.avi','.m4v','.mj2','.mp4','.mpg','.wmv','.mov','.avi'})          
            % push into a videoreader
            videoReader = VideoReader(char(fileName));
            
            % save down the images
            images = read(videoReader);
            
            % save 10%
            n=[];im=1;
            inc = floor(size(images,4)/10);            
            for j = 1:inc:size(images,4)
                vI = images(:,:,:,j);
                n(im) = detectNum('','VideoStill',vI);                
                im=im+1;
            end
            % Get the frequencies
            tNumbers = tabulate(n);
            [~,idx] = max(tNumbers(:,2));
            
            % return the most frequent number
            number = tNumbers(idx,1);
            return
        end

        % If here single image
        % apply region detector
        [roi,aI] = applyObjectDetector(I);
        if roi
            for iobj = 1:size(roi,1)

                % get the number
                n = getNumber(aI, roi(iobj,:), 'Confidence', confidence);
                if (n>0) && (n<82)
                    if strcmp(lower(returnType),'one')
                        number=n;
                    else
                        number(c) = n;c=c+1;
                    end                        
                else
                    if strcmp(lower(returnType),'one')
                        number=-2;
                    else
                        number(c) = -1;c=c+1;
                    end 
                end
            end
        else
            number = -1;
        end
    catch
        number = -9;
    end
end

