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

disp('CorrectRealSenseFrame: Threshold'); disp(' ')
if ~exist([rsTrueDepthStackFile(1:end - 19) '_Threshold.mat'], 'file')
    
    meanSubStackFile = [rsTrueDepthStackFile(1:end - 19) '_MeanSub.mat'];
    load(meanSubStackFile)
    load(rsTrueDepthStackFile)
    
    %% Set remaining pixels above threshold = to zero
    threshImgStack = zeros(size(meanSubImgStack, 1), size(meanSubImgStack, 2), size(meanSubImgStack, 3));
    for d = 1:size(meanSubImgStack, 3)
        disp(['Setting pixels greater than zero back to zero... (' num2str(d) '/' num2str(length(meanSubImgStack)) ')']); disp(' ')
        tempImg = meanSubImgStack(:,:,d);
        threshIndeces = tempImg > 0;
        tempImg(threshIndeces) = 0;
        threshImgStack(:,:,d) = tempImg;
    end
    save([rsTrueDepthStackFile(1:end - 19) '_Threshold.mat'], 'threshImgStack', '-v7.3')
    
    disp('Determining proper caxis scaling...'); disp(' ')
    tempMax = zeros(1, size(threshImgStack, 3));
    tempMin = zeros(1, size(threshImgStack, 3));
    for c = 1:length(threshImgStack)
        tempImg = threshImgStack(:,:,c);
        tempMax(1,c) = max(tempImg(:));
        tempMin(1,c) = min(tempImg(:));
    end
    
    RS_HalfProcDepthStack.halfProcDepthStack = threshImgStack;
    RS_HalfProcDepthStack.caxis = [mean(tempMin) mean(tempMax)];
    RS_HalfProcDepthStack.frameTimes = RS_TrueDepthStack.frameTime;
    RS_HalfProcDepthStack.numFrames = RS_TrueDepthStack.numFrames;
    RS_HalfProcDepthStack.trialDuration = RS_TrueDepthStack.trialDuration;
    RS_HalfProcDepthStack.samplingRate = RS_TrueDepthStack.samplingRate;
    save([rsTrueDepthStackFile(1:end - 19) '_RS_HalfProcDepthStack.mat'], 'RS_HalfProcDepthStack', '-v7.3')
else
    disp([rsTrueDepthStackFile(1:end - 19) '_Threshold.mat already exists. Continuing...']); disp(' ')
end

end
