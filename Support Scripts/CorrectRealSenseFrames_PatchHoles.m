function CorrectRealSenseFrames_PatchHoles(depthStackFile, supplementalFile)
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

disp('CorrectRealSenseFrames: Patch Holes'); disp(' ')
if ~exist([depthStackFile(1:end-21) '_PatchedHoles_' depthStackFile(end-4:end)], 'file')
    depthStackStruct = load(depthStackFile);
    structField = fieldnames(depthStackStruct);
    depthStack = depthStackStruct.(structField{1,1});
    load(supplementalFile);
    
    %% Fill image holes with interpolated values, outside -> in
    allImgs = cell(length(depthStack),1);
    for a = 1:length(depthStack)
        disp(['Filling image holes... (' num2str(a) '/' num2str(length(depthStack)) ')']); disp(' ') 
        image = depthStack{a,1};
        onesIndeces = image >= 1;
        image(onesIndeces) = 0;
        zeroIndeces = image == 0;
        allImgs{a,1} = regionfill(image,zeroIndeces);
    end
    holeImgStack = cat(3,allImgs{:});
    save([depthStackFile(1:end-21) '_PatchedHoles_' depthStackFile(end-4:end)], 'holeImgStack', '-v7.3')
    
    %% Determine caxis scaling final movie
    disp('Determining proper caxis scaling...'); disp(' ')
    tempMax = zeros(1,size(holeImgStack,3));
    tempMin = zeros(1,size(holeImgStack,3));
    for c = 1:length(holeImgStack)
        tempImg = holeImgStack(:,:,c);
        tempMax(1,c) = max(tempImg(:));
        tempMin(1,c) = min(tempImg(:));
    end
    SuppData.(structField{1,1}).caxis = [mean(tempMin) mean(tempMax)];
    
    %% Create cage image mask
    disp('Creating image mask...'); disp(' ')
    figure;
    shell = zeros(size(zeroIndeces));
    imagesc(shell)
    hold on;
    axis off
    mask = rectangle('Position', SuppData.cage, 'Curvature', 0.25, 'FaceColor', 'white', 'EdgeColor', 'white'); %#ok<NASGU>
    frame = getframe(gca);
    maskImg = frame2im(frame);
    greyImg = rgb2gray(maskImg);
    resizedGreyImg = imresize(greyImg,[480 640]);
    SuppData.binCageImg = imbinarize(resizedGreyImg);
    close(gcf)
    save(supplementalFile, 'SuppData')
    
else
    disp([depthStackFile(1:end-21) '_PatchedHoles_' depthStackFile(end-4:end) ' already exists. Continuing...']); disp(' ')
end

end