function CorrectRealSenseFrames_Binarize(depthStackFile)
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

disp('CorrectRealSenseFrames: Binarize'); disp(' ')
if ~exist([depthStackFile(1:end - 19) '_Binarize.mat'], 'file')
    
    thresholdStackFile = [depthStackFile(1:end - 19) '_Threshold.mat'];
    load(thresholdStackFile)
    
    %% Set remaining pixels above threshold = to zero
    binImgStack = zeros(size(threshImgStack, 1), size(threshImgStack, 2), size(threshImgStack, 3));
    for a = 1:size(threshImgStack, 3)
        disp(['Converting to grayscale and binarizing image... (' num2str(a) '/' num2str(size(threshImgStack, 3)) ')']); disp(' ')
        T = adaptthresh(mat2gray(threshImgStack(:,:,a)), 'ForegroundPolarity', 'dark');
        binImgStack(:,:,a) = imfill(bwareaopen(imcomplement(imbinarize(mat2gray(threshImgStack(:,:,a)), T)), 1500), 'holes');
    end
    save([depthStackFile(1:end - 19) '_Binarize.mat'], 'binImgStack', '-v7.3')
else
    disp([depthStackFile(1:end - 19) '_Binarize.mat already exists. Continuing...']); disp(' ')
end

end
