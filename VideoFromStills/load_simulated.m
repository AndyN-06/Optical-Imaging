function [meas_np, psf_np, mask_np] = load_simulated()
% description


downsampling_factor = 16;

% load shutter mask in
mask = load('shutter_ds.mat');
mask_np = mask.shutter_indicator(2:end-1,:,:);

% load data in
meas = load('meas_simulated.mat');
meas_np = meas.im;

% make mask same dim as measurement
row = size(meas_np, 1) / 2;
col = size(meas_np, 2) / 2;
mask_np = mask_np(row + 1: end - row, col + 1: end - col);

% load and downsample psf
psf = imread('psf.tif');
psf = imresize(psf, 1 / downsampling_factor);
psf_np = psf(2:end,:,2);

end


% def load_simulated():
%     downsampling_factor = 16
%     mask_np = scipy.io.loadmat('data/single_shot_video/shutter_ds.mat')['shutter_indicator'][1:-2,...]
%     meas_np = scipy.io.loadmat('data/single_shot_video/meas_simulated.mat')['im']
%     mask_np = mask_np[meas_np.shape[0]//2:-meas_np.shape[0]//2, meas_np.shape[1]//2:-meas_np.shape[1]//2]
%     psf_np = load_data('data/single_shot_video/psf.tif',downsampling_factor)[1:][...,1]
%     return meas_np, psf_np, mask_np