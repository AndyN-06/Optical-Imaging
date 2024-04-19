% added deep learning toolkit to matlab
% added parallel computing toolbox

%CELL 1
%imports that I do not know what is needed yet
%might need to activate some gpu stuff for computation -> python uses cuda
    %for this
    % add parallel computing toolbox for this
    % run gpuDeviceCount to see if you have gpu available for this
%external functions added as matlab functions to directory

%CELL 2
simulated = false;

%load the data in
if simulated == true
    [raw_data, psf, shutter_mask] = load_simulated();
else
    downsampling_factor = 8;
%     raw_data = imread('meas_dart.tif');
%     psf = imread('psf.tif');
%     shutter_mask = load('shutter.mat');
    raw_data = load_data('meas_dart.tif', downsampling_factor);
    psf = load_data('psf.tif', downsampling_factor);
    shutter_mask = load_mask('shutter.mat', size(raw_data));
end

%Plot the figures
figure;
subplot(1,3,1);
imshow(psf, []);
title('PSF');
set(gca, 'Visible', 'on');
subplot(1,3,2);
imshow(raw_data, []);
title('Measurement');
set(gca, 'Visible', 'on');
subplot(1,3,3);
imshow(shutter_mask(:,:,20), []);
title('Rolling shutter mask');
set(gca, 'Visible', 'on');

%CELL 3
[DIMS0, DIMS1] = size(raw_data); %image dimensions

py = floor(DIMS0 / 2);
px = floor(DIMS1 /2);
 
psf_pad = pad(psf); %function def at bottom of file
 
h_full = fftshift(fft2(psf_pad));
 
% %CELL 4
% if simulated == true
%     forward = forward_model_combined(h_full, shutter = shutter_mask, imaging_type = 'video');
% else
%     forward = forward_model(sum(psf, 3), shutter_mask);
% end
% 
% %CELL 5
% %define network hyperparameters
% input_depth = size(shutter_mask, ndims(shutter_mask));
% INPUT = 'noise';
% padvar = 'reflection';
% LR = 1e-3;
% 
% tv_weight = 1e-20;
% reg_noise_std = 0.05;
% 
% %initialize network input
% if simulated == true
%     input_depth = 3;
%     num_iter = 20000;
%     %not sure if correct -> have to check what exactly is being done in og
%     %python code and make sure this matlab is doing same or something
%     %similar
%     noise_size = [size(shutter_mask, ndims(shutter_mask)), size(raw_data, 1), size(raw_data, 2)];
%     net_input = get_noise(input_depth, INPUT, noise_size);
% else
%     num_iter = 1000;
%     %same as above
%     noise_size = [size(raw_data, 1) * 2, size(raw_data, 2) * 2];
%     net_input = get_noise(input_depth, INPUT, noise_size);
% end

%init network and optimizer

    

%function definitions defined and used in this file
function out = pad(x, py, px)
    if ndims(x) == 2 %#ok<ISMAT> %if # dimensions = 2 aka its greyscale
        out = padarray(x, [py, px], 0, 'both'); %pad both sides of each dim
    elseif ndims(x) == 3
        out = padarray(x, [px, py, 0], 0, 'both');
    elseif ndims(x) == 4
        out = padarray(x, [py, px, 0, 0], 0, 'both');
    end
end