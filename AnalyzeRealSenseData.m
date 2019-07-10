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

RGBStackDirectory = dir('*RGBStack.mat');
RGBStackFiles = {RGBStackDirectory.name}';
RGBStackFiles = char(RGBStackFiles);

depthStackDirectory = dir('*TrueDepthStack.mat');
depthStackFiles = {depthStackDirectory.name}';
depthStackFiles = char(depthStackFiles);

%% Draw ROIs for motion tracking
disp('Verifying that ROIs exist for each day...'); disp(' ')
for a = 1:size(depthStackFiles, 1)
    depthStackFile = depthStackFiles(a,:);
    delimiters = strfind(depthStackFile, '_');
    date = depthStackFile(1:delimiters(4) - 1);
    supplementalFile = [date '_SupplementalData.mat'];
    if ~exist(supplementalFile, 'file')
        DrawAnalysisROIs(depthStackFile);
    else
        disp('Supplemental data file exists. Continuing...'); disp(' ')
    end
end

%% Process the depth stack frames
for b = 1:size(depthStackFiles, 1)
    depthStackFile = depthStackFiles(b,:);
    disp(['Processing TrueDepthStack file... (' num2str(b) '/' num2str(size(depthStackFiles, 1)) ')']); disp(' ')
    if ~exist([depthStackFile(1:end - 19) '_ProcDepthStack.mat'], 'file')
        disp(['Processing video from ' depthStackFile '...']); disp(' ')
        delimiters = strfind(depthStackFile, '_');
        date = depthStackFile(1:delimiters(4) - 1);
        supplementalFile = [date '_SupplementalData.mat'];
        CorrectRealSenseFrames_PatchHoles(depthStackFile, supplementalFile);
        CorrectRealSenseFrames_ImageMask(depthStackFile, supplementalFile)
        CorrectRealSenseFrames_KalmanFilter(depthStackFile)
        CorrectRealSenseFrames_MeanSub(depthStackFile)
        CorrectRealSenseFrames_Theshold(depthStackFile)
        CorrectRealSenseFrames_Binarize(depthStackFile)
        CorrectRealSenseFrames_BinOverlay1(depthStackFile)
        CorrectRealSenseFrames_BinOverlay2(depthStackFile)
        CorrectRealSenseFrames_JoinOverlays(depthStackFile)
        CorrectRealSenseFrames_ResetDepth(depthStackFile)
    else
        disp([depthStackFile(1:end - 19) '_ProcDepthStack.mat already exists. Continuing...']); disp(' ')
    end
end

procDepthStackDirectory = dir('*ProcDepthStack.mat');
procDepthStackFiles = {procDepthStackDirectory.name}';
procDepthStackFiles = char(procDepthStackFiles);

% %% Load the RGB stack camera frames, create .avi movies from data
% for c = 1:size(RGBStackFiles, 1)
%     RGBStackFile = RGBStackFiles(c,:);
%     disp(['Creating RGB Stack .AVI files... (' num2str(c) '/' num2str(size(RGBStackFiles, 1)) ')']); disp(' ')
%     ConvertRealSenseToAVI(RGBStackFile, 'RGBStack');
% end
% 
% %% Load the RGB stack camera frames, create .avi movies from data
% for d = 1:size(procDepthStackFiles, 1)
%     procDepthStackFile = procDepthStackFiles(d,:);
%     disp(['Creating Proc Depth Stack Stack .AVI files... (' num2str(d) '/' num2str(size(procDepthStackFiles, 1)) ')']); disp(' ')
%     ConvertRealSenseToAVI(procDepthStackFile, 'FullyProcDepthStack');
% end
% 
% %% Track object height
% for g = 1:size(procDepthStackFiles, 1)
%     rsFullyProcDepthStackFile = procDepthStackFiles(g,:);
%     disp(['Tracking mouse height in fully-processed depth stack... (' num2str(g) '/' num2str(size(procDepthStackFiles, 1)) ')']); disp(' ')
%     TrackObjectHeight(rsFullyProcDepthStackFile);
% end
% 
% %% Track object motion in video
% % [] = TrackObjectMotion()
% close all
% disp('RealSense movie analysis - complete'); disp(' ')
