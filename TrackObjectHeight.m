function [] = TrackObjectHeight(rsFullyProcDepthStackFile)
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

load(rsFullyProcDepthStackFile)

fullyProcDepthStack = RS_FullyProcDepthStack.fullyProcDepthStack;
caxis = RS_FullyProcDepthStack.caxis;
maxVal = caxis(2);

for a = 1:size(fullyProcDepthStack, 3)
    movieFrame = fullyProcDepthStack(:,:,a);
    maxInds = movieFrame == maxVal;
    movieFrame(maxInds) = NaN;
    maxHeight(a,1) = min(movieFrame(:));
    validPix = imcomplement(isnan(movieFrame));
    matVec = movieFrame(validPix);
    Ms = sort(matVec(:),'ascend');                          % Sort Descending
    Result = Ms(1:ceil(length(Ms)*0.2));                % Desired Output
    Average(a, 1) = mean(matVec);
    Average2(a,1) = mean(Result);
end

figure;
plot((1:4500)/15, fliplr(100*maxHeight))
hold on
plot((1:4500)/15,fliplr(100*Average))
hold on
plot((1:4500)/15,fliplr(100*Average2))
set(gca, 'YDir','reverse')
title('Mouse distance from camera')
ylabel('Distance (cm)')
xlabel('~Time (sec)')
legend('Min pixel value', 'Mean of all valid pixels', 'Min of bottom 20% of valid pixels')


