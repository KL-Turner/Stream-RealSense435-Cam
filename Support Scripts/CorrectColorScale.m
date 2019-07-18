function [] = CorrectColorScale(supplementalFile)
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

load(supplementalFile)
cMin(1,1) = SuppData.depthStack_A.caxis(1,1);
cMin(1,2) = SuppData.depthStack_B.caxis(1,1);
cMin(1,3) = SuppData.depthStack_C.caxis(1,1);
caxisMin = min(cMin);

cMax(1,1) = SuppData.depthStack_A.caxis(1,2);
cMax(1,2) = SuppData.depthStack_B.caxis(1,2);
cMax(1,3) = SuppData.depthStack_C.caxis(1,2);
caxisMax = max(cMax);

SuppData.caxis = [caxisMin caxisMax];
save(supplementalFile, 'SuppData')

end
