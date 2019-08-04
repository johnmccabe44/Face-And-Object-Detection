%% Script to split training and evaluation data.
% Physically move the files into a Training/ Evaluation Folder so that it
% is easy to re-run models
clc; close all; clear all;

rng default;

% Get the original images folder
imagesFolder = replace(pwd, 'OCR', 'Images');

faceDatabase = imageSet(imagesFolder, 'recursive');

% now get the training and evaluation
[training,test] = partition(faceDatabase,[0.6 0.4]);

% Create a training and test folder under the root
trainingDir = fullfile(pwd, "Data", "Training");
if ~exist(trainingDir,'dir')
    mkdir(trainingDir);
end

testDir = fullfile(pwd, "Data", "Test");
if ~exist(testDir,'dir')
    mkdir(testDir);
end


% now pysically move the images to a training evaluation folder
for i = 1:length(training)
    for j = 1:training(i).Count

        imgLocation = training(i).ImageLocation(j);

        [~, name, ext] = fileparts(imgLocation{1});
        newImgLocation = fullfile(trainingDir, training(i).Description, strcat(name,ext));

        [path, ~, ~] = fileparts(newImgLocation);
        if ~exist(path,'dir')      
            mkdir(path)
        end

        copyfile(imgLocation{1}, newImgLocation);
    end
end

% now pysically move the images to a training evaluation folder
for i = 1:length(test)
    for j = 1:test(i).Count

        imgLocation = test(i).ImageLocation(j);

        [~, name, ext] = fileparts(imgLocation{1});
        newImgLocation = fullfile(testDir,test(i).Description, strcat(name,ext));


        [path, ~, ~] = fileparts(newImgLocation);
        if ~exist(path,'dir')      
            mkdir(path)
        end

        copyfile(imgLocation{1}, newImgLocation);
    end
end
