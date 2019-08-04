function [origI, newI, copyI] = preprocess(imageLocation, resize, grayscale, sharpen, dilate, complement, equalise, reverse, secretsauce, scale)
%PREPROCESS Converts to grayscale and does a series of operations
%   Detailed explanation goes here

    % keep original image
    origI = imread(imageLocation);
    tmpI = origI;
    
    % resize
    if ~exist('resize','var')
        resize = false;
    end    
    if resize == true
        if ~exist('scale','var')            
            s = 5;
        else
            s = scale;
        end
        
        tmpI = imresize(origI,[(200*s) NaN]);
        copyI = tmpI;
        
    end
    
    if ~exist('secretsauce','var')
        secretsauce = false;
    end  
    if secretsauce
        %imshow(tmpI);        
        [rows, cols, planes] = size(tmpI);
        mask = zeros(rows,cols);
        R = tmpI(:,:,1); G = tmpI(:,:,2); B = tmpI(:,:,3);  
        tone = ((abs(R-G)<(30))&(abs(R-B)<(30))&(abs(G-B)<(30)));
        ind = find(tone);
        mask(ind) = 1;        
        tmpI(:,:,1) = R .* uint8(mask);
        tmpI(:,:,2) = G .* uint8(mask);
        tmpI(:,:,3) = B .* uint8(mask);      
    end
    
    if ~exist('grayscale','var')
        grayscale = false;
    end  
    if grayscale == true
        tmpI = rgb2gray(tmpI);
        
        % following actions can only happen if is grayscaled        
        % sharpen
        if ~exist('sharpen','var')
            sharpen = false;
        end
        if sharpen >0
            for i = 1:sharpen
                K = [0, -1, 0;-1, 5, -1;0, -1, 0]; 
                tmpI = imfilter(tmpI,K);  
            end
        end

        % reverse
        if ~exist('reverse','var')
            reverse = false;
        end    
        if reverse == true
            tmpI = 1 - tmpI;
        end

        % dilate
        if ~exist('dilate','var')
            dilate = false;
        end    
        if dilate == true
            tmpI = imdilate(tmpI);
        end

        % complement same as reverse
        if ~exist('complement','var')
            complement = false;
        end    
        if complement == true
            tmpI = imcomplement(tmpI);
        end
        
        % equalise histogram to exaggerate differences
        if ~exist('equalise','var')
            equalise = false;
        end    
        if equalise == true
            tmpI = histeq(tmpI);
        end
        

    end
    
    
    newI = tmpI;
end

