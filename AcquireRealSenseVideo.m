function [RealSenseData] = AcquireRealSenseVideo(numFramesToAcquire)
% Setup RealSense camera
pipe = realsense.pipeline();
colorizer = realsense.colorizer();
profile = pipe.start();
align_to = realsense.stream.color;
alignedFs = realsense.align(align_to);
devID = profile.get_device();

% Allow camera to warm up for a few frames
for i = 1:15
    pipe.wait_for_frames();    
end

frameCount = 0;
while frameCount < numFramesToAcquire
    % Acquire frame, align, and get colorized data
    frameCount = frameCount + 1;
    fs = pipe.wait_for_frames();
    aligned_frames = alignedFs.process(fs);
    depth = aligned_frames.get_depth_frame();
    color = colorizer.colorize(depth);
    colordata = color.get_data();

    % Create colorized image, save to struct with current frametime
    img = permute(reshape(colordata',[3,color.get_width(),color.get_height()]),[3 2 1]);
    frameTime = clock;
    RealSenseData.frameTime{frameCount,1} = frameTime;
    RealSenseData.colorizedData{frameCount,1} = img;
    imshow(img)
    
    % Extract accurate depth information, save to struct
    depthSensor = devID.first('depth_sensor');
    depthScale = depthSensor.get_depth_scale();
    depthWidth = depth.get_width();
    depthHeight = depth.get_height();
    depthVector = depth.get_data();
    RealSenseData.depthMap{frameCount,1} = double(transpose(reshape(depthVector, [depthWidth, depthHeight]))).*depthScale;
end
pipe.stop();

end