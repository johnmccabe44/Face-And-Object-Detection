function [personLabels, predictedLabels, missClassifications] = EvaluateHOG(test, mdl, bag)
%EVALUATEHOG Summary of this function goes here
%   Detailed explanation goes here

    % temp vars
    iImage = 1
    personLabels = [];
    predictedLabels = [];
    missClassifications = {};imiss=1;

    % loop over each test image
    for person=1:length(test)                
        for j = 1:test(person).Count

            % Evaluate model
            queryImage = read(test(person),j);
            queryFeatures = encode(bag, queryImage);

            % Convert to doubles for comparison
            personLabels(iImage) = str2double(test(person).Description);
            predictedLabels(iImage) = str2double(predict(mdl,queryFeatures));

            % Get all images that failed so we can display and show
            if personLabels(iImage) ~=  predictedLabels(iImage)

                missClassifications{imiss,1} = test(1,person).ImageLocation(j);
                missClassifications{imiss,2} = personLabels(iImage);                       
                missClassifications{imiss,3} = predictedLabels(iImage);
                imiss = imiss + 1;

            end

            iImage = iImage + 1;
        end
    end
