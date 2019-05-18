function [RS_RawData] = AcquireRealSenseVideo(numFramesToAcquire)
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
    trueColor = fs.get_color_frame();
    colorData = trueColor.get_data();
    colorImg = permute(reshape(colorData',[3,trueColor.get_width(),trueColor.get_height()]),[3 2 1]);

    % Create colorized image, save to struct with current frametime
    img = permute(reshape(colordata',[3,color.get_width(),color.get_height()]),[3 2 1]);
    frameTime = clock;
    RS_RawData.frameTime{frameCount,1} = frameTime;
    RS_RawData.colorImg{frameCount,1} = img;
    RS_RawData.irImg{frameCount,1} = colorImg;

    % Extract accurate depth information, save to struct
    depthSensor = devID.first('depth_sensor');
    depthScale = depthSensor.get_depth_scale();
    depthWidth = depth.get_width();
    depthHeight = depth.get_height();
    depthVector = depth.get_data();
    RS_RawData.depthImg{frameCount,1} = double(transpose(reshape(depthVector, [depthWidth, depthHeight]))).*depthScale;
    imshow(img)
end
pipe.stop();

end