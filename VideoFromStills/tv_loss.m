function [outputArg1,outputArg2] = tv_loss(inputArg1,inputArg2)
%TV_LOSS Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

% ORIGINAL CODE
% def tv_loss(x, beta = 0.5):
%     '''Calculates TV loss for an image `x`.
%         
%     Args:
%         x: image, torch.Variable of torch.Tensor
%         beta: See https://arxiv.org/abs/1412.0035 (fig. 2) to see effect of `beta` 
%     '''
%     x = x.cuda()
%     dh = torch.pow(x[:,:,:,1:] - x[:,:,:,:-1], 2)
%     dw = torch.pow(x[:,:,1:,:] - x[:,:,:-1,:], 2)
%     
%     return torch.sum(dh[:, :, :-1] + dw[:, :, :, :-1] )