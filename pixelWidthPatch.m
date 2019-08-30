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

depthStackDirectory = dir('*_DepthStack.mat');
depthStackFiles = {depthStackDirectory.name}';
depthStackFile = char(depthStackFiles);
supplementalFile = [depthStackFile(1:end - 15) '_SupplementalData.mat'];
load(depthStackFile)
frame = DepthStack{1,1};
load(supplementalFile)

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

cageWidth = 14; inches

%% Save structures
save(supplementalFile, 'SuppData')
