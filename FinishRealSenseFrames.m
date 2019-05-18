function [RS_FinalData] = FinishRealSenseFrames(RS_RawData, RS_ProcData)
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

%% Process the image stack in binary
procImgStack = RS_ProcData.procImgStack;
clear RS_ProcData
rawImgStack = RS_RawData.depthMap;
RS_FinalData.numFrames = RS_RawData.numFrames;
RS_FinalData.trialDuration = RS_RawData.trialDuration;
RS_FinalData.samplingRate = RS_RawData.samplingRate;
clear RS_RawData
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

%% Set zero pixels to desired colormap height
finalImgStack = zeros(size(binDepthStack, 1), size(binDepthStack, 2), size(binDepthStack, 3));
for e = 1:size(binDepthStack, 3)
    disp(['Setting zero-pixels to desired colormap height in image... (' num2str(e) '/' num2str(length(binImgStack)) ')']); disp(' ')
    compImg = imcomplement(binImgStack(:,:,e));
    tempDepthImg = binDepthStack(:,:,e);
    tempDepthImg(logical(compImg)) = mean(tempMax);
    finalImgStack(:,:,e) = tempDepthImg;
end

RS_FinalData.imgStack = finalImgStack;
RS_FinalData.caxis = [mean(tempMin) mean(tempMax)];

end
