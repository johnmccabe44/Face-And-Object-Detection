%% Script used for Transfer learning using AlexNet
% get clean environment
clear all; close all; clc;

% get working directory
rootFolder = pwd;

% For reproducability
rng default;

%% download alexnet
net = alexnet;

%% set up training and test datasets
imds = imageDatastore('Faces','IncludeSubfolders',true,'LabelSource','foldernames');
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.8,'randomized');

%% Now remove and configure last 3 layers matching training data
% Use all bar last 3 layers of alexnet
layersTransfer = net.Layers(1:end-3);

% Now adjust fully connected later
numClasses = numel(categories(imdsTrain.Labels))

layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];


%% Augmentation to stop it just learning the images
% not use at first then compare accuracy
inputSize = net.Layers(1).InputSize

% augment training data
pixelRange = [-30 30];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter);

% adjust size of test data
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);

%% Train the new network
options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',10, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');

netTransfer = trainNetwork(augimdsTrain,layers,options);

%% Save network for use later
save netTransfer


%% Evaluation
[predictedLabels,scores] = classify(netTransfer,augimdsValidation);

personLabels = imdsValidation.Labels;
accuracy = mean(predictedLabels == personLabels)

confMatrix = confusionmat(personLabels, predictedLabels);
oosAccuracy = sum(diag(confMatrix))/sum(confMatrix,'all');
display(["Evaluation accuracy of best AlexNet Transfer model:",oosAccuracy]);   

GenerateHeatmap(personLabels, predictedLabels, "CNN", "")