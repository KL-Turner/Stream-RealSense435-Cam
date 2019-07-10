function DrawAnalysisROIs(depthStackFile)
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

load(depthStackFile)
frame = trueDepthStack.trueDepthStack{1,1};
supplementalFile = [depthStackFile(1:end - 28) '_SupplementalData.mat'];

%% Cage region of interest
yString = 'y';
theInput = 'n';
while strcmp(yString, theInput) ~= 1
    % Draw ROI
    disp('Draw a rectanglular ROI around the cage'); disp(' ')
    
    h1 = openfig('cageRefImg.fig', 'invisible');
    ax1 = gca(h1);
    fig1 = get(ax1, 'children');
    
    drawROI = figure;
    subplot(1,2,1);
    imagesc(fig1(2,1).CData);
    hold on;
    rectangle('Position', fig1(1,1).Position, 'Curvature', 0.25, 'LineWidth', 3, 'EdgeColor', 'white')
    title('Cage reference image - Corners round automatically');
    axis image
    axis off
    
    subplot(1,2,2)
    imagesc(frame)
    title('Click and drag a box around the cage');
    axis image
    axis off
    cageROI = drawrectangle();
    SuppData.cage = cageROI.Position;
    close(drawROI)
    
    % Verify ROI
    checkROI = figure;
    subplot(1,2,1)
    imagesc(fig1(2,1).CData);
    hold on;
    rectangle('Position', fig1(1,1).Position, 'Curvature', 0.25, 'LineWidth', 3, 'EdgeColor', 'white')
    title('Cage reference image');
    axis image
    axis off
    
    subplot(1,2,2)
    imagesc(frame);
    hold on;
    cageRectangle = SuppData.cage;
    rectangle('Position',cageRectangle, 'Curvature', 0.25, 'LineWidth', 3, 'EdgeColor', 'white')
    title('White box shows the cage ROI');
    axis image
    axis off
    theInput = input('Is the rectangle accurate? (y/n): ', 's'); disp(' ')
    try
        close(checkROI)
    catch
    end
end

SuppData.cameraID = RS_TrueDepthStack.cameraID;
SuppData.frameTime = RS_TrueDepthStack.frameTime;
SuppData.numFrames = RS_TrueDepthStack.numFrames;
SuppData.trialDuration = RS_TrueDepthStack.trialDuration;
SuppData.samplingRate = RS_TrueDepthStack.samplingRate;

save(supplementalFile, 'SuppData')

end

