% Test every image using 
clc;
imgset = imageSet(fullfile('C:\Users\johnm\OneDrive - City, University of London\MSc Data Science\5. INM460 - Computer Vision\Backup\Images'),'recursive')

%%

featureTypes = {'HOG','SURF'};
classifierNames = {'SVM','RF'};


for featureType = featureTypes
    for classifierName = classifierNames
        for i = 1:length(imgset)
            for j = 1:imgset(i).Count
                if mod(j,10) == 0
                    filename = imgset(i).ImageLocation{j}
                    I = imread(imgset(i).ImageLocation{j});            
                    P = RecogniseFace(I,featureType,classifierName)
                end        
            end
        end
    end
end

%% CNN Test
clc;
for i = 1:length(imgset)
    for j = 1:imgset(i).Count
        if mod(j,10) == 0
            filename = imgset(i).ImageLocation{j}
            I = imread(imgset(i).ImageLocation{j});            
            P = RecogniseFace(I,'','CNN')
        end        
    end
end


