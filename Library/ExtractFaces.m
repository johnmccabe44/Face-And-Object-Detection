function [BBoxes, aPI, howMany, sizes] = ExtractFaces(I, varargin)
    %EXTRACTFACES Identifies faces within an image
    %Parameters:
    %   I - Image containing faces of people in class
    %   Optional arguments
    %   Label: Label identifying the face
    %   Group: Flags the image as a group photo
    %   SaveToDisk: Folder name to save extracted image to
    %   GrayScale: Convert to GrayScale = default is true
    %   Resize: Resize extracted image = default is 92x112, pass empty
    %   array to keep extracted size
    %Returns:
    %   aI: Cell array of the cropped original image with size
    %   aPI: Cell array of processed cropped image
    %   howMany: How many faces were detected

    % Parse Optional Parameters Used In Extraction & Training
    % Default parameters
    grayScale = false;
    resize = [];
    bSave = false;
    showImages = false;

    % Initialise output variables
    BBoxes = [];
    aPI = {};
    howMany = 1;
    sizes = [];
    
      try
        for i = 1:nargin-1
            if strcmp(varargin{i}, "Label")
                label = varargin{i+1};
            end
            % if group photo passed in then no labels must manually detect
            if strcmp(varargin{i}, "Group")
                bGroup = varargin{i+1};
            end
            % Save to disk
            if strcmp(varargin{i}, "SaveToDisk")
                filename = varargin{i+1};
                [filepath, name, ext] = fileparts(filename);
                bSave = true;
            end
            % optionally overwrite grayscale
            if strcmp(varargin{i}, "GrayScale")
                grayScale= varargin{i+1};
            end
            % optionally overwrite resize
            if strcmp(varargin{i}, "Resize")
                resize= varargin{i+1};            
            end  
            % optionally show images as we progress 
            if strcmp(varargin{i}, "ShowImages")
                showImages = varargin{i+1};            
            end         
        end

        % Now extract faces from image
        FaceDetector = vision.CascadeObjectDetector();
        bbox = step(FaceDetector,I);

        % Show images with bounding box
        if showImages
            IFaces = insertObjectAnnotation(I,'rectangle',bbox,'Face');   
            figure
            imshow(IFaces)
            title('Detected faces');     
            drawnow;
            
        end

        % Now loop through each detected face
        for i = 1:size(bbox,1)

            J = imcrop(I, bbox(i,:));    
            
            x = SkinToneTest(J);
            if  x < 0.2   
                % Save images failing the skin tone test
                if bSave
                    dodgyDir = fullfile(pwd,"Dodgy");
                    if ~exist(dodgyDir,'dir')
                        mkdir(dodgyDir)
                    end
                    imwrite(J, fullfile(dodgyDir,strcat(name, "_", num2str(i), ext)));
                end
                
                keep(i) = false;
            else
                K = J;
                
                % convert to grayscale
                if grayScale
                    K = rgb2gray(J);
                end

                % resize
                if resize
                    K = imresize(K, resize);
                end

                % Save to disk
                if bSave
                   [filepath, name, ext] = fileparts(filename);               
                   imwrite(K, fullfile(filepath,strcat(name, "_", num2str(i), ext)));
                end

                % Pass cell array of images back to calling function
                keep(i) = true;
                aPI{howMany} = K;
                sizes(howMany) = size(J,1) * size(J,2);
                howMany = howMany + 1;

            end
        end
        
        % Only keep the qualifying bounding boxes
        BBoxes = bbox(keep',:);
        
        % Adjust back as 1 increment too many
        howMany = howMany - 1;

     catch        
         try
            if bSave
                errorDir = fullfile(pwd,"Error");
                if ~exist(errorDir,'dir')
                    mkdir(errorDir)
                end

                [~,n,~] = fileparts(tempname);
                imwrite(I, fullfile(errorDir,strcat(n, ".jpg")));
            end
         catch
            howMany = 0;
         end
     end
end

