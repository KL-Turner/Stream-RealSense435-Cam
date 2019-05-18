function [] = AnalyzeRealSenseData()
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
rsRawDataDirectory = dir('*RS_RawData.mat');
rsRawDataFiles = {rsRawDataDirectory.name}';
rsRawDataFiles = char(rsRawDataFiles);

%% Draw ROIs for motion tracking
disp('Verifying that ROIs exist for each day...'); disp(' ')
for a = 1:size(rsRawDataFiles, 1)
    rsRawDataFile = rsRawDataFiles(a,:);
    delimiters = strfind(rsRawDataFile, '_');
    date = rsRawDataFile(1:delimiters(3) - 1);
    roiFile = [date '_ROIs.mat'];
    if ~exist(roiFile)
        disp(['Loading ' rsRawDataFile '...']); disp(' ')
        load(rsRawDataFile)
        [ROIs] = DrawAnalysisROIs(RS_RawData);
        save(roiFile, 'ROIs')
    end
end

%% Process the raw camera frames, create .avi movie from processed data
for b = 1:size(rsRawDataFiles, 1)
    rsRawDataFile = rsRawDataFiles(b,:);
    disp(['Analyzing RS_RawData file... (' num2str(b) '/' num2str(size(rsRawDataFiles, 1)) ')']); disp(' ')
    if ~exist([rsRawDataFile(1:end - 14) 'RS_ProcData.mat'])
        disp(['Processing video from ' rsRawDataFile '...']); disp(' ')
        load(rsRawDataFile);
        delimiters = strfind(rsRawDataFile, '_');
        date = rsRawDataFile(1:delimiters(3) - 1);
        roiFile = [date '_ROIs.mat'];
        load(roiFile)
        [RS_ProcData, ROIs] = CorrectRealSenseFrames(RS_RawData, ROIs);
        disp(['Saving ' rsRawDataFile(1:end - 14) 'RS_ProcData.mat...']); disp(' ')
        save(roiFile, 'ROIs')
        save([rsRawDataFile(1:end - 14) 'RS_ProcData.mat'], 'RS_ProcData', '-v7.3')
    else
        disp([rsRawDataFile(1:end - 14) 'RS_ProcData.mat already exists. Continuing...']); disp(' ')
    end
    rsProcDataFile = [rsRawDataFile(1:end - 14) 'RS_ProcData.mat'];
    ConvertRealSenseToAVI(rsProcDataFile, 'proc');
end

%% Overlay original color onto image mask
clear
rsRawDataDirectory = dir('*RS_RawData.mat');
rsRawDataFiles = {rsRawDataDirectory.name}';
rsRawDataFiles = char(rsRawDataFiles);

rsProcDataDirectory = dir('*RS_ProcData.mat');
rsProcDataFiles = {rsProcDataDirectory.name}';
rsProcDataFiles = char(rsProcDataFiles);
for c = 1:size(rsProcDataFiles, 1)
    rsRawDataFile = rsRawDataFiles(c,:);
    rsProcDataFile = rsProcDataFiles(c,:);
    disp(['Analyzing RS_ProcData file... (' num2str(c) '/' num2str(size(rsProcDataFiles, 1)) ')']); disp(' ')
    if ~exist([rsProcDataFile(1:end - 15) 'RS_FinalData.mat'])
        disp(['Processing video from ' rsProcDataFile '...']); disp(' ')
        load(rsProcDataFile);
        load(rsRawDataFile);
        delimiters = strfind(rsProcDataFile, '_');
        date = rsProcDataFile(1:delimiters(3) - 1);
        roiFile = [date '_ROIs.mat'];
        load(roiFile)
        [RS_FinalData] = FinishRealSenseFrames(RS_RawData, RS_ProcData);
        disp(['Saving ' rsProcDataFile(1:end - 15) 'RS_FinalData.mat...']); disp(' ')
        save(roiFile, 'ROIs')
        save([rsProcDataFile(1:end - 15) 'RS_FinalData.mat'], 'RS_FinalData', '-v7.3')
    else
        disp([rsProcDataFile(1:end - 15) 'RS_FinalData.mat already exists. Continuing...']); disp(' ')
    end
    rsFinalDataFile = [rsProcDataFile(1:end - 15) 'RS_FinalData.mat'];
    ConvertRealSenseToAVI(rsFinalDataFile(c,:), 'final');
end


%% Track object motion in video






















end