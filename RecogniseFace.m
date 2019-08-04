function [P] = RecogniseFace(I, featureType, classifierName, varargin)
%RECOGNISEFACE Class of 2019 face recognition function
%   This function uses pre-trained Random Forest & SVM models using HOG &
%   SURF feature extraction methods to identify the faces of the class of
%   2019 MSc Data Science. Passing the featureType of CNN will ignore any
%   values associated with the featureType and use a pre-trained CNN to
%   determine the number of the people in the Image
%Parameters: 
%   I - Image containing the face(s) of the members of the CV class
%   Name, Value pairs
%   featureType: HOG or SURF
%   classifierName: SVM, RF or CNN
%Returns:
%   P - nx3 matrix, number, x-pos, y-pos

    % Set up empty return so can be evaluated
    P = [];

    % Set up default values
    saveCropped = false;
    showImage = false;

     try

        % add path to models so they can load properly
        addpath("Models")

        % add path to models so they can load properly
        if ~exist('Library','dir')
            disp("Warning: Please ensure that the library folder is created with all contents")
            return
        end
        
        addpath("Library")
        
        

        % Get the optional parameters
        for i = 1:nargin-3
            % show images for validation
            if strcmp(varargin{i}, "showImages")
                showImage = varargin{i+1};
            end

            % save cropped faces to temp directory with predicted label
            if strcmp(varargin{i}, "saveCropped")
               saveCropped = true;
               dumpFolder = varargin{i+1};
               if ~exist(dumpFolder,'dir')               
                   mkdir(dumpFolder);
               end

            end

            % save cropped faces to temp directory with predicted label
            if strcmp(varargin{i}, "path")
               filepath = varargin{i+1};
            end
            
        end

        % Throw with an error if parameters are not supported
        if ~ismember(classifierName,{'SVM','RF','CNN'})
            disp("Error: calssifier type not supported");    
            return    
        end

        if ismember(classifierName,{'SVM','RF'}) && ~ismember(featureType,{'HOG','SURF'})
            disp("Error: feature type not supported");    
            return
        end

        % Preprocessing of image is needed reagrdless of what classifier we do
        % Step 1: Crop and resize all faces in the image
        if strcmp(featureType, "HOG")
            resize = [125,125];
        elseif strcmp(featureType, "SURF")
            resize = [];
        else
            resize = [227,227];
        end

        [BBox, aPI, howMany, sizes] = ExtractFaces(I, 'Resize', resize);

        % Step 1a: As there are a number of images that presented false positives
        % assume that if the number of faces identified is greater than 1 but less
        % than 10
        if howMany > 1 && howMany < 10
            [~,idx] = max(sizes);
            aPI = aPI(idx);
            BBox = BBox(idx,:);
        end

        % Set up return matrix with number of faces
        P = zeros(length(aPI),3);

        % if CNN then use CNN model and return, no need to get into feature
        % extractin
        if strcmp(classifierName, "CNN")
            if ~exist('netTransferR2018b.mat','file')
                disp("Warning: Please save the netTransferR2018b.mat file to either the working directory or the models sub-directory")
                return;
            end
            load('netTransferR2018b.mat');
        end

        % Load the hog/ svm classifier
        if strcmp(classifierName, "SVM") && strcmp(featureType, "HOG")
            if ~exist('resultsHOGSVM.mat','file')
                disp("Warning: Please save the resultsHOGSVM.mat file to either the working directory or the models sub-directory")
                return;
            end        
            load('resultsHOGSVM.mat');
            mdl = resultsSVM(1).optSVM;
        end

        % Load the hog/ rf classifier
        if strcmp(classifierName, "RF") && strcmp(featureType, "HOG")
            if ~exist('HOGRF.mat','file')
                disp("Warning: Please save the HOGRF.mat file to either the working directory or the models sub-directory")
                return;
            end          
            load('HOGRF.mat');
            mdl = mdlHOGRF;
        end

        % Load the surf/ svm classifier
        if strcmp(classifierName, "SVM") && strcmp(featureType, "SURF")
            if ~exist('resultsSURFSVM1000.mat','file')
                disp("Warning: Please save the resultsSURFSVM1000.mat file to either the working directory or the models sub-directory")
                return;
            end        
            load('resultsSURFSVM1000.mat')

            if ~exist('bag1000.mat','file')
                disp("Warning: Please save the bag1000.mat file to either the working directory or the models sub-directory")
                return;
            end        
            load('bag1000.mat')

            mdl = resultsSVM(1).optSVM;
        end

        % Load the surf/ rf classifier
        if strcmp(classifierName, "RF") && strcmp(featureType, "SURF")
            if ~exist('SURFRF.mat','file')
                disp("Warning: Please save the SURFRF.mat file to either the working directory or the models sub-directory")
                return;
            end        
            load 'SURFRF.mat'

            if ~exist('bag1000.mat','file')
                disp("Warning: Please save the bag1000.mat file to either the working directory or the models sub-directory")
                return;
            end    
            load 'bag1000.mat'
            mdl = mdlSURFRF;
        end

        % Now lets loop through the images in the processed image array and get
        % predictions for each one and load into return matrix
        for i = 1:length(aPI)


            % extract features of resized grapyscale image ...
            if strcmp(featureType, "HOG")
                queryFeatures = extractHOGFeatures(aPI{i});            
            elseif strcmp(featureType, "SURF")
                queryFeatures = encode(bag,aPI{i});
            end

           % ... and run a predict on it
           if strcmp(featureType, "HOG") || strcmp(featureType, "SURF")
               predictedPerson = predict(mdl, queryFeatures);
           else
               cI = aPI{i};
               predictedPerson = string(classify(netTransfer,cI));
           end

           P(i,1) = str2double(predictedPerson);

           % save to temp folder
           if saveCropped

              % check destination directory exists
              destDir = fullfile(dumpFolder,string(predictedPerson));
              if ~exist(destDir{1},'dir')
                  mkdir(destDir{1})
              end

              [~,n,~] = fileparts(tempname);           
              imwrite(aPI{i}, char(fullfile(destDir{1},strcat(n,".jpg"))));

           end

           % Now get original bounding box
           boundBox = BBox(i,:);

           % Return x+.5*width/ y+.5*height
           P(i,2) = floor(boundBox(1)+(boundBox(3)*0.5));
           P(i,3) = floor(boundBox(2)+(boundBox(4)*0.5));

        end

        % Show image as validation
        if showImage
            mI = insertObjectAnnotation(I, 'rectangle', BBox, P(:,1),'FontSize',36);
            figure;
            imshow(mI);
            title("Detected faces annotated with numbers");
        end
    catch
        
        
        disp(["error",featureType,classifierName]);
    end

end

