function CorrectRealSenseFrames_KalmanFilter(rsTrueDepthStackFile)
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

disp('CorrectRealSenseFrames: Kalman Filter'); disp(' ')
if ~exist([rsTrueDepthStackFile(1:end - 19) '_Kalman.mat'], 'file')
    imgMaskStackFile = [rsTrueDepthStackFile(1:end - 19) '_ImageMask.mat'];
    load(imgMaskStackFile)
    
    %% Kalman filter
    kalmanImgStack = Kalman_Stack_Filter(imgMaskStack, 0.75, 0.75);
    save([rsTrueDepthStackFile(1:end - 19) '_Kalman.mat'], 'kalmanImgStack', '-v7.3')
else
    disp([rsTrueDepthStackFile(1:end - 19) '_Kalman.mat already exists. Continuing...']); disp(' ')
end

end
