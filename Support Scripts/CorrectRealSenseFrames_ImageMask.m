function CorrectRealSenseFrames_ImageMask(depthStackFile, supplementalFile)
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

disp('CorrectRealSenseFrames: Image Mask'); disp(' ')
if ~exist([depthStackFile(1:end - 19) '_ImageMask.mat'], 'file')
    holeImgStackFile = [depthStackFile(1:end - 19) '_PatchedHoles.mat'];
    load(holeImgStackFile)
    load(supplementalFile)
    
    %% Overlay cage mask on each frame
    imgMaskStack = zeros(size(holeImgStack, 1), size(holeImgStack, 2), size(holeImgStack, 3));
    for b = 1:size(holeImgStack, 3)
        disp(['Overlaying cage ROI mask on image... (' num2str(b) '/' num2str(length(holeImgStack)) ')']); disp(' ')
        imgMaskStack(:,:,b) = holeImgStack(:,:,b).*SuppData.binCageImg;
    end
    save([depthStackFile(1:end - 19) '_ImageMask.mat'], 'imgMaskStack', '-v7.3')
else
    disp([depthStackFile(1:end - 19) '_ImageMask.mat already exists. Continuing...']); disp(' ')
end

end

