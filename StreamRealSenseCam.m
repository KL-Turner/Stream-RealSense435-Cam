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
    fileID = join([currentTime '_RawRealSenseData.mat'], '');
    disp(['Acquiring RealSense camera video for ' num2str(trialDuration) ' seconds. FileID: ' fileID]); disp(' ')
    [RawRealSenseData] = AcquireRealSenseVideo(numFramesToAcquire);
    save(fileID, 'RawRealSenseData', '-v7.3')
end
disp('RealSense camera streaming - complete'); disp(' ')

%% Create .avi movies from the raw rgb data
realsenseDirectory = dir('*RawRealSenseData.mat');
realsenseFiles = {realsenseDirectory.name}';
realsenseFiles = char(realsenseFiles);
for b = 1:size(realsenseFiles, 1)
    load(realsenseFiles(b, :))
    disp(['Generating .avi file (' num2str(b) '/' num2str(size(realsenseFiles,1)) '): ' realsenseFiles(b,:)]); disp(' ')
    ConvertRealSenseToAVI(RawRealSenseData, realsenseFiles(b,:), defaultSamplingRate, 'raw');
end
disp('RealSense raw avi movie creation - complete'); disp(' ')

%% Process the raw camera frames, create .avi movie from processed data
for c = 1:size(realsenseFiles, 1)
    realsenseFile = realsenseFiles(c,:);
    load(realsenseFile);
    [ProcRealSenseData] = CorrectRealSenseFrames(RawRealSenseData);
    ConvertRealSenseToAVI(ProcRealSenseData, realsenseFiles(c,:), defaultSamplingRate, 'proc');
    save([realsenseFile(1:end - 17) 'ProcRealSenseData.mat'], 'ProcRealSenseData', '-v7.3')
end

end