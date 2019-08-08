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

%% Draw ROIs for motion tracking
disp('Verifying that ROIs exist for each day...'); disp(' ')
depthStackDirectory = dir('*_DepthStack.mat');
depthStackFiles = {depthStackDirectory.name}';
depthStackFile = char(depthStackFiles);
supplementalFile = [depthStackFile(1:end - 15) '_SupplementalData.mat'];
if ~exist([depthStackFile(1:end - 15) '_TrueDepthStack_A.mat'])
    DrawAnalysisROIs(depthStackFile, supplementalFile);
end
depthStacks = uigetfile('Multiselect', 'on');

%% Process the depth stack frames
for b = 1:size(depthStacks,2)
    depthStackFile = depthStacks{1,b};
    if ~exist([depthStackFile(1:end-21) '_ProcDepthStack_' depthStackFile(end-4:end)], 'file')
        disp(['Processing TrueDepthStack file... (' num2str(b) '/' num2str(size(depthStacks,2)) ')']); disp(' ')
        CorrectRealSenseFrames_PatchHoles(depthStackFile, supplementalFile)
        CorrectRealSenseFrames_ImageMask(depthStackFile, supplementalFile)
        CorrectRealSenseFrames_KalmanFilter(depthStackFile)
        CorrectRealSenseFrames_MeanSub(depthStackFile)
        CorrectRealSenseFrames_Theshold(depthStackFile)
        CorrectRealSenseFrames_Binarize(depthStackFile)
        CorrectRealSenseFrames_BinOverlay(depthStackFile)
    end
end

%% Load the RGB stack camera frames, create .avi movies from data
RGBStackDirectory = dir('*RGBStack.mat');
RGBStackFiles = {RGBStackDirectory.name}';
RGBStackFile = char(RGBStackFiles);
ConvertRealSenseToAVI(RGBStackFile, supplementalFile, 'RGBStack');
CorrectColorScale(supplementalFile)
for c = 1:size(depthStacks,2)
    depthStackFile = depthStacks{1,c};
    CorrectRealSenseFrames_ResetDepth(depthStackFile, supplementalFile)
end

%% Skip combining the split files into one if they already exist
if ~exist([depthStackFile(1:end-21) '_ProcDepthStack.mat'], 'file')
    JoinProcessedFiles(depthStacks, 'processed')
end

%% Skip combining the split files into one if they already exist
if ~exist([depthStackFile(1:end-21) '_BinDepthStack.mat'], 'file')
    JoinProcessedFiles(depthStacks, 'binary')
end

%% Load the RGB stack camera frames, create .avi movies from data
procStackDirectory = dir('*ProcDepthStack.mat');
procStackFiles = {procStackDirectory.name}';
procStackFile = char(procStackFiles);
ConvertRealSenseToAVI(procStackFile, supplementalFile, 'FullyProcDepthStack');

%% Track object height
TrackObjectHeight(procStackFile, supplementalFile);

%% Track object motion in video
binStackDirectory = dir('*BinDepthStack.mat');
binStackFiles = {binStackDirectory.name}';
binStackFile = char(binStackFiles);
TrackObjectMotion(binStackFile, supplementalFile);

disp('RealSense movie analysis - complete'); disp(' ')
