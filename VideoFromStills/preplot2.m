function [outputArg1,outputArg2] = preplot2(inputArg1,inputArg2)
%PREPLOT2 Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

% OG CODE
% def preplot2(recons):
%     recons = cu.ts_to_np(recons).transpose(2,3,0,1)
%     recons /= np.max(recons)
%     recons = np.clip(recons, 0,1)
%     return recons
