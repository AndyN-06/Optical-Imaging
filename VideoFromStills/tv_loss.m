function loss = tv_loss(x, beta)
%tv_loss calculates TV loss for an image 'x'
%Total-Variation loss is the sum of absolute differences between
%neighboring pixels in horizontal and vertical directions

%Inputs:
%   x: the image array
% beta: See https://arxiv.org/abs/1412.0035 (fig. 2) for effect of 'beta'

%Default value
if nargin < 2
    beta = 0.5;
end

%Absolute difference between neighboring pixels along both directions
dh = power(x(:,:,:,2:end) - x(:,:,:,1:end-1), 2);
dw = power(x(:,:,2:end,:) - x(:,:,1:end-1,:), 2);

%Sum horizontal and vertical
loss = sum(dh(:, :, 1:end-1) + dw(:, :, :, 1:end-1), 'all');


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
