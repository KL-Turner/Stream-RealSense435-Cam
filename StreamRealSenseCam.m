function [] = StreamRealSenseCam()
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

clear
clc
minInput = input('How many minutes would you like to stream for? (Increments of 5): '); disp(' ')
numTrials = ceil(minInput/5);
trialDuration = 5*60;
defaultSamplingRate = 15;
numFramesToAcquire = trialDuration*defaultSamplingRate;

%% Confirm camera alignment
yString = 'y';
theInput = 'n';
disp('Verifying camera alignment...'); disp(' ')
while strcmp(yString, theInput) ~= 1
    [rgbImg, depthImg] = VerifyRealSenseCamAlignment;
    checkAlign = figure;
    subplot(1,2,1)
    imshow(rgbImg)
    title('RGB image')
    subplot(1,2,2)
    imshow(depthImg)
    title('Colorized depth image')
    theInput = input('Is the camera aligned? (y/n): ', 's'); disp(' ')
    try
        close(checkAlign)
    catch
    end
end


%% Acquire data - Run for set number of desired minutes. 5 minute increments
for a = 1:numTrials
    currentTime = strrep(strrep(strrep(string(datetime), ' ', '_'), ':', '_'), '-', '_');
    fileID = join([currentTime '_RS_RawData.mat'], '');
    disp('Acquiring RealSense D435 camera video...'); disp(' ')
    [RS_RawData] = AcquireRealSenseVideo(numFramesToAcquire);
    RS_RawData.numFrames = numFramesToAcquire;
    RS_RawData.trialDuration = trialDuration;
    RS_RawData.samplingRate = defaultSamplingRate;
    disp(['Saving ' fileID '...']); disp(' ')
    save(fileID, 'RS_RawData', '-v7.3')
end
disp('RealSense camera streaming - complete'); disp(' ')
close all

end
