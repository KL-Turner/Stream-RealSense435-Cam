function CorrectRealSenseFrames_ImageMask(rsTrueDepthStackFile, roiFile)
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
if ~exist([rsTrueDepthStackFile(1:end - 19) '_ImageMask.mat'], 'file')
    holeImgStackFile = [rsTrueDepthStackFile(1:end - 19) '_PatchedHoles.mat'];
    load(holeImgStackFile)
    load(roiFile)
    
    %% Overlay cage mask on each frame
    imgMaskStack = zeros(size(holeImgStack, 1), size(holeImgStack, 2), size(holeImgStack, 3));
    for b = 1:size(holeImgStack, 3)
        disp(['Overlaying cage ROI mask on image... (' num2str(b) '/' num2str(length(holeImgStack)) ')']); disp(' ')
        imgMaskStack(:,:,b) = holeImgStack(:,:,b).*ROIs.binCageImg;
    end
    save([rsTrueDepthStackFile(1:end - 19) '_ImageMask.mat'], 'imgMaskStack', '-v7.3')
else
    disp([rsTrueDepthStackFile(1:end - 19) '_ImageMask.mat already exists. Continuing...']); disp(' ')
end

end

