%% Script to preprocess faces
% Description: Cycle through the images, extract faces, resize and
% gray scale saving to faces directory for training

% Clear environement
clc;clear all;close all;
addpath("library");
addpath("models");

%% Constants
imagesFolder = replace(pwd,'FaceRecognition','Images');
groupFolder = fullfile(pwd, 'cam group');


files = dir(imagesFolder);
dirNames = {files([files.isdir]).name};
dirNames = dirNames(~ismember(dirNames,{'.','..'}));

%% Loop through image folders
for i = 1:size(dirNames,2)        

    disp(dirNames(i));

    % create the image set
    imgSet = imageSet(char(fullfile(imagesFolder,dirNames(i))));

    % get the result
    for j = 1:imgSet.Count              

        % get image and read in
        imgLocation = char(imgSet.ImageLocation(j));                
        I = imread(imgLocation);

        % get destination for cropped images
        newFolderName = replace(imgLocation, "Images", "Faces");
        hogFolderName = replace(imgLocation, "Images", "Faces125x125");

        % make sure destination folder exists
        if MakeFolder(newFolderName) && MakeFolder(hogFolderName)            
            %   Label: Label identifying the face
            %   Group: Flags the image as a group photo
            %   SaveToDisk: Folder name to save extracted image to
            %   GrayScale: Convert to GrayScale = default is true
            %   Resize: Resize extracted image = default is 92x112, pass empty
            %   array to keep extracted size
            [aPI, aI, howMany, sizes] = ExtractFaces(I, ...
                                                    'SaveToDisk', newFolderName, ...
                                                    'GrayScale', false, ...                                                        
                                                    'ShowImages', false);

            [aPI, aI, howMany, sizes] = ExtractFaces(I, ...
                                                    'SaveToDisk', hogFolderName, ...
                                                    'GrayScale', false, ...                                                        
                                                    'Resize', [125 125], ...
                                                    'ShowImages', false);
        else

            % Give feedback on folder creation errors
            disp(["Error: cannot make folder:", netFolderName])
        end
    end
end

%% Manualy review the directories - remove anything that is incorrect
% Manually cleaned
% Reviewed how many images there were for each number - majority had ~15 a
% few with less so created produced from videos so there is a minimum of 
% 15 images per number

%% Create Scatter of extracted group photos
imgset = imageSet(char(groupFolder))

ii = 1;
for i = 1:length(imgset)
    for j = 1:imgset(1,i).Count
        I = imread(char(imgset(1,i).ImageLocation(j)));
        [rows(ii), cols(ii), dims] = size(I);
        ii = ii + 1;
    end
end

figure;
scatter(rows, cols);
xlabel("Size of x")
ylabel("Size of y")
title("Scatter plot of dimensions of extracted group faces");



