%% Script to split training and evaluation data.
% Physically move the files into a Training/ Evaluation Folder so that it
% is easy to re-run models

rootFolder = pwd
faceFolders = {'Faces','Faces125x125'}

for faceFolder = faceFolders

    % standardize number of images in each imageset
    faceDatabase = imageSet(char(fullfile(rootFolder,faceFolder)),'Recursive');
    minSetCount = min([faceDatabase.Count])        
    faceDatabase = partition(faceDatabase, minSetCount, 'randomize'); 
    
    
    % now get the training and evaluation
    [training,test] = partition(faceDatabase,[0.8 0.2]);
    
    % Create a training and evaluation folder under the root
    if ~exist(fullfile(rootFolder, faceFolder, "Training"),'dir')
        mkdir(fullfile(rootFolder, faceFolder, "Training"));
    end
    
    if ~exist(fullfile(rootFolder, faceFolder, "Evaluation"),'dir')
        mkdir(fullfile(rootFolder, faceFolder, "Evaluation"));
    end
    
    
    % now pysically move the images to a training evaluation folder
    for i = 1:length(training)
        for j = 1:training(i).Count
            
            imgLocation = training(i).ImageLocation(j);
            
            [path, name, ext] = fileparts(imgLocation{1});
            newImgLocation = fullfile(replace(path,faceFolder, strcat(faceFolder,"\Training")),strcat(name,ext));
            
            [path, name, ext] = fileparts(newImgLocation);
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
            
            [path, name, ext] = fileparts(imgLocation{1});
            newImgLocation = fullfile(replace(path,faceFolder, strcat(faceFolder,"\Test")),strcat(name,ext));

            
            [path, name, ext] = fileparts(newImgLocation);
            if ~exist(path,'dir')      
                mkdir(path)
            end
            
            copyfile(imgLocation{1}, newImgLocation);
        end
    end

end
