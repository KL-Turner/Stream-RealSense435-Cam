function [ProcRealSenseData] = CorrectRealSenseFrames(RawRealSenseData)
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
realsenseFrames = RawRealSenseData.depthMap;
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

%% Kalman filter
disp('Running image stack though Kalman filter...'); disp(' ')
kalmanImgStack = Kalman_Stack_Filter(holeImgStack, 0.75, 0.75);

%% Mean subtract background image
pixelMeans = mean(kalmanImgStack, 3);
for b = 1:length(kalmanImgStack)
    disp(['Mean subtracking and removing background image... (' num2str(b) '/' num2str(length(realsenseFrames)) ')']); disp(' ') 
    meansubImgStack(:,:,b) = kalmanImgStack(:,:,b) - pixelMeans;
end

disp('Determining proper caxis scaling...'); disp(' ')
for c = 1:length(holeImgStack)
    tempImg = meansubImgStack(:,:,c);
    tempMax(1,c) = max(tempImg(:));
    tempMin(1,c) = min(tempImg(:));
end

ProcRealSenseData.procImgStack = meansubImgStack;
ProcRealSenseData.caxis = [mean(tempMin) mean(tempMax)];

end

% BW = imbinarize(Kmedian,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);
