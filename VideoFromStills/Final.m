% added deep learning toolkit to matlab
% added parallel computing toolbox

%CELL 1
%imports that I do not know what is needed yet

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
 
psf_pad = pad(psf, 1, 2); %function def at bottom of file
 
h_full = fftshift(fft2(psf_pad));
 
%CELL 4

forward = forward_model(sum(psf, 3), shutter_mask);

% CELL 5
% define network hyperparameters
input_depth = size(shutter_mask, ndims(shutter_mask));
INPUT = 'noise';
padvar = 'reflection';
LR = 1e-3;
 
tv_weight = 1e-20;
reg_noise_std = 0.05;
 
% initialize network input
num_iter = 1000;
noise_size = [size(shutter_mask, 1) * 2, size(shutter_mask, 2) * 2];
net_input = get_noise(input_depth, INPUT, noise_size, 1/10);


% init network and optimizer
NET_TYPE = 'skip';
net = get_net(input_depth, NET_TYPE, padvar, 'bilinear', 72, 'LeakyReLU', 128, 128, 4, 5, 'stride');

lgraph = layerGraph(net);
p = {lgraph.Layers(:).Weights};

full_recons = main(meas_np, net_input, reg_noise_std, forward, num_iter, p);  

plot_slider(full_recons);

% Inverse Problem function
function full_recons = main(meas_np, net_input_saved, reg_noise_std, forward_model, num_iter, p)
    % array to store images
    full_recons = zeros(size(meas_np, 1), size(meas_np, 2), 3);
    
    m = cellfun(@(x) zeros(size(x)), p, 'UniformOutput', false); % first moment estimate
    v = cellfun(@(x) zeros(size(x)), p, 'UniformOutput', false); % second moment estimate
    t = 0;

    % for each rgb color channel (1-3)
    for channel = 1:3
        % set meas_ts to meas_np for that channel
        meas_ts = meas_np(:,:,channel);
        meas_ts = single(meas_ts);
        
        for i = 1:num_iter
            % add noise
            net_input = net_input_saved + reg_noise_std * randn(size(net_input_saved), 'single');
                        
            recons = forward_model.forward(net_input);
            gen_meas = normalize(recons, [1 2], 'p', 2);
            
            % set gradient
            [grad, ~] = compute_gradient(p, gen_meas, meas_ts);

%             if mod(i, 100) == 0
%                 plot_channel_reconstructions(channel, recons);
%             end
            
            % update with Adam
            t = t + 1;
            for j = 1:numel(p)
                [p{j}, m{j}, v{j}] = Adam(p{j}, LR, grad{j}, m{j}, v{j}, t);
            end
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

function plot_slider(full_recons)
    f = figure("Name", 'Reconstruction Viewer', 'NumberTitle', 'off');
    ax = axes('Parent', f);

    num_frames = size(full_recons, 3);  % Assuming third dimension is the number of frames
    img = imshow(full_recons(:, :, :, 1), 'Parent', ax);  % Correct initial display assuming RGB and frames along 4th dim

    % Correct the 'Style' typo and the 'max' property syntax in the slider setup
    slider = uicontrol('Parent', f, 'Style', 'slider', ...
                       'Position', [150, 50, 300, 20], ...
                       'Value', 1, 'Min', 1, 'Max', num_frames, ...
                       'SliderStep', [1/(num_frames-1), 10/(num_frames-1)]);

    % Update the event name from 'ContinuousValueChange' to 'ContinuousValueChanging'
    % This is necessary for compatibility with different MATLAB versions
    % Also, fix function name typo from 'updateImages' to 'updateImage'
    addlistener(slider, 'ContinuousValueChanging', @(src, evt) updateImage(src, full_recons, img, ax));

    % Define the updateImage function within the plot_slider function
    function updateImage(src, full_recons, img, ax)
        frame = round(src.Value);
        set(img, 'CData', full_recons(:, :, :, frame));
        title(ax, sprintf('Reconstruction: Frame %d', frame));
    end
end
