function CorrectRealSenseFrames_ImageMask(rsTrueDepthStackFile, roiFile, zeroIndeces)
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

disp('CorrectRealSenseFrame: Image Mask'); disp(' ')
if ~exist([rsTrueDepthStackFile(1:end - 19) '_ImageMask.mat'], 'file')
    holeImgStackFile = [rsTrueDepthStackFile(1:end - 19) '_PatchedHoles.mat'];
    load(holeImgStackFile)
    load(roiFile)
    
    %% Create cage image mask
    disp('Creating image mask...'); disp(' ')
    figure;
    shell = zeros(size(zeroIndeces));
    imagesc(shell)
    hold on;
    axis off
    mask = rectangle('Position', ROIs.cage, 'Curvature', 0.25, 'FaceColor', 'white', 'EdgeColor', 'white'); %#ok<NASGU>
    frame = getframe(gca);
    maskImg = frame2im(frame);
    greyImg = rgb2gray(maskImg);
    resizedGreyImg = imresize(greyImg,[480 640]);
    ROIs.binCageImg = imbinarize(resizedGreyImg);
    close(gcf)
    
    %% Overlay cage mask on each frame
    imgMaskStack = zeros(size(holeImgStack, 1), size(holeImgStack, 2), size(holeImgStack, 3));
    for b = 1:size(holeImgStack, 3)
        disp(['Overlaying cage ROI mask on image... (' num2str(b) '/' num2str(length(holeImgStack)) ')']); disp(' ')
        imgMaskStack(:,:,b) = holeImgStack(:,:,b).*ROIs.binCageImg;
    end
    save([rsTrueDepthStackFile(1:end - 19) '_ImageMask.mat'], 'imgMaskStack', '-v7.3')
    save('roiFile', 'ROIs')
else
    disp([rsTrueDepthStackFile(1:end - 19) '_ImageMask.mat already exists. Continuing...']); disp(' ')
end

end

