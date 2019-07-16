function [] = ConvertRealSenseToAVI(fileName, supplementalFile, inputType)
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
load(supplementalFile)
if strcmp(inputType, 'RGBStack')
    if ~exist([fileName(1:end-4) '_5xSpeed.avi'], 'file')
        disp('Generating RGB stack .AVI movie (sped-up 5X)...'); disp(' ')
        load(fileName)
        outputVideo = VideoWriter([fileName(1:end-4) '_5xSpeed.avi']);
        outputVideo.FrameRate = SuppData.samplingRate*5;
        open(outputVideo);
        for a = 1:length(RS_RGBStack.RGBStack)
            disp(['Processing RGB stack .AVI frame... (' num2str(a) '/' num2str(length(RS_RGBStack.RGBStack)) ')']); disp(' ')
            writeVideo(outputVideo, im2frame(RS_RGBStack.RGBStack{a,1}));
        end
        close(outputVideo)
        disp('RGB stack 5X speed .AVI movie - complete'); disp(' ')
    else
        disp([fileName(1:end-4) '_5xSpeed.avi already exists. Continuing...']); disp(' ')
    end
        
elseif strcmp(inputType, 'FullyProcDepthStack')
    if ~exist([fileName(1:end-4) '_5xSpeed.avi'], 'file')
        disp('Generating fully-processed depth stack .AVI movie (sped-up 5X)...'); disp(' ')
        load(fileName) 
        outputVideo = VideoWriter([fileName(1:end-4) '_5xSpeed.avi']);
        outputVideo.FrameRate = SuppData.samplingRate*5;
        open(outputVideo);
        cMin(1,1) = SuppData.depthStack_A.caxis(1,1);
        cMin(1,2) = SuppData.depthStack_B.caxis(1,1); 
        cMin(1,3) = SuppData.depthStack_C.caxis(1,1); 
        caxisMin = min(cMin);
        
        cMax(1,1) = SuppData.depthStack_A.caxis(1,2);
        cMax(1,2) = SuppData.depthStack_B.caxis(1,2);
        cMax(1,3) = SuppData.depthStack_C.caxis(1,2);
        caxisMax = max(cMax);
        
        SuppData.caxis = [caxisMin caxisMax];
        save(supplementalFile, 'SuppData')
        for b = 1:length(procDepthStack)
            disp(['Processing fully-processed depth stack .AVI frame... (' num2str(b) '/' num2str(size(procDepthStack,3)) ')']); disp(' ') 
            imagesc(procDepthStack(:,:,b));
            colormap jet
            caxis(SuppData.caxis)
            currentFrame = getframe;
            writeVideo(outputVideo, currentFrame);
        end
        close(outputVideo)
        disp('Fully-processed depth stack 5X speed .AVI movie - complete'); disp(' ')
    else
        disp([fileName(1:end-4) '_5xSpeed.avi already exists. Continuing...']); disp(' ')
    end
end

end
