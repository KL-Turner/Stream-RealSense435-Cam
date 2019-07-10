function CorrectRealSenseFrames_ResetDepth(depthStackFile, supplementalFile)
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

disp('CorrectRealSenseFrames: Reset Depth'); disp(' ')
if ~exist([depthStackFile(1:end - 19) '_ProcDepthStack.mat'], 'file')
    
    binOverlayStackFile = [depthStackFile(1:end - 19) '_BinOverlay.mat'];
    load(binOverlayStackFile)
    load(supplementalFile)
    
    procImgStack = zeros(size(binOverlayImgStack, 1), size(binOverlayImgStack, 2), size(binOverlayImgStack, 3));
    for e = 1:size(binOverlayImgStack, 3)
        disp(['Setting zero-pixels to desired colormap height in image... (' num2str(e) '/' num2str(length(binOverlayImgStack)) ')']); disp(' ')
        compImg = imcomplement(binOverlayImgStack(:,:,e));
        tempDepthImg = binOverlayImgStack(:,:,e);
        tempDepthImg(logical(compImg)) = mean(tempMax);
        procImgStack(:,:,e) = tempDepthImg;
    end
    save([depthStackFile(1:end - 19) '_ProcDepthStack.mat'], 'procImgStack', '-v7.3')
else
    disp([depthStackFile(1:end - 19) '_ProcDepthStack.mat already exists. Continuing...']); disp(' ')
end

end