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
%load the data in
downsampling_factor = 8;
%     raw_data = imread('meas_dart.tif');
%     psf = imread('psf.tif');
%     shutter_mask = load('shutter.mat');
raw_data = load_data('meas_dart.tif', downsampling_factor);
psf = load_data('psf.tif', downsampling_factor);
shutter_mask = load_mask('shutter.mat', size(raw_data));

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
 
%CELL 4

forward = forward_model(sum(psf, 3), shutter_mask);

%CELL 5
%define network hyperparameters
input_depth = size(shutter_mask, ndims(shutter_mask));
INPUT = 'noise';
padvar = 'reflection';
LR = 1e-3;
 
tv_weight = 1e-20;
reg_noise_std = 0.05;
 
%initialize network input
num_iter = 1000;
noise_size = [size(shutter_mask, 1) * 2, size(shutter_mask, 2) * 2];
net_input = get_noise(input_depth, INPUT, noise_size);

net_input_saved = gpuArray(net_input);
noise = gpuArray(net_input);

%init network and optimizer
NET_TYPE = 'skip';
net = 0; % models package in python = what in matlab

p = 0; % have to implement net first

full_recons = main(meas_np, net_input_saved, reg_noise_std, forward, num_iter, p);  

% Inverse Problem function
function full_recons = main(meas_np, net_input_saved, reg_noise_std, forward_model, num_iter, p)
    % array to store images
    full_recons = zeros(size(meas_np, 1), size(meas_np, 2), 3);
    
    theta = p;        
    m = zeros(size(theta)); % first moment estimate
    v = zeros(size(theta)); % second moment estimate
    t = 0;

    % for each rgb color channel (1-3)
    for channel = 1:3
        % set meas_ts to meas_np for that channel and put on GPU
        meas_ts = meas_np(:,:,channel);
        meas_ts = gpuArray(meas_ts);
        meas_ts = single(meas_ts);
        
        for i = 1:num_iter
            % add noise
            net_input = net_input_saved + reg_noise_std * randn(size(net_input_saved), 'single', 'gpuArray');
            recons = net.forward(net_input); % have to implement based on net
            
                        
            gen_meas = forward_model.forward(recons);
            gen_meas = normalize(gen_meas, [1 2], 'p', 2);
            y=sin(gen_meas);
            
            % set gradient
            [grad, ~] = compute_gradient(theta, gen_meas, meas_ts);

%             if mod(i, 100) == 0
%                 plot_channel_reconstructions(channel, recons);
%             end
            
            % update with Adam
            [theta, m, v] = Adam(theta, LR, grad, m, v, t);
            t = t + 1;
        end
        full_recons(:, :, channel) = preplot(recons);
    end
end

function out = pad(x, py, px)
    if ndims(x) == 2 %#ok<ISMAT> %if # dimensions = 2 aka its greyscale
        out = padarray(x, [py, px], 0, 'both'); %pad both sides of each dim
    elseif ndims(x) == 3
        out = padarray(x, [px, py, 0], 0, 'both');
    elseif ndims(x) == 4
        out = padarray(x, [py, px, 0, 0], 0, 'both');
    end
end