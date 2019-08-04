function [trainingFeatures, trainingLabels, personLabel] = ExtractHOGTrainingFeatures(training)
%EXTRACTSURFTRAININGFEATURES Summary of this function goes here
%   Detailed explanation goes here
    person = 1; 
    [hogFeature, ~] = extractHOGFeatures(read(training(person),1)); 
    trainingFeatures = zeros(size(training,2)*training(1).Count,size(hogFeature,2)); 

    % feature counter
    featureCount = 1;

    % loop through training set producing the trainingFeatures
    for i=1:size(training,2)
        for j = 1:training(i).Count
            trainingFeatures(featureCount,:) = extractHOGFeatures(read(training(i),j));
            trainingLabels{featureCount} = training(i).Description;
            featureCount = featureCount + 1;
        end
        personLabel{i} = training(i).Description;
    end                
end