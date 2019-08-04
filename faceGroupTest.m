% for reproducability
rng default;

rootFolder = pwd;


featureTypes = {'HOG','SURF'}
classifiers = {'SVM','RF'}
for featureType = featureTypes
    for classifier = classifiers
        % copy ground truth image to destination directory
        grdImages = imageSet(char(fullfile(rootFolder, "Images")),'recursive');
        for i = 1:length(grdImages)
            destDir = fullfile(pwd,"GroupEvaluate",featureType,classifier,grdImages(i).Description); 
           if ~exist(destDir,'dir')
               mkdir(destDir)
           end
           copyfile(grdImages(i).ImageLocation{1},fullfile(destDir,"groundTruth.jpg"))

        end

        grpSet = imageSet(char(fullfile(pwd, "Images", "cam group")));
        % randomly select an image
        i = randi([1 grpSet.Count],1,1)
        I = imread(grpSet.ImageLocation{i});
        P = RecogniseFace(I, featureType, classifier, ...
                            'showImages', true, ...
                            'saveCropped', fullfile(pwd,"GroupEvaluate",featureType,classifier));
    end
end
%%
% first put a groun truth image in the 
featureType = "";
classifier = "CNN";

% copy ground truth image to destination directory
grdImages = imageSet(char(fullfile(pwd, "Images")),'recursive');
for i = 1:length(grdImages)
    destDir = fullfile(pwd,classifier,grdImages(i).Description); 
   if ~exist(destDir,'dir')
       mkdir(destDir)
   end
   copyfile(grdImages(i).ImageLocation{1},fullfile(destDir,"groundTruth.jpg"))

end

grpSet = imageSet(char(fullfile(pwd, "Images", "cam group")));
% randomly select an image
i = randi([1 grpSet.Count],1,1)
I = imread(grpSet.ImageLocation{i});
P = RecogniseFace(I, featureType, classifier, 'showImages', true, 'saveCropped', true);

%% Montages
mset = imageSet(char(fullfile(pwd,"CNN","21")));
montage(mset.ImageLocation, 'Size',[1,4])
