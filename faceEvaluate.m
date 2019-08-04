%% Load the models and set the primary one
% Get the relevant test ImageSet
% First extract HOG features; this uses the images in the Faces125x125
% directory. There are subdirectories for Training and Test.
rootFolder = pwd;
addpath("Models");

%% Load the Models - HOG - SVM
load resultsHOGSVM;
mdl = resultsSVM(1).optSVM;

% Load the training data into an ImageSet
hogTest = imageSet(fullfile(rootFolder, 'Faces125x125', 'Test'), 'recursive');
% Get the original labels, predicted labels and the missclassifications
[personLabels, predictedLabels, missClassifications] = EvaluateHOG(hogTest, mdl)

% Confusion Matrix
confMatrix = confusionmat(personLabels, predictedLabels);
oosAccuracy = sum(diag(confMatrix))/sum(confMatrix,'all');
display(["Evaluation accuracy of best RF model:",oosAccuracy]);

% Get the heatmap for report
GenerateHeatmap(personLabels', predictedLabels', "SVM", "HOG")
% and examples of the miss classified images
ShowMisclassifications(missClassifications, fullfile(rootFolder,"Faces125x125","Test"))

%% Load the Models - HOG - RF
load resultsHOGRF;
mdl = resultsRF(5).mdl;

% Get the original labels, predicted labels and the missclassifications
[personLabels, predictedLabels, missClassifications] = EvaluateHOG(hogTest, mdl)

% Confusion Matrix
confMatrix = confusionmat(personLabels, predictedLabels);
oosAccuracy = sum(diag(confMatrix))/sum(confMatrix,'all');
display(["Evaluation accuracy of best RF model:",oosAccuracy]);

% Get the heatmap for report
GenerateHeatmap(personLabels', predictedLabels', "RF", "HOG")
% and examples of the miss classified images
ShowMisclassifications(missClassifications, fullfile(rootFolder,"Faces125x125","Test"))


%% Load the Models - SURF - SVM
load resultsSURFSVM1000
mdl = resultsSVM(1).optSVM;

% additionally need the bag to encode against
load bag1000

% Load the training data into an ImageSet
surfTest = imageSet(fullfile(rootFolder, 'Faces125x125', 'Test'), 'recursive');

% Get the original labels, predicted labels and the missclassifications
[personLabels, predictedLabels, missClassifications] = EvaluateSURF(surfTest, mdl, bag)

% Confusion Matrix
confMatrix = confusionmat(personLabels, predictedLabels);
oosAccuracy = sum(diag(confMatrix))/sum(confMatrix,'all');
display(["Evaluation accuracy of best RF model:",oosAccuracy]);

% Get the heatmap for report
GenerateHeatmap(personLabels', predictedLabels', "SVM", "SURF")
% and examples of the miss classified images
ShowMisclassifications(missClassifications, fullfile(rootFolder,"Faces125x125","Test"))

%% Load the Models - SURF - RF
load resultsSURFRF1000
mdl = resultsRF(5).mdl;

% Get the original labels, predicted labels and the missclassifications
[personLabels, predictedLabels, missClassifications] = EvaluateSURF(surfTest, mdl, bag)

% Confusion Matrix
confMatrix = confusionmat(personLabels, predictedLabels);
oosAccuracy = sum(diag(confMatrix))/sum(confMatrix,'all');
display(["Evaluation accuracy of best RF model:",oosAccuracy]);

% Get the heatmap for report
GenerateHeatmap(personLabels', predictedLabels', "RF", "SURF")
% and examples of the miss classified images
ShowMisclassifications(missClassifications, fullfile(rootFolder,"Faces125x125","Test"))
