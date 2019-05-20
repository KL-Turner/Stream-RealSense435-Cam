function [RS_HalfProcDepthStack, ROIs] = CorrectRealSenseFrames(RS_TrueDepthStack, ROIs)
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
maskImgStack = zeros(size(holeImgStack, 1), size(holeImgStack, 2), size(holeImgStack, 3));
for b = 1:size(holeImgStack, 3)
    disp(['Overlaying cage ROI mask on image... (' num2str(b) '/' num2str(length(holeImgStack)) ')']); disp(' ') 
    maskImgStack(:,:,b) = holeImgStack(:,:,b).*ROIs.binCageImg;
end
clear holeImgStack

%% Kalman filter
disp('Running image stack though Kalman filter...'); disp(' ')
kalmanImgStack = Kalman_Stack_Filter(maskImgStack, 0.75, 0.75);
clear maskImgStack

%% Mean subtract background image
pixelMeans = mean(kalmanImgStack, 3);
meansubImgStack = zeros(size(kalmanImgStack, 1), size(kalmanImgStack, 2), size(kalmanImgStack, 3));
for c = 1:size(kalmanImgStack, 3)
    disp(['Mean subtracking to remove background from image... (' num2str(c) '/' num2str(length(kalmanImgStack)) ')']); disp(' ') 
    meansubImgStack(:,:,c) = kalmanImgStack(:,:,c) - pixelMeans;
end
clear kalmanImgStack

%% Set remaining pixels above threshold = to zero
threshImgStack = zeros(size(meansubImgStack, 1), size(meansubImgStack, 2), size(meansubImgStack, 3));
for d = 1:size(meansubImgStack, 3)
    disp(['Setting pixels greater than zero back to zero... (' num2str(d) '/' num2str(length(meansubImgStack)) ')']); disp(' ') 
    tempImg = meansubImgStack(:,:,d);
    threshIndeces = tempImg > 0;
    tempImg(threshIndeces) = 0;
    threshImgStack(:,:,d) = tempImg;
end

disp('Determining proper caxis scaling...'); disp(' ')
tempMax = zeros(1, size(threshImgStack, 3));
tempMin = zeros(1, size(threshImgStack, 3));
for c = 1:length(threshImgStack)
    tempImg = threshImgStack(:,:,c);
    tempMax(1,c) = max(tempImg(:));
    tempMin(1,c) = min(tempImg(:));
end

RS_HalfProcDepthStack.halfProcDepthStack = threshImgStack;
RS_HalfProcDepthStack.caxis = [mean(tempMin) mean(tempMax)];
RS_HalfProcDepthStack.frameTimes = RS_TrueDepthStack.frameTime;
RS_HalfProcDepthStack.numFrames = RS_TrueDepthStack.numFrames;
RS_HalfProcDepthStack.trialDuration = RS_TrueDepthStack.trialDuration;
RS_HalfProcDepthStack.samplingRate = RS_TrueDepthStack.samplingRate;

end
