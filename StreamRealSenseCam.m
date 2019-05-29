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
disp('Select or create the folder to save the data'); disp(' ')
filePath = uigetdir(cd, 'Select or create the folder to save the data');

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
    fileID1 = join(['RealSense_' currentTime '_ColorizedDepthStack.mat'], '');
    fileID2 = join(['RealSense_' currentTime '_RGBStack.mat'], '');
    fileID3 = join(['RealSense_' currentTime '_TrueDepthStack.mat'], '');
    disp('Acquiring RealSense D435 camera video...'); disp(' ')
    [RS_ColorizedDepthStack, RS_RGBStack, RS_TrueDepthStack] = AcquireRealSenseVideo(numFramesToAcquire);
    
    RS_ColorizedDepthStack.numFrames = numFramesToAcquire;
    RS_ColorizedDepthStack.trialDuration = trialDuration;
    RS_ColorizedDepthStack.samplingRate = defaultSamplingRate;
    disp(['Saving ' fileID1 '...']); disp(' ')
    savePath1 = join([filePath '\' fileID1], '');
    save(savePath1, 'RS_ColorizedDepthStack', '-v7.3')
    
    RS_RGBStack.numFrames = numFramesToAcquire;
    RS_RGBStack.trialDuration = trialDuration;
    RS_RGBStack.samplingRate = defaultSamplingRate;
    disp(['Saving ' fileID2 '...']); disp(' ')
    savePath2 = join([filePath '\' fileID2], '');
    save(savePath2, 'RS_ColorizedDepthStack', '-v7.3')
    
    RS_TrueDepthStack.numFrames = numFramesToAcquire;
    RS_TrueDepthStack.trialDuration = trialDuration;
    RS_TrueDepthStack.samplingRate = defaultSamplingRate;
    disp(['Saving ' fileID3 '...']); disp(' ')
    savePath3 = join([filePath '\' fileID3], '');
    save(savePath3, 'RS_ColorizedDepthStack', '-v7.3')
    
end
disp('RealSense camera streaming - complete'); disp(' ')
close all

end
