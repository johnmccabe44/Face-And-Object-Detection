function GenerateHeatmap(personLabels,predictedLabels, modelName, featureType)
%GENERATEHEATMAP Summary of this function goes here
%   Detailed explanation goes here
    % A confusion matrix will be too busy, use heatmap instead
    tbl = table(personLabels, predictedLabels);
    tbl.Properties.VariableNames = {'PersonLabel','PredictedLabels'};
    figure;
    heatmap(tbl, 'PersonLabel', 'PredictedLabels');
    title(["Confusion Matrix (Heatmap) - Model: ", modelName,", Feature Type:", featureType]);    
end

