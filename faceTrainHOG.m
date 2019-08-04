%% Script used to Train the classifiers
clear all; close all; clc;

% First extract HOG features; this uses the images in the Faces125x125
% directory. There are subdirectories for Training and Test.
rootFolder = pwd

% For reproducability
rng default;

%% Load the training data into an ImageSet
hogTraining = imageSet(fullfile(rootFolder, 'Faces125x125', 'Training'), 'recursive')

%% Get the training features, labels and target values
[trainingFeatures, trainingLabels, personLabel] = ExtractHOGTrainingFeatures(hogTraining);

%% Set up structs to record results
resultsSVM = struct([]);isvm = 1;
resultsRF = struct([]);ir = 1;
    
%% Get optimised SVM for HOG
tic;
resultsSVM(isvm).optSVM = fitcecoc(trainingFeatures, trainingLabels,'OptimizeHyperparameters','auto',...
   'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
   'expected-improvement-plus'))

resultsSVM(isvm).featureType = 'HOG';
% resultsSVM(isvm).optSVM = fitcecoc(trainingFeatures, trainingLabels);
resultsSVM(isvm).timeToTrainSVM = toc;
resultsSVM(isvm).insLoss = resubLoss(resultsSVM(isvm).optSVM, 'LossFun', 'classiferror');
isvm = isvm + 1;


%%
% CVMdl = crossval(resultsSVM(1).optSVM, 'kfold',5)
% genError = kfoldLoss(CVMdl);
% resultsSVM(1).insLoss = genError

%% Get optimised RF for HOG
numberTrees = [100,300,500];
minLeafSize = [5,10];

for numberTree = numberTrees
    for leafSize = minLeafSize
        tic;    

        % Store metadata 
        resultsRF(ir).featureType = "HOG";
        resultsRF(ir).numberTrees = numberTree;
        resultsRF(ir).leafSize = leafSize;

        % Store model for reuse
        resultsRF(ir).mdl = TreeBagger(numberTree, trainingFeatures, trainingLabels, ...
            'SplitCriterion','gdi', ...
            'MinLeafSize', leafSize, ...
            'Method','classification', ...
            'OOBPrediction', 'on');

        % Store time to train
        resultsRF(ir).timeToTrain = toc;

        % Metrics for accuracy
        predictLabels = oobPredict(resultsRF(ir).mdl);
        confMatrixRF = confusionmat(trainingLabels, predictLabels);

        % Store the out of bag prediction of model
        resultsRF(ir).oobAccuracy = sum(diag(confMatrixRF))/sum(confMatrixRF,'all');

        % increment counter
        ir = ir + 1;
    end
end


