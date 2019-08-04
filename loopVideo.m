function loopVideo(rootFolder)
    %CONVERTVIDEO: Parm: Folder to process any video file in
    %convert video to series of images
    
    % load up the valid video file formats ... by extension
    VIDEO_EXTENSIONS = {'.asf','.asx','.avi','.m4v','.mj2','.mp4','.mpg','.wmv','.mov','.avi'};
    
    
    % get the list of files in the folder
    files = dir(rootFolder);
    % separate the dirs ...
    dirNames = {files([files.isdir]).name};
    % ... and the files
    fileNames = {files(~[files.isdir]).name};
    % .. lose the system direcories
    dirNames = dirNames(~ismember(dirNames,{'.','..'}));

    % loop through the subfolders, recursively processing and video files
    for i = 1:size(dirNames,2)
        loopVideo(fullfile(rootFolder,dirNames(1,i)));
    end

    for i = 1:size(fileNames,2)
        
        % extract the file extension
        [folder,name,ext] = fileparts(fullfile(rootFolder, fileNames(i)));
        
        % check if is valid video extension
        if ismember(ext,VIDEO_EXTENSIONS)
            fullfile(rootFolder, fileNames(i))
            n = detectNum(fullfile(rootFolder, fileNames(i)))
            return
        end
        
    end
    
end