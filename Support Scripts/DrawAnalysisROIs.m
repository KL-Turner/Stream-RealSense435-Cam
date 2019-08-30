function DrawAnalysisROIs(depthStackFile, supplementalFile)
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
frame = DepthStack{1,1};
load(supplementalFile)

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

%% Mouse region of interest
disp('Draw an ROI around the mouse'); disp(' ')
drawROI = figure;
imagesc(frame)
title('Click and drag an ROI around the mouse');
colormap jet
axis image
axis off
mouseROI = roipoly();
SuppData.mouseBodyVal = mean(frame(mouseROI));
close(drawROI)

%% Pixel distance
disp('Draw a line the width of the bin'); disp(' ')
drawROI = figure;
imagesc(frame)
title('Click and drag an a line the width of the bin');
colormap jet
axis image
axis off
cageROI = drawline();
SuppData.mouseBodyVal = mean(frame(mouseROI));
close(drawROI)

%% Save structures
save(supplementalFile, 'SuppData')

depthStack_A = DepthStack(1:6000);
depthStack_B = DepthStack(6001:12000);
depthStack_C = DepthStack(12001:18000);

save([depthStackFile(1:end - 15) '_TrueDepthStack_A.mat'], 'depthStack_A', '-v7.3');
save([depthStackFile(1:end - 15) '_TrueDepthStack_B.mat'], 'depthStack_B', '-v7.3');
save([depthStackFile(1:end - 15) '_TrueDepthStack_C.mat'], 'depthStack_C', '-v7.3');

end

