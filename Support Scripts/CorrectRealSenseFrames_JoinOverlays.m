function CorrectRealSenseFrames_JoinOverlays(depthStackFile)
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

disp('CorrectRealSenseFrames: Binary Overlay'); disp(' ')
if ~exist([depthStackFile(1:end - 19) '_BinOverlay.mat'], 'file')
    
    binOverlayStackFile1 = [depthStackFile(1:end - 19) '_BinOverlay1.mat'];
    load(binOverlayStackFile1)
    
    binOverlayStackFile2 = [depthStackFile(1:end - 19) '_BinOverlay2.mat'];
    load(binOverlayStackFile2)
    
    %% Join the binary overlays
    binOverlayImgStack = horzcat(binOverlayDepthStack1, binOverlayDepthStack2);

    save([depthStackFile(1:end - 19) '_BinOverlay.mat'], 'binOverlayImgStack', '-v7.3')
else
    disp([depthStackFile(1:end - 19) '_BinOverlay.mat already exists. Continuing...']); disp(' ')
end

end
