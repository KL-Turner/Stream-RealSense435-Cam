function [] = ConvertRealSenseToAVI(fileName, inputType)
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

close all;

if strcmp(inputType, 'ColorizedDepthStack')
    if ~exist([fileName(1:end - 3) '_5xSpeed.avi'], 'file')
        disp('Generating colorized depth stack .AVI movie (sped-up 5X)...'); disp(' ')
        load(fileName)
        outputVideo = VideoWriter([fileName(1:end - 3) '_5xSpeed.avi']);
        outputVideo.FrameRate = RS_ColorizedDepthStack.samplingRate*5;
        open(outputVideo);
        for a = 1:length(RS_ColorizedDepthStack.colorizedDepthStack)
            disp(['Processing colorized depth stack .AVI frame... (' num2str(a) '/' num2str(length(RS_ColorizedDepthStack.colorizedDepthStack)) ')']); disp(' ') 
            writeVideo(outputVideo, im2frame(RS_ColorizedDepthStack.colorizedDepthStack{a,1}));
        end
        close(outputVideo)
        disp('Colorized depth stack 5X speed .AVI movie - complete'); disp(' ')
    else
        disp([fileName(1:end - 3) '_5xSpeed.avi already exists. Continuing...']); disp(' ')
    end
    
elseif strcmp(inputType, 'RGBStack')
    if ~exist([fileName(1:end - 3) '_5xSpeed.avi'], 'file')
        disp('Generating RGB stack .AVI movie (sped-up 5X)...'); disp(' ')
        load(fileName)
        outputVideo = VideoWriter([fileName(1:end - 3) '_5xSpeed.avi']);
        outputVideo.FrameRate = RS_RGBStack.samplingRate*5;
        open(outputVideo);
        for b = 1:length(RS_RGBStack.RGBStack)
            disp(['Processing RGB stack .AVI frame... (' num2str(b) '/' num2str(length(RS_RGBStack.RGBStack)) ')']); disp(' ')
            writeVideo(outputVideo, im2frame(RS_RGBStack.RGBStack{b,1}));
        end
        close(outputVideo)
        disp('RGB stack 5X speed .AVI movie - complete'); disp(' ')
    else
        disp([fileName(1:end - 3) '_5xSpeed.avi already exists. Continuing...']); disp(' ')
    end
    
elseif strcmp(inputType, 'HalfProcDepthStack')
    if ~exist([fileName(1:end - 3) '_5xSpeed.avi'], 'file')
        disp('Generating halfway-processed depth stack .AVI movie (sped-up 5X)...'); disp(' ')
        load(fileName) 
        outputVideo = VideoWriter([fileName(1:end - 3) '_5xSpeed.avi']);
        outputVideo.FrameRate = RS_HalfProcDepthStack.samplingRate*5;
        open(outputVideo);
        for c = 1:length(RS_HalfProcDepthStack.halfProcDepthStack)
            disp(['Processing halfway-processed depth stack .AVI frame... (' num2str(c) '/' num2str(size(RS_HalfProcDepthStack.halfProcDepthStack, 3)) ')']); disp(' ') 
            imagesc(RS_HalfProcDepthStack.halfProcDepthStack(:,:,c));
            colormap jet
            caxis(RS_HalfProcDepthStack.caxis)
            currentFrame = getframe;
            writeVideo(outputVideo, currentFrame);
        end
        close(outputVideo)
        disp('Halfway-processed depth stack 5X speed .AVI movie - complete'); disp(' ')
    else
        disp([fileName(1:end - 3) '_5xSpeed.avi already exists. Continuing...']); disp(' ')
    end
    
elseif strcmp(inputType, 'FullyProcDepthStack')
    if ~exist([fileName(1:end - 3) '_5xSpeed.avi'], 'file')
        disp('Generating fully-processed depth stack .AVI movie (sped-up 5X)...'); disp(' ')
        load(fileName) 
        outputVideo = VideoWriter([fileName(1:end - 3) '_5xSpeed.avi']);
        outputVideo.FrameRate = RS_FullyProcDepthStack.samplingRate*5;
        open(outputVideo);
        for c = 1:length(RS_FullyProcDepthStack.fullyProcDepthStack)
            disp(['Processing fully-processed depth stack .AVI frame... (' num2str(c) '/' num2str(size(RS_FullyProcDepthStack.fullyProcDepthStack, 3)) ')']); disp(' ') 
            imagesc(RS_FullyProcDepthStack.fullyProcDepthStack(:,:,c));
            colormap jet
            caxis(RS_FullyProcDepthStack.caxis)
            currentFrame = getframe;
            writeVideo(outputVideo, currentFrame);
        end
        close(outputVideo)
        disp('Fully-processed depth stack 5X speed .AVI movie - complete'); disp(' ')
    else
        disp([fileName(1:end - 3) '_5xSpeed.avi already exists. Continuing...']); disp(' ')
    end
end

end
