function StreamRealSenseCam
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
%   Last Revised: May 12th, 2019
%________________________________________________________________________________________________________________________

clear
clc
minInput = input('How many minutes would you like to stream for?: '); disp(' ')
numTrials = ceil(minInput/5);
trialDuration = 5*60;
defaultSamplingRate = 15;
numFramesToAcquire = trialDuration*defaultSamplingRate;

%% Acquire data - Run for set number of desired minutes. 5 minute increments
for a = 1:numTrials
    currentTime = strrep(strrep(strrep(string(datetime), ' ', '_'), ':', '_'), '-', '_');
    fileID = join([currentTime '_RealSenseData.mat'], '');
    disp(['Acquiring RealSense camera video for ' num2str(trialDuration) ' seconds. FileID: ' fileID]); disp(' ')
    [RealSenseData] = AcquireRealSenseVideo(numFramesToAcquire);
    save(fileID, 'RealSenseData', '-v7.3')
end
disp('RealSense camera streaming - complete'); disp(' ')

%% Create .avi movies from the raw rgb data
completedDataFiles = ls('*RealSenseData.mat');
for b = 1:size(completedDataFiles, 1)
    load(completedDataFiles(b, :))
    disp(['Generating .avi file (' num2str(b) '/' num2str(size(completedDataFiles,1)) '): ' completedDataFiles(b,:)]); disp(' ')
    ConvertRealSenseToAVI(RealSenseData, completedDataFiles(b,:), defaultSamplingRate, 'raw');
end
disp('RealSense raw avi movie creation - complete'); disp(' ')

%% Process the raw camera frames, create .avi movie from processed data
for c = 1:size(completedDataFiles, 1)
    load(completedDataFiles(c,:));
    [RealSenseData] = CorrectRealSenseFrames(RealSenseData);
    ConvertRealSenseToAVI(RealSenseData, completedDataFiles(c,:), defaultSamplingRate, 'proc');
    save(fileID, 'RealSenseData', '-v7.3')
end

end