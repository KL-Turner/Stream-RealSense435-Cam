function CorrectRealSenseFrames_PatchHoles(rsTrueDepthStackFile, roiFile)
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

disp('CorrectRealSenseFrames: Patch Holes'); disp(' ')
if ~exist([rsTrueDepthStackFile(1:end - 19) '_PatchedHoles.mat'], 'file')
    load(rsTrueDepthStackFile)
    load(roiFile)
    
    %% Fill image holes with interpolated values, outside -> in
    realsenseFrames = RS_TrueDepthStack.trueDepthStack;
    allImgs = cell(length(realsenseFrames), 1);
    for a = 1:length(realsenseFrames)
        disp(['Filling image holes... (' num2str(a) '/' num2str(length(realsenseFrames)) ')']); disp(' ') 
        image = realsenseFrames{a,1};
        onesIndeces = image >= 1;
        image(onesIndeces) = 0;
        zeroIndeces = image == 0;
        allImgs{a,1} = regionfill(image, zeroIndeces);
    end
    holeImgStack = cat(3, allImgs{:});
    save([rsTrueDepthStackFile(1:end - 19) '_PatchedHoles.mat'], 'holeImgStack', '-v7.3')
    
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
    save(roiFile, 'ROIs')
else
    disp([rsTrueDepthStackFile(1:end - 19) '_PatchedHoles.mat already exists. Continuing...']); disp(' ')
end

end