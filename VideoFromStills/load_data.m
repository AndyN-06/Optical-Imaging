function [outputArg1,outputArg2] = load_data(inputArg1,inputArg2)
%LOAD_DATA Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

% def load_data(path, f):
%     img = np.array(Image.open(path))
%     img = skimage.transform.resize(img, (img.shape[0]//f,img.shape[1]//f), anti_aliasing = True)
%     img /= np.max(img)
%     return img