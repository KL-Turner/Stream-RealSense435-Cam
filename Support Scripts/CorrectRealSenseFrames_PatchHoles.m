function [zeroIndeces] = CorrectRealSenseFrames_PatchHoles(rsTrueDepthStackFile)
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

if ~exist(rsTrueDepthStackFile, 'file')
    load(rsTrueDepthStackFile)

    %% Fill image holes with interpolated values, outside -> in
    realsenseFrames = RS_TrueDepthStack.trueDepthStack;
    allImgs = cell(length(realsenseFrames), 1);
    for a = 1:length(realsenseFrames)
        disp(['Filling image holes... (' num2str(a) '/' num2str(length(realsenseFrames)) ')']); disp(' ') 
        image = realsenseFrames{a,1};
        onesIndeces = image >= 1;
        image(onesIndeces) = 0;
        zeroIndeces = image == 0;
        allImgs{a,1} = regionfill(image, zeroIndeces);
    end
    holeImgStack = cat(3, allImgs{:});
    save([rsTrueDepthStackFile(1:end - 19) '_PatchedHoles.mat'], 'holeImgStack', '-v7.3')

end