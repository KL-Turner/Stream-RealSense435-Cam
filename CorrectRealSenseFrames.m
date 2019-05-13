function [RealSenseData] = CorrectRealSenseFrames(RealSenseData)
%________________________________________________________________________________________________________________________
% Written by Kevin L. Turner
% The Pennsylvania State University, Dept. of Biomedical Engineering
% https://github.com/KL-Turner
%________________________________________________________________________________________________________________________
%
%   Purpse:  
%________________________________________________________________________________________________________________________
%
%   Inputs: 
%
%   Outputs: 
%
%   Last Revised: May 12th, 2019
%________________________________________________________________________________________________________________________

realsenseFrames = RealSenseData.depthMap;
allImgs = cell(length(realsenseFrames), 1);
for a = 1:length(realsenseFrames)
    disp(['Correcting images... (' num2str(a) '/' num2str(length(realsenseFrames)) ')']); disp(' ') 
    image = realsenseFrames{a,1};
    onesIndeces = image >= 1;
    image(onesIndeces) = 0;
    zeroIndeces = image == 0;
    allImgs{a,1} = regionfill(image, zeroIndeces);
end
imgStack = cat(3, allImgs{:});
correctedImgStack = Kalman_Stack_Filter(imgStack, 0.5);
RealSenseData.correctedImageStack = correctedImgStack;

for b = 1:length(imgStack)
    clear tempImg tempMax tempMin
    tempImg = correctedImgStack(:,:,b);
    tempMax = max(tempImg(:));
    tempMin = min(tempImg(:));
    if b == 1
        maxVal = tempMax;
        minVal = tempMin;
    else
        if tempMax > maxVal
            maxVal = tempMax;
        end
        if tempMin < minVal
            minVal = tempMin;
        end
    end
end

RealSenseData.correctedImageStack = correctedImgStack;
RealSenseData.caxis = [minVal maxVal];

end
