function [] = JoinProcessedFiles(depthStacks)
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

depthStackA_struct = load([depthStacks{1,1}(1:end-21) '_ProcDepthStack_A.mat']);
depthStackA_fieldname = fieldnames(depthStackA_struct{1,1});
depthStackA = depthStackA_struct.(depthStackA_fieldname);

depthStackB_struct = load([depthStacks{1,1}(1:end-21) '_ProcDepthStack_B.mat']);
depthStackB_fieldname = fieldnames(depthStackB_struct{1,1});
depthStackB = depthStackB_struct.(depthStackB_fieldname);

depthStackC_struct = load([depthStacks{1,1}(1:end-21) '_ProcDepthStack_C.mat']);
depthStackC_fieldname = fieldnames(depthStackC_struct{1,1});
depthStackC = depthStackC_struct.(depthStackC_fieldname);

procDepthStack = horzcat(depthStackA, depthStackB, depthStackC);
save([depthStacks{1,1}(1:end-21) '_ProcDepthStack.mat'], 'procDepthStack', '-v7.3')

end