function [trainingFeatures, trainingLabels, personLabel, bag] = ExtractSURFTrainingFeatures(training, VocabularySize)
%EXTRACTSURFTRAININGFEATURES Summary of this function goes here
%   Detailed explanation goes here
    
    bag = bagOfFeatures(training,'VocabularySize',VocabularySize)

    trainingFeatures = zeros(size(training,2)*training(1).Count,VocabularySize); 
    featureCount = 1; 
    for i=1:size(training,2)
        for j = 1:training(i).Count
            trainingFeatures(featureCount,:) = encode(bag, read(training(i),j));
            trainingLabels{featureCount} = training(i).Description;
            featureCount = featureCount + 1;
        end
        personLabel{i} = training(i).Description;
    end
    
end

