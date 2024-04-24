function net = get_net(input_depth, NET_TYPE, padvar, upsample_mode, n_channels, act_fun, skip_n33d, skip_n33u, skip_n11, num_scales, downsample_mode)
    if strcmp(NET_TYPE, 'skip')
        layers = [];
        for scale = 1:num_scales
            % Encoder part
            conv1 = convolution2dLayer(3, skip_n33d, 'Padding', 'same', 'Stride', 2);
            act1 = leakyReluLayer(0.01, sprintf('leaky_relu%d_1', scale));
            conv2 = convolution2dLayer(3, skip_n33d, 'Padding', 'same');
            act2 = leakyReluLayer(0.01, sprintf('leaky_relu%d_2', scale));
            
            % Decoder part
            upsample = transposedConv2dLayer(2, skip_n33u, 'Stride', 2, 'Cropping', 'same', 'Name', sprintf('upsample%d', scale));
            act3 = leakyReluLayer(0.01, 'Name', sprintf('leaky_relu%d_3', scale));
            
            % Skip connections
            if skip_n11 > 0
                skip_conv = convolution2dLayer(1, skip_n11, 'Padding', 'same', 'Name', sprintf('skip_conv%d', scale));
                layers = [layers, conv1, act1, conv2, act2, skip_conv, upsample, act3];
            else
                layers = [layers, conv1, act1, conv2, act2, upsample, act3];
            end
        end
        % Final convolution to match the output depth
        final_conv = convolution2dLayer(1, n_channels, 'Padding', 'same', 'Name', 'final_conv');
        net = layerGraph(layers);
        net = addLayers(net, final_conv);
    else
        error('Unsupported NET_TYPE');
    end
end


% net = skip(input_depth, n_channels, 'num_channels_down', repelem(skip_n33d, num_scales), ...
%         'num_channels_up', repelem(skip_n33u, num_scales), ...
%         'num_channels_skip', repelem(skip_n11, num_scales), ...
%         'upsample_mode', upsample_mode, 'downsample_mode', downsample_mode, ...
%         'need_sigmoid', true, 'need_bias', true, 'pad', pad, 'act_fun', act_fun);
% end
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
