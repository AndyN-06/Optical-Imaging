function [outputArg1,outputArg2] = load_mask(inputArg1,inputArg2)
%LOAD_MASK Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

% def load_mask(path, target_shape):
%     shutter = io.loadmat(path)['shutter_indicator']
%     shutter = shutter[shutter.shape[0]//4:-shutter.shape[0]//4,shutter.shape[1]//4:-shutter.shape[1]//4,:]
%     shutter = skimage.transform.resize(shutter, (target_shape[0],target_shape[1]), anti_aliasing = True)
%     return shutter