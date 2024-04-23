function net = get_net(input_depth, NET_TYPE, pad, upsample_mode, n_channels, act_fun, skip_n33d, skip_n33u, skip_n11, num_scales, downsample_mode)
%Sets up a net for the neural network inverse problem optimization?

%Defaults
if nargin < 11
    downsample_mode = 'stride';
end
if nargin < 10
    num_scales = 5;
end
if nargin < 9
    skip_n11 = 4;
end
if nargin < 8
    skip_n33u = 128;
end
if nargin < 7
    skip_n33d = 128;
end
if nargin < 6
    act_fun = 'LeakyReLU';
end
if nargin < 5
    n_channels = 3;
end

if strcmp(NET_TYPE, 'skip')
    net = skip(input_depth, n_channels, 'num_channels_down', repelem(skip_n33d, num_scales), ...
        'num_channels_up', repelem(skip_n33u, num_scales), ...
        'num_channels_skip', repelem(skip_n11, num_scales), ...
        'upsample_mode', upsample_mode, 'downsample_mode', downsample_mode, ...
        'need_sigmoid', true, 'need_bias', true, 'pad', pad, 'act_fun', act_fun);
elseif strcmp(NET_TYPE, 'skip3D')
    net = skip3D(input_depth, n_channels, 'num_channels_down', repelem(skip_n33d, num_scales), ...
        'num_channels_up', repelem(skip_n33u, num_scales), ...
        'num_channels_skip', repelem(skip_n11, num_scales), ...
        'upsample_mode', upsample_mode, 'downsample_mode', downsample_mode, ...
        'need_sigmoid', true, 'need_bias', true, 'pad', pad, 'act_fun', act_fun);
else
    assert(false, 'Invalid NET_TYPE');
end


end



% ## adapted from https://github.com/DmitryUlyanov/deep-image-prior
% 
% from .skip import skip
% from .skip3D import skip3D
% 
% import torch.nn as nn
% 
% def get_net(input_depth, NET_TYPE, pad, upsample_mode, n_channels=3, act_fun='LeakyReLU', skip_n33d=128, skip_n33u=128, skip_n11=4, num_scales=5, downsample_mode='stride'):
% 
%     if NET_TYPE == 'skip':
%         net = skip(input_depth, n_channels, num_channels_down = [skip_n33d]*num_scales if isinstance(skip_n33d, int) else skip_n33d,
%                                             num_channels_up =   [skip_n33u]*num_scales if isinstance(skip_n33u, int) else skip_n33u,
%                                             num_channels_skip = [skip_n11]*num_scales if isinstance(skip_n11, int) else skip_n11, 
%                                             upsample_mode=upsample_mode, downsample_mode=downsample_mode,
%                                             need_sigmoid=True, need_bias=True, pad=pad, act_fun=act_fun)
%     elif NET_TYPE == 'skip3D':
%             net = skip3D(input_depth, n_channels, num_channels_down = [skip_n33d]*num_scales if isinstance(skip_n33d, int) else skip_n33d,
%                                                 num_channels_up =   [skip_n33u]*num_scales if isinstance(skip_n33u, int) else skip_n33u,
%                                                 num_channels_skip = [skip_n11]*num_scales if isinstance(skip_n11, int) else skip_n11, 
%                                                 upsample_mode=upsample_mode, downsample_mode=downsample_mode,
%                                                 need_sigmoid=True, need_bias=True, pad=pad, act_fun=act_fun)
%     else:
%         assert False
% 
%     return net
