function [meanThresh] = SkinToneTest(I)
    %SKINTONETEST calculates the mean of skin tone in the identified
    %region. 
    %   Parameters: I - Image
    %   Returns: The mean value of all flesh coloured areas in the image
    YUV = rgb2ycbcr(I); 
    U = YUV(:, :, 2); 
    V = YUV(:, :, 3); 
    R = I(:, :, 1); 
    G = I(:, :, 2); 
    B = I(:, :, 3); 
    
    [rows, cols, planes] = size(I);
    
    skin = zeros(rows, cols); 
    ind = find(80 < U & U < 130 & 136 < V & ... 
        V <= 200 & V > U & R > 80 & G > 30 & ... 
        B > 15 & abs(R-G) > 15); 
    skin(ind) = 1;
    meanThresh = mean(skin,'all');
    
end

