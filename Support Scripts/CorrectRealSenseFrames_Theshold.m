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
else
    disp([rsTrueDepthStackFile(1:end - 19) '_Threshold.mat already exists. Continuing...']); disp(' ')
end

end
