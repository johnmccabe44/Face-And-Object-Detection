%% Now run through test set to see how many got picked up
clear all; close all;clc;
addpath("library")
imgTraining = imageSet(char(fullfile(pwd, "Data","Training")),'recursive');

predictedNumber=[];
targetNumber=[];
p = 1;

%%
% Run the evaluations
thresholds = [120, 150, 180, 210];
confidences = [0.6, 0.7,0.8]
results=struct([]);ir=1;
for confidence = confidences
    for threshold = thresholds
        for i = 1:length(imgTraining)
            for j = 1:2

                try
                    I = imread(char(imgTraining(i).ImageLocation{j}));                    
                    [IGB, roi] = applyBLOBFilter(I, 'Threshold', threshold, 'Save', false);

                    % Loop over each detected area
                    for ir = 1:size(roi,1)
                        n = getNumber(IGB, roi(ir,:), 'Confidence', confidence, 'Save', false);
                        
                        % do the number
                        if n > 0 && n < 82
                            predictedNumber(p) = n;
                            targetNumber(p) = str2double(imgTraining(i).Description);
                            p = p + 1;
                        end
                        
                    end    
                catch
                    disp(["Error:",char(imgTraining(i).ImageLocation{j})]);
                end
            end
        end

        % Store results
        results(ir).type = "BLOB";
        results(ir).confidence = confidence;
        results(ir).threshold = threshold;
        results(ir).cm = confusionmat(targetNumber,predictedNumber);
        results(ir).acc = sum(diag(results(ir).cm))/sum(results(ir).cm,'all');

    end    
end

%%
confidences = [0.6, 0.7,0.8];
for confidence = confidences
    for i = 1:length(imgTraining)
        for j = 1:1

            try
                I = imread(char(imgTraining(i).ImageLocation{j}));                    
                roi = applyObjectDetector(I)

                % Loop over each detected area
                for ir = 1:size(roi,1)
                    n = getNumber(I, roi(ir,:), 'Confidence', confidence, 'Save', false);

                    % do the number
                    if n > 0 && n < 82
                        predictedNumber(p) = n;
                        targetNumber(p) = str2double(imgTraining(i).Description);
                        p = p + 1;
                    end

                end    
            catch
                disp(["Error:",char(imgTraining(i).ImageLocation{j})]);
            end
        end
    end

    % Store results
    results(ir).type = "OBJECT";
    results(ir).confidence = confidence;    
    results(ir).cm = confusionmat(targetNumber,predictedNumber);
    results(ir).acc = sum(diag(results(ir).cm))/sum(results(ir).cm,'all');
 
end



%%
confidences = [0.6, 0.7,0.8];
for confidence = confidences
    for i = 1:length(imgTraining)
        for j = 1:1

            try
                I = imread(char(imgTraining(i).ImageLocation{j}));                    
                roi = applyObjectDetector(I)

                % Loop over each detected area
                for ir = 1:size(roi,1)
                    n = getNumber(I, roi(ir,:), 'Confidence', confidence, 'Save', false);

                    % do the number
                    if n > 0 && n < 82
                        predictedNumber(p) = n;
                        targetNumber(p) = str2double(imgTraining(i).Description);
                        p = p + 1;
                    end

                end    
            catch
                disp(["Error:",char(imgTraining(i).ImageLocation{j})]);
            end
        end
    end

    % Store results
    results(ir).type = "OBJECT";
    results(ir).confidence = confidence;    
    results(ir).cm = confusionmat(targetNumber,predictedNumber);
    results(ir).acc = sum(diag(results(ir).cm))/sum(results(ir).cm,'all');
 
end

