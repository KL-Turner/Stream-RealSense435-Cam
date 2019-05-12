function [] = ConvertRealSenseToAVI(fileName, defaultSamplingRate)

load(fileName)
if ~exist([fileName(1:end-4) '.avi'], 'file')
    disp('Generating movie (sped-up 5X)...'); disp(' ')
    outputVideo = VideoWriter([fileName(1:end-4) '.avi']);
    outputVideo.FrameRate = defaultSamplingRate*5;
    
    open(outputVideo);
    for a = 1:length(RealSenseData.colorizedData)
        writeVideo(outputVideo, im2frame(RealSenseData.colorizedData{a,1}));
    end
    close(outputVideo)
    disp('Movie complete'); disp(' ')
else
    disp([fileName(1:end-4) '.avi already exists. Continuing...']); disp(' ')
end

end