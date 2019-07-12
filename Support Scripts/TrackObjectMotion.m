function [] = TrackObjectMotion(procDepthStackFile)
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

load(procDepthStackFile)

distanceTraveled = 0;
for a = 1:length(procDepthStack)
    if a == length(procDepthStack)
        break
    else
        imageA = procDepthStack(a);
        imageB = procDepthStack(a+1);
        centA = centroid(imageA);
        centB = centroid(imageB);
        X = [centB, centA];
        dist = pdist(X, 'euclidean');
        distanceTraveled = distanceTraveled+dist;
    end
end
