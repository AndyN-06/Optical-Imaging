function shutter = load_mask(path, target_shape)
% load and shape the shutter

shut = load(path);
shutter = shut.shutter_indicator;

row = floor(size(shutter, 1) / 4);
col = floor(size(shutter, 2) /4);

shutter = shutter(row+1:end-row, col+1:end-col, :);
shutter = imresize(shutter, [target_shape(1), target_shape(2)], 'Antialiasing', true);

% shutter = double(shutter);
% shutter = (shutter - min(shutter(:))) / (max(shutter(:)) - min(shutter(:)));
end

% def load_mask(path, target_shape):
%     shutter = io.loadmat(path)['shutter_indicator']
%     shutter = shutter[shutter.shape[0]//4:-shutter.shape[0]//4,shutter.shape[1]//4:-shutter.shape[1]//4,:]
%     shutter = skimage.transform.resize(shutter, (target_shape[0],target_shape[1]), anti_aliasing = True)
%     return shutter