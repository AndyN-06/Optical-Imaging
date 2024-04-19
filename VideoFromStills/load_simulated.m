function [outputArg1,outputArg2] = load_simulated(inputArg1,inputArg2)
%LOAD_SIMULATED Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end


% def load_simulated():
%     downsampling_factor = 16
%     mask_np = scipy.io.loadmat('data/single_shot_video/shutter_ds.mat')['shutter_indicator'][1:-2,...]
%     meas_np = scipy.io.loadmat('data/single_shot_video/meas_simulated.mat')['im']
%     mask_np = mask_np[meas_np.shape[0]//2:-meas_np.shape[0]//2, meas_np.shape[1]//2:-meas_np.shape[1]//2]
%     psf_np = load_data('data/single_shot_video/psf.tif',downsampling_factor)[1:][...,1]
%     return meas_np, psf_np, mask_np