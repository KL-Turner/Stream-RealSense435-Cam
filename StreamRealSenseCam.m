function StreamRealSenseCam
clear
clc
minInput = input('How many minutes would you like to stream for?: '); disp(' ')
numTrials = ceil(minInput/5);
trialDuration = 5*60;
defaultSamplingRate = 15;
numFramesToAcquire = trialDuration*defaultSamplingRate;

% Run for set number of desired minutes. 5 minute increments
for a = 1:numTrials
    currentTime = strrep(strrep(strrep(string(datetime), ' ', '_'), ':', '_'), '-', '_');
    fileID = join([currentTime '_RealSenseData.mat'], '');
    disp(['Acquiring RealSense camera video for ' num2str(trialDuration) ' seconds. FileID: ' fileID]); disp(' ')
    [RealSenseData] = AcquireRealSenseVideo(numFramesToAcquire);
    save(fileID, 'RealSenseData', '-v7.3')
end
disp('RealSense camera streaming - complete'); disp(' ')

completedDataFiles = ls('*RealSenseData.mat');
for b = 1:size(completedDataFiles, 1)
    disp(['Generating .avi file (' num2str(b) '/' num2str(size(completedDataFiles,1)) '): ' completedDataFiles(b,:)]); disp(' ')
    ConvertRealSenseToAVI(completedDataFiles(b,:), defaultSamplingRate);
end
disp('RealSense avi file creation - complete'); disp(' ')

end