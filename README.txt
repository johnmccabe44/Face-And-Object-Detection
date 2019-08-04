Instructions
*********************************************************

Source code loaction: https://cityuni-my.sharepoint.com/:u:/g/personal/john_mccabe_city_ac_uk/EW3UcN17IJtHoSLPQxIszuYB2ucBaghz8nWDnNJ119N__g?e=2hmazM


Prerequisites
---------------------------------------------------------
Computer Vision System Toolbox                        Version 8.2         (R2018b)
Deep Learning Toolbox                                 Version 12.0        (R2018b)
Image Processing Toolbox                              Version 10.3        (R2018b)
Parallel Computing Toolbox                            Version 6.13        (R2018b)
Statistics and Machine Learning Toolbox               Version 11.4        (R2018b)


Installation
---------------------------------------------------------
Unzip contents from source file Code.zip to clean directory


Usage
---------------------------------------------------------
Function: RecogniseFace.m
Prototype: P = RecogniseFace(I, featureType, classifierName)
Dependencies:
Models/netTransferR2018b.mat
Models/HOGRF.mat
Models/HOGSVM.mat
Models/bag1000.mat
Models/SURFRF.mat
Models/SURFSVM.mat
library/ExtractFaces.m

Input parameters:
I	m x n x 3 matrix, the result of calling imread on RGB Image
featureType	'HOG' or 'SURF' or ''
classifierName	'SVM' or 'RF' or 'CNN

Returns: P - n x 3 matrix, where: 
P(n,1)	unique number of person identified
P(n,2) & P(n,3)	x,y co-ordinates of centre face region

Example: 
I = imread(path_to_image);
P = RecogniseFace(I, 'HOG', ‘SVM’)

Function: detectNum.m
Prototype: n = detectNum(path_to_file)

Dependencies:
Models/whiteCardDetector.xml 
library/ applyObjectDetector.m
library/getNumber.m

Input parameters: 
filename	filename of image or video file

Name, Value parameters:
‘ReturnType’	'one' - returns number on first white square found
'all' - returns numbers from all white cards found
Default – ‘one’

Returns:
Number	N x 1 matrix of valid integers identified from a white square if exists
-1 if no white square was found
-2 an invalid number was found

Example(s):
%Returns number from still
n=detectNum(‘path_to_image.jpg’)
%Returns number from video
n=detectNum(‘path_to_image.avi’)
%Returns all white card numbers found
n=detectNum(‘path_to_image.jpg’, ‘ReturnType’,’all’)




Code.zip contents
---------------------------------------------------------

-- Face recognition scripts --
[root]/facePreprocess.m - preprocessing images; loops through the raw image folders, using Viloa-Jones filters to identify and extract faces.
[root]/faceSplit.m - separates the face recognition data set into training and test, saving partitioned files to discreet folders.
[root]/faceTrainAndEvaluteCNN.m - downloads AlexNet, updates last three layers and trains with Face training data, saving resulting model/ additionally runs validation, producing eval and test metrics
[root]/faceTrainHOG.m - trains the SVM & RF models using HOG features, sets up grid search of hyperparameters and stores results for review and model selection
[root]/faceTrainSURF.m - trains the SVM & RF models using SURF features, sets up grid search of hyperparameters and stores results for review and model selection
[root]/faceEvaluate.m - evaluates the features x classifer, i.e. all four combinations, printing accuracies, creating confusion matrix (heatmaps) and misclassifications
[root]/faceGroupTest.m - randomly chooses a group photo and runs the Recognise face function
[root]/RecogniseFace.m - final delieverable FaceRecognition function

-- Dectect number scripts --
[root]/ocrSplit.m - separates the detect number data set into training and test, saving partitioned files to discreet folders.
[root]/ocrTrainObjectIdentifier.m - creates the ObjectCascadeDetector
[root]/ocrEvalute.m - sets up grid search of hyperparameters and stores results for review and model selection
[root]/ocrTest.m - tests the detectNum function against an imageSet, using results for test accuracies
[root]/detectNum.m - final deliverable detectNum function

------------------------- LIBRARY FUNCTIONS -------------------------------
[root]/Library/ExtractFaces.m - identifies face in and image and extracting, either saving or returning as an output parameter
[root]/Library/SkinToneTest.m - checks for presence of skin tone in an image, returning the mean of sum found pixels
[root]/Library/ExtractHOGTrainingFeatures.m - extracts and creates training data of HOG features
[root]/Library/ExtractSURFTrainingFeatures.m - extracts and creates training data of SURF features
[root]/Library/EvaluateHOG.m - runs through a dataset applying HOG feature extraction and using passed model to get predictions
[root]/Library/EvaluateSURF.m - runs through a dataset applying SURF feature extraction and using passed model to get predictions
[root]/Library/GenerateHeatmap.m - produces Heatmap from two arrays, target and predicted
[root]/Library/ShowMisclassifications.m - creates montages of misclassifications

-- library functions for detectNum --
[root]/Library/preprocess.m - script for applying several optional transformations on in input image
[root]/Library/applyBLOBFilter.m - applys a BLOB filter to an image, returning image and bounding boxes
[root]/Library/applyObjectDetector.m - uses a detetor and model to identify the white square in an image
[root]/Library/getNumber.m - applys ocr to an image specifically an ROI

-- Misc functions --
[root]/Library/MakeFolder.m - general purpose function to make folder if it doesnt exist
[root]/Library/prepConvertVideo.m - batch conversion of videos to stills

------------------------- MODELS ------------------------------------------
-- Face recognition models --
[root]/Models/netTransferR2018b.mat - AlexNet/ Transfer learning model
[root]/Models/resultsHOGRF.mat - HOG RF model
[root]/Models/HOGSVM.mat - HOG SVM model
[root]/Models/bag1000.mat - bag of features, used to encode for subsequent models
[root]/Models/resultsSURFRF1000.mat - SURF-1000 RF model
[root]/Models/SURFSVM.mat - SURF-1000 SVM model

-- Detect number models --
[root]/Models/whiteCardDetector.xml - Cascade Object Detector Model




