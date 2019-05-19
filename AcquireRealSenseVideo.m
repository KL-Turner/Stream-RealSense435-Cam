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
align_to = realsense.stream.color;
alignedFs = realsense.align(align_to);

profile = pipe.start();
devID = profile.get_device();
camName = devID.get_info(realsense.camera_info.name);

% Pre-allocate image size and number of frames
RS_RawData.cameraID = camName;
imgMatSize = zeros(480, 640);
frameLength = cell(numFramesToAcquire, 1);
for a = 1:length(frameLength)
    frameLength{a, 1} = imgMatSize;
end
RS_RawData.rgbImg = frameLength;
RS_RawData.colorizedDepthImg = frameLength;
RS_RawData.depthImg = frameLength;
    
% Allow camera to warm up for a few frames
for b = 1:15
    pipe.wait_for_frames();
end

frameCount = 0;
while frameCount < numFramesToAcquire
    frameTime = clock;
    RS_RawData.frameTime{frameCount, 1} = frameTime;

    % Acquire frame, align, and get colorized data
    frameCount = frameCount + 1;
    fs = pipe.wait_for_frames();
    alignedFrames = alignedFs.process(fs);
    
    % True color rgb image
    rgbFrame = fs.get_color_frame();
    rgbData = rgbFrame.get_data();
    RS_RawData.rgbImg{frameCount, 1} = permute(reshape(rgbData',[3, rgbFrame.get_width(), rgbFrame.get_height()]), [3 2 1]);

    % Pseudo-colorized depth image
    depthFrame = alignedFrames.get_depth_frame();
    depthColor = colorizer.colorize(depthFrame);
    depthData = depthColor.get_data();
    colorizedDepthImg = permute(reshape(depthData',[3, depthColor.get_width(), depthColor.get_height()]), [3 2 1]);
    imshow(colorizedDepthImg)
    RS_RawData.colorizedDepthImg{frameCount, 1} = colorizedDepthImg;
    
    % Accurate depth information, no auto-scaling of color
    depthSensor = devID.first('depth_sensor');
    depthScale = depthSensor.get_depth_scale();
    depthWidth = depthFrame.get_width();
    depthHeight = depthFrame.get_height();
    depthVector = depthFrame.get_data();
    RS_RawData.depthImg{frameCount, 1} = double(transpose(reshape(depthVector, [depthWidth, depthHeight]))).*depthScale;
end
pipe.stop();

end