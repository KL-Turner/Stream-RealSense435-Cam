function [] = TrackObjectMotion(ProcRealSenseData)

aviFile = uigetfile('*.avi'); 
videoFileReader = vision.VideoFileReader(aviFile);
objectFrame = videoFileReader();

yString = 'y';
theInput = 'n';
while strcmp(yString, theInput) ~= 1
    disp('Draw a rectanglular ROI around the mouse'); disp(' ')
    drawROI = figure;
    imshow(objectFrame);
    title('Click and drag a small box around the mouse');
    mouseROI = drawrectangle();
    objectRegion = mouseROI.Position;
    objectImage = insertShape(objectFrame,'Rectangle',objectRegion,'Color','red');
    close(drawROI)
    
    checkROI = figure;
    imshow(objectImage);
    title('Red box shows the object region');
    theInput = input('Is the rectangle accurate? (y/n): ', 's'); disp(' ')
    close(checkROI)
end

videoPlayer = vision.VideoPlayer('Position',[100,100,680,520]);

points = detectMinEigenFeatures(rgb2gray(objectFrame),'ROI',objectRegion);
pointImage = insertMarker(objectFrame,points.Location,'+','Color','white');
figure;
imshow(pointImage);
title('Detected interest points');

tracker = vision.PointTracker('MaxBidirectionalError',1);
initialize(tracker,points.Location,objectFrame);

while ~isDone(videoFileReader)
      frame = videoFileReader();
      [points, validity] = tracker(frame)
      out = insertMarker(frame,points(validity, :),'+');
      videoPlayer(out);
end

release(videoPlayer);
release(videoFileReader);

