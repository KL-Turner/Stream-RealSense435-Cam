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

close all
clear
clc
numTrials = input('How many trials would you like to stream for? (20 minutes per trial): '); disp(' ')
animalID = input('Input the animal ID: ','s'); disp(' ')
trialDuration = 20*60;   % min per trial*sec
defaultSamplingRate = 30;
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
    fileID1 = join([animalID '_' currentTime '_RGBStack.mat'], '');
    fileID2 = join([animalID '_' currentTime '_DepthStack.mat'], '');
    fileID3 = join([animalID '_' currentTime '_SupplementalData.mat'], '');
    disp('Acquiring RealSense D435 camera video...'); disp(' ')
    [RGBStack, DepthStack, SuppData] = AcquireRealSenseVideo(numFramesToAcquire, trialDuration);
    SuppData.numFrames = numFramesToAcquire/2;
    SuppData.trialDuration = trialDuration;
    SuppData.samplingRate = 15;
    
    try
        % RGB stack
        savePath1 = join([filePath '\' fileID1], '');
        disp('Saving RGB stack...'); disp(' ')
        save(savePath1, 'RGBStack', '-v7.3')
        % Depth stack
        savePath2 = join([filePath '\' fileID2], '');
        disp('Saving depth stack...'); disp(' ')
        save(savePath2, 'DepthStack', '-v7.3')
        % Supplemental data
        savePath3 = join([filePath '\' fileID2], '');
        disp('Saving supplemental data...'); disp(' ')
        save(savePath3, 'SuppData')
    catch
        keyboard
    end
end
disp('RealSense camera streaming - complete'); disp(' ')
f = msgbox('Data Save Complete', 'Success');
close all
