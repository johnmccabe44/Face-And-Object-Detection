%% Script to create object identifier
clear all; close all; clc;
% get the datastore and manually label up the training images
imds = imageDatastore(fullfile(pwd,"data","training"),'IncludeSubfolders', true);

%labourious lableing exercise

%% Training cascader
% load model - needs to be saved in models directory
if exist('Models','dir')
    addpath('Models');
end

% Image Labeler export
load 'rectWhiteCardLabels.mat'

% Get the correct format for the trainer
positiveInstances = table('Size',[749 2],'VariableTypes',{'cell','cell'}, 'VariableNames',{'imageFilename','whiteCard'});
for i = 1:749
    positiveInstances.imageFilename{i} = gTruth.DataSource.Source{i};
    positiveInstances.whiteCard{i} = gTruth.LabelData.WhiteSquareR{i};
end

%%
negativeFolder = "../Images/cam group";
negativeImages = imageDatastore(negativeFolder);

%%
trainCascadeObjectDetector('whiteCardDetector.xml',positiveInstances, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',5);


