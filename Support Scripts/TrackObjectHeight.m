function [] = TrackObjectHeight(procStackFile, supplementalFile)
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

%%
disp('Tracking object height...'); disp(' ')
resultsFile = [supplementalFile(1:end-20) 'Results.mat'];
load(procStackFile)
load(supplementalFile)

caxis = SuppData.caxis;
maxVal = caxis(2);

for a = 1:size(procDepthStack, 3)
    depthImg = procDepthStack(:,:,a);
    maxInds = depthImg == maxVal;
    depthImg(maxInds) = NaN;
    rawHeight(a,1) = min(depthImg(:));
    
    validPix = imcomplement(isnan(depthImg));
    pixelVec = depthImg(validPix);
    ascendPixelVals = sort(pixelVec(:),'ascend');
    avgHeight(a,1) = mean(pixelVec);
    
    twentyPercentile = ascendPixelVals(1:ceil(length(ascendPixelVals)*0.2));
    avg20Height(a,1) = mean(twentyPercentile);
end

%%
figure;
plot((1:length(rawHeight))/SuppData.samplingRate, fliplr(100*rawHeight))
hold on
plot((1:18000)/15,fliplr(100*avgHeight))
hold on
plot((1:18000)/15,fliplr(100*avg20Height))
set(gca, 'YDir','reverse')
title('Mouse distance from camera')
ylabel('Distance (cm)')
xlabel('~Time (sec)')
legend('Min pixel value', 'Mean of all valid pixels', 'Min of bottom 20% of valid pixels')

Results.rawHeight = fliplr(100*rawHeight);
Results.avgHeight = fliplr(100*avgHeight);
Results.avg20Height = fliplr(100*avg20Height);
save(resultsFile, 'Results')

end
