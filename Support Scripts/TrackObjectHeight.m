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
    matVec = depthImg(validPix);
    Ms = sort(matVec(:),'ascend');
    Result = Ms(1:ceil(length(Ms)*0.2));
    Average(a,1) = mean(matVec);
    Average2(a,1) = mean(Result);
end

figure;
plot((1:length(rawHeight))/SuppData.samplingRate, fliplr(100*rawHeight))
hold on
plot((1:18000)/15,fliplr(100*Average))
hold on
plot((1:18000)/15,fliplr(100*Average2))
set(gca, 'YDir','reverse')
title('Mouse distance from camera')
ylabel('Distance (cm)')
xlabel('~Time (sec)')
legend('Min pixel value', 'Mean of all valid pixels', 'Min of bottom 20% of valid pixels')

end
