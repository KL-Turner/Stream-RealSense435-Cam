function [] = TrackObjectMotion(binDepthStackFile, supplementalFile)
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

load(binDepthStackFile)
load(supplementalFile)

distanceTraveled = 0;
for a = 1:length(binDepthStack)
    if a == length(binDepthStack)
        break
    else
        imageA = binDepthStack(:,:,a);
        imageB = binDepthStack(a+1);
        
        [y, x] = ndgrid(1:size(imageA, 1), 1:size(imageA, 2));
        centroid = mean([x(logical(imageA)), y(logical(imageA))]);
        
        X = [centB, centA];
        dist = pdist(X, 'euclidean');
        distanceTraveled = distanceTraveled+dist;
    end
end
