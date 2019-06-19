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
numTrials = input('How many trials would you like to stream for? (20 minutes per trial): '); disp(' ')
trialDuration = 20*60;
defaultSamplingRate = 15;
numFramesToAcquire = trialDuration*defaultSamplingRate;
disp('Select or create the folder to save the data:'); disp(' ')
filePath = uigetdir(cd, 'Select or create the folder to save the data');

%% Confirm camera alignment
yString = 'y';
theInput = 'n';
disp('Verifying camera alignment...'); disp(' ')
while strcmp(yString, theInput) ~= 1
    [rgbImg, ~] = VerifyRealSenseCamAlignment;
    checkAlign = figure;
    imshow(rgbImg)
    title('RGB image')
    theInput = input('Is the camera aligned? (y/n): ', 's'); disp(' ')
    try
        close(checkAlign)
    catch
    end
end

%% Acquire data - Run for set number of desired 20 minute trials.
for a = 1:numTrials
    disp(['Streaming trial number ' num2str(a) ' of ' num2str(numTrials)]); disp(' ')
    currentTime = strrep(strrep(strrep(string(datetime), ' ', '_'), ':', '_'), '-', '_');
    fileID1 = join(['RealSense_' currentTime '_RGBStack.mat'], '');
    fileID2 = join(['RealSense_' currentTime '_TrueDepthStack.mat'], '');
    disp('Acquiring RealSense D435 camera video...'); disp(' ')
    [RS_RGBStack, RS_TrueDepthStack] = AcquireRealSenseVideo(numFramesToAcquire, trialDuration);
    
    RS_RGBStack.numFrames = numFramesToAcquire;
    RS_RGBStack.trialDuration = trialDuration;
    RS_RGBStack.samplingRate = defaultSamplingRate;
    savePath1 = join([filePath '\' fileID1], '');
    disp('Saving RGB stack...'); disp(' ')
    save(savePath1, 'RS_RGBStack', '-v7.3')
 
    RS_TrueDepthStack.numFrames = numFramesToAcquire;
    RS_TrueDepthStack.trialDuration = trialDuration;
    RS_TrueDepthStack.samplingRate = defaultSamplingRate;
    savePath2 = join([filePath '\' fileID2], '');
    disp('Saving depth stack...'); disp(' ')
    save(savePath2, 'RS_TrueDepthStack', '-v7.3')
    
end
disp('RealSense camera streaming - complete'); disp(' ')
f = msgbox('Data Save Complete', 'Success');
close all
