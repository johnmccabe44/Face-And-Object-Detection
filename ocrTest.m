clear all; clc; close all;

predictedNumber=[];
targetNumber=[];
p=1;

% set the image set
imgTest = imageSet(char(fullfile(pwd,"Data","Test")),'recursive');

% loop over each image
for i = 1:length(imgTest)
    for j = 1:imgTest(i).Count
        n=str2double(imgTest(i).Description);
        if 1

            %try
                predictedNumber(p) = detectNumber(imgTest(i).ImageLocation(j));
                targetNumber(p) = str2double(imgTest(i).Description);
                
                if predictedNumber(p) ~= targetNumber(p)
                    e=1;
                end
                p = p + 1;
            %catch
            %    disp(["Error:",char(imgTraining(i).ImageLocation{j})]);
            %end
        end
    end
end

%% Store results
cm = confusionmat(targetNumber,predictedNumber);
acc = sum(diag(cm))/sum(cm,'all');


%% Get a list of all images that failed, move to individual folders
% for ease of analysis

imgLocations = [imgTest.ImageLocation];
failedImg = imgLocations((predictedNumber~=targetNumber));

for i =1:length(failedImg)
    [p,n,e] = fileparts(failedImg{i});
    flds = split(p,"\");
    f(i) = flds(length(flds));
    
    if ~exist(fullfile(pwd,"Data","Failed",f(i)),'dir')
        mkdir(fullfile(pwd,"Data","Failed",f(i)));
    end
    copyfile(failedImg{i},fullfile(pwd,"Data","Failed",f(i),strcat(n,e)));
    
    
end

%%
tabulate(f)

%% Montages
figure;
subplot(1,2,1);
mset = imageSet(char(fullfile(pwd,"Data","Failed","11")));
montage(mset.ImageLocation, 'Size',[3,1])
title("Misclassified Training Images")
subplot(1,2,2);
mset = imageSet(char(fullfile(pwd,"Data","Training","11")));
montage(mset.ImageLocation, 'Size',[3,3])
title("Training images")