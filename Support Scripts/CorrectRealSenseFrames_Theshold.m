function CorrectRealSenseFrames_Theshold(depthStackFile)
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

disp('CorrectRealSenseFrames: Threshold'); disp(' ')
if ~exist([depthStackFile(1:end-21) '_Threshold_' depthStackFile(end-4:end)], 'file')
    meanSubStackFile = [depthStackFile(1:end-21) '_MeanSub_' depthStackFile(end-4:end)];
    load(meanSubStackFile)
    
    %% Set remaining pixels above threshold = to zero
    threshImgStack = zeros(size(meanSubImgStack,1), size(meanSubImgStack,2), size(meanSubImgStack,3));
    for a = 1:size(meanSubImgStack,3)
        disp(['Setting pixels greater than zero back to zero... (' num2str(a) '/' num2str(length(meanSubImgStack)) ')']); disp(' ')
        tempImg = meanSubImgStack(:,:,a);
        threshIndeces = tempImg > 0;
        tempImg(threshIndeces) = 0;
        threshImgStack(:,:,a) = tempImg;
    end
    save([depthStackFile(1:end-21) '_Threshold_' depthStackFile(end-4:end)], 'threshImgStack', '-v7.3')
else
    disp([depthStackFile(1:end-21) '_Threshold_' depthStackFile(end-4:end) ' already exists. Continuing...']); disp(' ')
end

end
