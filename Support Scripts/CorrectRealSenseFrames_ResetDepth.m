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
if ~exist([depthStackFile(1:end-21) '_ProcDepthStack_' depthStackFile(end-4:end)], 'file')
    
    binOverlayStackFile = [depthStackFile(1:end-21) '_BinOverlay_' depthStackFile(end-4:end)];
    load(binOverlayStackFile)
    load(supplementalFile)
    stackID = ['depthStack_' depthStackFile(end-4)];
    
    procImgStack = zeros(size(binOverlayImgStack,1), size(binOverlayImgStack,2), size(binOverlayImgStack,3));
    for a = 1:size(binOverlayImgStack,3)
        disp(['Setting zero-pixels to desired colormap height in image... (' num2str(a) '/' num2str(length(binOverlayImgStack)) ')']); disp(' ')
        compImg = imcomplement(binOverlayImgStack(:,:,a));
        tempDepthImg = binOverlayImgStack(:,:,a);
        tempDepthImg(logical(compImg)) = SuppData.(stackID).caxis(2);
        procImgStack(:,:,a) = tempDepthImg;
    end
    save([depthStackFile(1:end-21) '_ProcDepthStack_' depthStackFile(end-4:end)], 'procImgStack', '-v7.3')
else
    disp([depthStackFile(1:end-21) '_ProcDepthStack_' depthStackFile(end-4:end) ' already exists. Continuing...']); disp(' ')
end

end