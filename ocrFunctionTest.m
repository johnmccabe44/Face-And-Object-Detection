%%
imgSet = imageSet(char("C:\Users\johnm\OneDrive - City, University of London\MSc Data Science\5. INM460 - Computer Vision\Coursework\Data Preparation\Videos"),'recursive')
for i = 1:length(imgSet)
    for j = 1:imgSet(i).Count
        if mod(j,10) == 0
            filename=imgSet(i).ImageLocation{j}
            n = detectNum(filename)
        end
    end
end

%%
loopVideo("C:\Users\johnm\OneDrive - City, University of London\MSc Data Science\5. INM460 - Computer Vision\Coursework\Data Preparation\Videos")