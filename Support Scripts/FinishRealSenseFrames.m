function [] = FinishRealSenseFrames(rsTrueDepthStackFile, rsHalfProcDepthStackFile)
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

load(rsHalfProcDepthStackFile);
load(rsTrueDepthStackFile);

%% Process the image stack in binary
procImgStack = RS_HalfProcDepthStack.halfProcDepthStack;
rawImgStack = RS_TrueDepthStack.trueDepthStack;
binImgStack = zeros(size(procImgStack, 1), size(procImgStack, 2), size(procImgStack, 3));
for a = 1:size(procImgStack, 3)
    disp(['Converting to grayscale and binarizing image... (' num2str(a) '/' num2str(length(procImgStack)) ')']); disp(' ') 
    T = adaptthresh(mat2gray(procImgStack(:,:,a)), 'ForegroundPolarity', 'dark');
    binImgStack(:,:,a) = imfill(bwareaopen(imcomplement(imbinarize(mat2gray(procImgStack(:,:,a)), T)), 1500), 'holes');
end
clear imgStack

%% Fill depth image holes with interpolated values, outside -> in
allImgs = cell(length(rawImgStack), 1);
for b = 1:length(rawImgStack)
    disp(['Filling image holes... (' num2str(b) '/' num2str(length(rawImgStack)) ')']); disp(' ') 
    image = rawImgStack{b,1};
    onesIndeces = image >= 1;
    image(onesIndeces) = 0;
    zeroIndeces = image == 0;
    allImgs{b,1} = regionfill(image, zeroIndeces);
end
holeImgStack = cat(3, allImgs{:});
clear rawImgStack
clear allImgs

disp('Determining proper caxis scaling...'); disp(' ')
tempMax = zeros(1, size(holeImgStack, 3));
tempMin = zeros(1, size(holeImgStack, 3));
for c = 1:length(holeImgStack)
    tempImg = holeImgStack(:,:,c);
    tempMax(1,c) = max(tempImg(:));
    tempMin(1,c) = min(tempImg(:));
end

%% Overlay the depth image with the processed binary image
binDepthStack = zeros(size(binImgStack, 1), size(binImgStack, 2), size(binImgStack, 3));
for d = 1:size(binImgStack, 3)
    disp(['Overlaying original depth on binarized image... (' num2str(d) '/' num2str(length(binImgStack)) ')']); disp(' ') 
    depthImg = holeImgStack(:,:,d);
    binDepthStack(:,:,d) = depthImg.*binImgStack(:,:,d);
end
clear holeImgStack

%% Set zero pixels to desired colormap height
finalImgStack = zeros(size(binDepthStack, 1), size(binDepthStack, 2), size(binDepthStack, 3));
for e = 1:size(binDepthStack, 3)
    disp(['Setting zero-pixels to desired colormap height in image... (' num2str(e) '/' num2str(length(binImgStack)) ')']); disp(' ')
    compImg = imcomplement(binImgStack(:,:,e));
    tempDepthImg = binDepthStack(:,:,e);
    tempDepthImg(logical(compImg)) = mean(tempMax);
    finalImgStack(:,:,e) = tempDepthImg;
end
clear binImgStack
clear binDepthStack

RS_FullyProcDepthStack.fullyProcDepthStack = finalImgStack;

save([rsHalfProcDepthStackFile(1:end - 23) '_FullyProcDepthStack.mat'], 'RS_FullyProcDepthStack', '-v7.3')


end
