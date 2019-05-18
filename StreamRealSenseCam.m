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
minInput = input('How many minutes would you like to stream for?: '); disp(' ')
numTrials = ceil(minInput/5);
trialDuration = 5*60;
defaultSamplingRate = 15;
numFramesToAcquire = trialDuration*defaultSamplingRate;

%% Acquire data - Run for set number of desired minutes. 5 minute increments
for a = 1:numTrials
    currentTime = strrep(strrep(strrep(string(datetime), ' ', '_'), ':', '_'), '-', '_');
    fileID = join([currentTime '_RS_RawData.mat'], '');
    disp(['Acquiring RealSense camera video for ' num2str(trialDuration) ' seconds. FileID: ' fileID]); disp(' ')
    [RS_RawData] = AcquireRealSenseVideo(numFramesToAcquire);
    RS_RawData.numFrames = numFramesToAcquire;
    RS_RawData.trialDuration = trialDuration;
    RS_RawData.samplingRate = defaultSamplingRate;
    disp(['Saving ' fileID '...']); disp(' ')
    save(fileID, 'RS_RawData', '-v7.3')
end
disp('RealSense camera streaming - complete'); disp(' ')

%% Create .avi movies from the raw rgb data
rsRawDataDirectory = dir('*RS_RawData.mat');
rsRawDataFiles = {rsRawDataDirectory.name}';
rsRawDataFiles = char(rsRawDataFiles);
for b = 1:size(rsRawDataFiles, 1)
    load(rsRawDataFiles(b, :))
    disp(['Generating .avi file (' num2str(b) '/' num2str(size(rsRawDataFiles,1)) '): ' rsRawDataFiles(b,:)]); disp(' ')
    ConvertRealSenseToAVI(RS_RawData, rsRawDataFiles(b,:), 'raw');
end
disp('RealSense raw avi movie creation - complete'); disp(' ')

end
