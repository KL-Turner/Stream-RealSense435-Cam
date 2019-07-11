function CorrectRealSenseFrames_BinImage(rsTrueDepthStackFile)
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

disp('CorrectRealSenseFrames: Binary Image'); disp(' ')
if ~exist([rsTrueDepthStackFile(1:end - 19) '_BinImage.mat'], 'file')
    halfProcImgStackFile = [rsTrueDepthStackFile(1:end - 19) '_HalfProcDepthStack.mat'];
    load(halfProcImgStackFile)
    halfProcImgStack = HalfProcDepthStack.halfProcDepthStack;

    %% Process the image stack into binary
    binImgStack = zeros(size(halfProcImgStack, 1), size(halfProcImgStack, 2), size(halfProcImgStack, 3));
    for a = 1:size(halfProcImgStack, 3)
        disp(['Converting to grayscale and binarizing image... (' num2str(a) '/' num2str(length(halfProcImgStack)) ')']); disp(' ')
        T = adaptthresh(mat2gray(halfProcImgStack(:,:,a)), 'ForegroundPolarity', 'dark');
        binImgStack(:,:,a) = imfill(bwareaopen(imcomplement(imbinarize(mat2gray(halfProcImgStack(:,:,a)), T)), 1500), 'holes');
    end
else
    disp([rsTrueDepthStackFile(1:end - 19) '_BinImage.mat already exists. Continuing...']); disp(' ')
end

end
