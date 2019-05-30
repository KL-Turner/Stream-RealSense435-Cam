function [RS_ColorizedDepthStack, RS_RGBStack, RS_TrueDepthStack] = AcquireRealSenseVideo(numFramesToAcquire)
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
RS_ColorizedDepthStack.cameraID = camName;
RS_RGBStack.cameraID = camName;
RS_TrueDepthStack.cameraID = camName;

imgMatSize = zeros(480, 640);
frameLength = cell(numFramesToAcquire, 1);
for a = 1:length(frameLength)
    frameLength{a, 1} = imgMatSize;
end
RS_ColorizedDepthStack.colorizedDepthStack = frameLength;
RS_RGBStack.RGBStack = frameLength;
RS_TrueDepthStack.trueDepthStack = frameLength;
    
% Allow camera to warm up for a few frames
for b = 1:15
    pipe.wait_for_frames();
end

frameCount = 0;
while frameCount < numFramesToAcquire
    frameCount = frameCount + 1;
    frameTime = clock;
    RS_ColorizedDepthStack.frameTime{frameCount, 1} = frameTime;
    RS_RGBStack.frameTime{frameCount, 1} = frameTime;
    RS_TrueDepthStack.frameTime{frameCount, 1} = frameTime;

    % Acquire frame, align, and get colorized data
    fs = pipe.wait_for_frames();
    alignedFrames = alignedFs.process(fs);
    
    % True color rgb image
    rgbFrame = fs.get_color_frame();
    rgbData = rgbFrame.get_data();
    RS_RGBStack.RGBStack{frameCount, 1} = permute(reshape(rgbData',[3, rgbFrame.get_width(), rgbFrame.get_height()]), [3 2 1]);

    % Pseudo-colorized depth image
    depthFrame = alignedFrames.get_depth_frame();
    depthColor = colorizer.colorize(depthFrame);
    depthData = depthColor.get_data();
    colorizedDepthImg = permute(reshape(depthData',[3, depthColor.get_width(), depthColor.get_height()]), [3 2 1]);
    imshow(colorizedDepthImg)
%     RS_ColorizedDepthStack.colorizedDepthStack{frameCount, 1} = colorizedDepthImg;
    
    % Accurate depth information, no auto-scaling of color
    depthSensor = devID.first('depth_sensor');
    depthScale = depthSensor.get_depth_scale();
    depthWidth = depthFrame.get_width();
    depthHeight = depthFrame.get_height();
    depthVector = depthFrame.get_data();
    RS_TrueDepthStack.trueDepthStack{frameCount, 1} = double(transpose(reshape(depthVector, [depthWidth, depthHeight]))).*depthScale;
end
pipe.stop();

end