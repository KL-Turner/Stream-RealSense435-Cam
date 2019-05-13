function [] = ConvertRealSenseToAVI(RealSenseData, fileName, defaultSamplingRate, inputType)
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

close all;

if strcmp(inputType, 'raw')
    if ~exist([fileName(1:end - 17) 'RawMovie_5xSpeed.avi'], 'file')
        disp('Generating movie (sped-up 5X)...'); disp(' ')
        outputVideo = VideoWriter([fileName(1:end - 17) 'RawMovie_5xSpeed.avi']);
        outputVideo.FrameRate = defaultSamplingRate*5;
        open(outputVideo);
        for a = 1:length(RealSenseData.colorizedData)
            writeVideo(outputVideo, im2frame(RealSenseData.colorizedData{a,1}));
        end
        close(outputVideo)
        disp('Movie complete'); disp(' ')
    else
        disp([fileName(1:end - 17) 'RawMovie_5xSpeed.avi already exists. Continuing...']); disp(' ')
    end
elseif strcmp(inputType, 'proc')
    if ~exist([fileName(1:end - 17) 'ProcMovie_5xSpeed.avi'], 'file')
        disp('Generating movie (sped-up 5X)...'); disp(' ')
        outputVideo = VideoWriter([fileName(1:end - 17) 'ProcMovie_5xSpeed.avi']);
        outputVideo.FrameRate = defaultSamplingRate*5;
        open(outputVideo);
        for b = 1:length(RealSenseData.correctedImageStack)
            imagesc(RealSenseData.correctedImageStack(:,:,b));
            colormap jet
            caxis(RealSenseData.caxis)
            currentFrame = getframe;
            writeVideo(outputVideo, currentFrame);
        end
        close(outputVideo)
        disp('Movie complete'); disp(' ')
    else
        disp([fileName(1:end - 17) 'ProcMovie_5xSpeed.avi already exists. Continuing...']); disp(' ')
    end
end

end
