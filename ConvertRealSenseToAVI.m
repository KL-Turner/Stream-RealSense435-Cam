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

if strcmp(inputType, 'raw')
    if ~exist([fileName(1:end - 14) 'RawMovie_5xSpeed.avi'], 'file')
        disp('Generating movie (sped-up 5X)...'); disp(' ')
        load(fileName)
        outputVideo = VideoWriter([fileName(1:end - 14) 'RawMovie_5xSpeed.avi']);
        outputVideo.FrameRate = RS_RawData.samplingRate*5;
        open(outputVideo);
        for a = 1:length(RS_RawData.colorizedDepthImg)
            disp(['Processing RawData .AVI frame... (' num2str(a) '/' num2str(length(RS_RawData.colorizedDepthImg)) ')']); disp(' ') 
            writeVideo(outputVideo, im2frame(RS_RawData.colorizedDepthImg{a,1}));
        end
        close(outputVideo)
        disp('Auto-colorized, unprocessed .AVI movie - complete'); disp(' ')
    else
        disp([fileName(1:end - 14) 'RawMovie_5xSpeed.avi already exists. Continuing...']); disp(' ')
    end
    
    if ~exist([fileName(1:end - 14) 'RGB_5xSpeed.avi'], 'file')
        try
        disp('Generating RGB .AVI movie (sped-up 5X)...'); disp(' ')
        outputVideo = VideoWriter([fileName(1:end - 14) 'RGB_5xSpeed.avi']);
        outputVideo.FrameRate = RS_RawData.samplingRate*5;
        open(outputVideo);
        for b = 1:length(RS_RawData.rgbImg)
            disp(['Processing RGB .AVI frame... (' num2str(b) '/' num2str(length(RS_RawData.rgbImg)) ')']); disp(' ') 
            writeVideo(outputVideo, im2frame(RS_RawData.rgbImg{b,1}));
        end
        close(outputVideo)
        disp('RGB .AVI movie - complete'); disp(' ')
        catch
            disp([fileName(1:end - 14) ' has no RGB data. Continuing...']); disp(' ')
        end
    else
        disp([fileName(1:end - 14) 'RGB_5xSpeed.avi already exists. Continuing...']); disp(' ')
    end
    
elseif strcmp(inputType, 'proc')
    if ~exist([fileName(1:end - 15) 'ProcMovie_5xSpeed.avi'], 'file')
        disp('Generating movie (sped-up 5X)...'); disp(' ')
        load(fileName) 
        outputVideo = VideoWriter([fileName(1:end - 15) 'ProcMovie_5xSpeed.avi']);
        outputVideo.FrameRate = RS_ProcData.samplingRate*5;
        open(outputVideo);
        for c = 1:length(RS_ProcData.procImgStack)
            disp(['Processing .AVI frame... (' num2str(c) '/' num2str(size(RS_ProcData.procImgStack, 3)) ')']); disp(' ') 
            imagesc(RS_ProcData.procImgStack(:,:,c));
            colormap jet
            caxis(RS_ProcData.caxis)
            currentFrame = getframe;
            writeVideo(outputVideo, currentFrame);
        end
        close(outputVideo)
        disp('Processed .AVI movie - complete'); disp(' ')
    else
        disp([fileName(1:end - 15) 'ProcMovie_5xSpeed.avi already exists. Continuing...']); disp(' ')
    end
    
elseif strcmp(inputType, 'final')
    if ~exist([fileName(1:end - 16) 'FinalMovie_5xSpeed.avi'], 'file')
        disp('Generating movie (sped-up 5X)...'); disp(' ')
        load(fileName)
        outputVideo = VideoWriter([fileName(1:end - 16) 'FinalMovie_5xSpeed.avi']);
        outputVideo.FrameRate = RS_FinalData.samplingRate*5;
        open(outputVideo);
        for d = 1:length(RS_FinalData.imgStack)
            disp(['Processing .AVI frame... (' num2str(d) '/' num2str(size(RS_FinalData.imgStack, 3)) ')']); disp(' ')
            imagesc(RS_FinalData.imgStack(:,:,d));
            colormap jet
            caxis(RS_FinalData.caxis)
            currentFrame = getframe;
            writeVideo(outputVideo, currentFrame);
        end
        close(outputVideo)
        disp('Final .AVI movie - complete'); disp(' ')
    else
        disp([fileName(1:end - 16) 'FinalMovie_5xSpeed.avi already exists. Continuing...']); disp(' ')
    end
end

end
