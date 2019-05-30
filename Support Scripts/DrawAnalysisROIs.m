function [ROIs] = DrawAnalysisROIs(RS_TrueDepthStack)
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

%% Mouse region of interest
frame = RS_TrueDepthStack.trueDepthStack{1,1};
% yString = 'y';
% theInput = 'n';
% while strcmp(yString, theInput) ~= 1
%     % Draw ROI
%     disp('Draw a rectanglular ROI around the mouse'); disp(' ')
%     
%     h1 = openfig('mouseRefImg.fig', 'invisible');
%     ax1 = gca(h1);
%     fig1 = get(ax1, 'children');
%    
%     drawROI = figure;
%     subplot(1,2,1);
%     imagesc(fig1(2,1).CData);
%     hold on;
%     rectangle('Position', fig1(1,1).Position, 'LineWidth', 3, 'EdgeColor', 'white')
%     title('Mouse reference image');
%     axis image
%     axis off
%     
%     subplot(1,2,2)
%     imagesc(frame)
%     title('Click and drag a small box around the mouse');
%     axis image
%     axis off
%     mouseROI = drawrectangle('AspectRatio', 1, 'FixedAspectRatio', true);
%     ROIs.mouse = mouseROI.Position;
%     close(drawROI)
%     
%     % Verify ROI
%     checkROI = figure;
%     subplot(1,2,1)
%     imagesc(fig1(2,1).CData);
%     hold on;
%     rectangle('Position', fig1(1,1).Position, 'LineWidth', 3, 'EdgeColor', 'white')
%     title('Mouse reference image');
%     axis image
%     axis off
%     
%     subplot(1,2,2)
%     imagesc(frame);
%     hold on;
%     mouseRectangle = ROIs.mouse;
%     rectangle('Position', mouseRectangle, 'LineWidth', 3, 'EdgeColor', 'white')
%     title('White box shows the mouse ROI');
%     axis image
%     axis off
%     theInput = input('Is the rectangle accurate? (y/n): ', 's'); disp(' ')
%     try
%         close(checkROI)
%     catch
%     end
% end

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
    ROIs.cage = cageROI.Position;
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
    cageRectangle = ROIs.cage;
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

%% Reference platform region of interest
% yString = 'y';
% theInput = 'n';
% while strcmp(yString, theInput) ~= 1
%     % Draw ROI
%     disp('Draw a rectanglular ROI around the reference platform'); disp(' ')
%     
%     h1 = openfig('heightRefImg.fig', 'invisible');
%     ax1 = gca(h1);
%     fig1 = get(ax1, 'children');
%     
%     drawROI = figure;
%     subplot(1,2,1);
%     imagesc(fig1(2,1).CData);
%     hold on;
%     rectangle('Position', fig1(1,1).Position, 'LineWidth', 3, 'EdgeColor', 'white')
%     title('Platform reference image');
%     axis image
%     axis off
%     
%     subplot(1,2,2)
%     imagesc(frame)
%     title('Click and drag a small box around the reference platform');
%     axis image
%     axis off
%     platformROI = drawrectangle();
%     ROIs.platform = platformROI.Position;
%     close(drawROI)
%     
%     % Verify ROI
%     checkROI = figure;
%     subplot(1,2,1)
%     imagesc(fig1(2,1).CData);
%     hold on;
%     rectangle('Position', fig1(1,1).Position, 'LineWidth', 3, 'EdgeColor', 'white')
%     title('Platform reference image');
%     axis image
%     axis off
%     
%     subplot(1,2,2)
%     imagesc(frame);
%     hold on;
%     platformRectangle = ROIs.platform;
%     rectangle('Position', platformRectangle, 'LineWidth', 3, 'EdgeColor', 'white')
%     title('White box shows the platform ROI');
%     axis image
%     axis off
%     theInput = input('Is the rectangle accurate? (y/n): ', 's'); disp(' ')
%     try
%         close(checkROI)
%     catch
%     end
end

