function CorrectRealSenseFrames_BinOverlay2(depthStackFile)
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

disp('CorrectRealSenseFrames: Binary Overlay 2'); disp(' ')
if ~exist([depthStackFile(1:end - 19) '_BinOverlay2.mat'], 'file')
    
    binStackFile = [depthStackFile(1:end - 19) '_Binarize.mat'];
    load(binStackFile)
    
    holeStackFile = [depthStackFile(1:end - 19) '_PatchedHoles.mat'];
    load(holeStackFile)
    
    %% Overlay the depth image with the processed binary image
    binOverlayImgStack2 = zeros(size(binImgStack, 1), size(binImgStack, 2), size(binImgStack, 3));
    for a = (floor(size(binImgStack,3)/2) + 1):size(binImgStack, 3)
        disp(['Overlaying original depth on binarized image... (' num2str(a) '/' num2str(length(binImgStack)) ')']); disp(' ')
        binOverlayImgStack2(:,:,a) = holeImgStack(:,:,a).*binImgStack(:,:,a);
    end
    save([depthStackFile(1:end - 19) '_BinOverlay2.mat'], 'binOverlayImgStack2', '-v7.3')
else
    disp([depthStackFile(1:end - 19) '_BinOverlay2.mat already exists. Continuing...']); disp(' ')
end

end
