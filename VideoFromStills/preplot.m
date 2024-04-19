function [outputArg1,outputArg2] = preplot(inputArg1,inputArg2)
%PREPLOT Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

%OG CODE

% def preplot(recons):
%     recons = cu.ts_to_np(recons).transpose(1,2,0)
%     recons /= np.max(recons)
%     return recons[recons.shape[0]//4:-recons.shape[0]//4,recons.shape[1]//4:-recons.shape[1]//4]
