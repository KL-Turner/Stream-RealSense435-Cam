function CorrectRealSenseFrames_Theshold(rsTrueDepthStackFile)
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
%   Last Revised:
%________________________________________________________________________________________________________________________

disp('CorrectRealSenseFrames: Threshold'); disp(' ')
if ~exist([rsTrueDepthStackFile(1:end - 19) '_Threshold.mat'], 'file')
    meanSubStackFile = [rsTrueDepthStackFile(1:end - 19) '_MeanSub.mat'];
    load(meanSubStackFile)
    load(rsTrueDepthStackFile)
    
    %% Set remaining pixels above threshold = to zero
    threshImgStack = zeros(size(meanSubImgStack, 1), size(meanSubImgStack, 2), size(meanSubImgStack, 3));
    for a = 1:size(meanSubImgStack, 3)
        disp(['Setting pixels greater than zero back to zero... (' num2str(a) '/' num2str(length(meanSubImgStack)) ')']); disp(' ')
        tempImg = meanSubImgStack(:,:,a);
        threshIndeces = tempImg > 0;
        tempImg(threshIndeces) = 0;
        threshImgStack(:,:,a) = tempImg;
    end
    save([rsTrueDepthStackFile(1:end - 19) '_Threshold.mat'], 'threshImgStack', '-v7.3')
<<<<<<< HEAD
=======
    
    disp('Determining proper caxis scaling...'); disp(' ')
    tempMax = zeros(1, size(threshImgStack, 3));
    tempMin = zeros(1, size(threshImgStack, 3));
    for c = 1:length(threshImgStack)
        tempImg = threshImgStack(:,:,c);
        tempMax(1,c) = max(tempImg(:));
        tempMin(1,c) = min(tempImg(:));
    end
    
    HalfProcDepthStack.halfProcDepthStack = threshImgStack;
    HalfProcDepthStack.caxis = [mean(tempMin) mean(tempMax)];
    HalfProcDepthStack.frameTimes = RS_TrueDepthStack.frameTime;
    HalfProcDepthStack.numFrames = RS_TrueDepthStack.numFrames;
    HalfProcDepthStack.trialDuration = RS_TrueDepthStack.trialDuration;
    HalfProcDepthStack.samplingRate = RS_TrueDepthStack.samplingRate;
    save([rsTrueDepthStackFile(1:end - 19) '_HalfProcDepthStack.mat'], 'HalfProcDepthStack', '-v7.3')
>>>>>>> e69aba516cbe5df6b3a85ba5fc3844141d636922
else
    disp([rsTrueDepthStackFile(1:end - 19) '_Threshold.mat already exists. Continuing...']); disp(' ')
end

end
