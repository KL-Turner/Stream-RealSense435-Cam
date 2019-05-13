
disp('Generating movie (sped-up 5X)...'); disp(' ')
outputVideo = VideoWriter('testMovie.avi');
outputVideo.FrameRate = 100;
open(outputVideo);

for a = 1:length(RealSenseData.data)
    writeVideo(outputVideo, im2frame(RealSenseData.data{a,2}));
end

close(outputVideo)
disp('Movie complete')