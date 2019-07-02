function CorrectRealSenseFrames_MeanSub(rsTrueDepthStackFile)
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

disp('CorrectRealSenseFrame: Mean Subtraction'); disp(' ')
if ~exist([rsTrueDepthStackFile(1:end - 19) '_MeanSub.mat'], 'file')
    kalmanStackFile = [rsTrueDepthStackFile(1:end - 19) '_Kalman.mat'];
    load(kalmanStackFile)
    
    %% Mean subtract background image
    pixelMeans = mean(kalmanImgStack, 3);
    meanSubImgStack = zeros(size(kalmanImgStack, 1), size(kalmanImgStack, 2), size(kalmanImgStack, 3));
    for c = 1:size(kalmanImgStack, 3)
        disp(['Mean subtracking to remove background from image... (' num2str(c) '/' num2str(length(kalmanImgStack)) ')']); disp(' ')
        meanSubImgStack(:,:,c) = kalmanImgStack(:,:,c) - pixelMeans;
    end
    save([[rsTrueDepthStackFile(1:end - 19) '_MeanSub.mat'], 'meanSubImgStack', '-v7.3')
else
    disp([rsTrueDepthStackFile(1:end - 19) '_MeanSub.mat already exists. Continuing...']); disp(' ')
end

end
