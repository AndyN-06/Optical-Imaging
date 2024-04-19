%CELL 1
%load_ext autoreload
%autoreload 2

%python imports
import matplotlib.pyplot as plt
%matplotlib inline
from ipywidgets import interact, interactive, fixed, interact_manual
import ipywidgets as widgets
import numpy as np
import torch, torch.optim
import torch.nn.functional as F
torch.backends.cudnn.enabled = True %cuda stuff
torch.backends.cudnn.benchmark =True %cuda stuff
dtype = torch.cuda.FloatTensor

import os
os.environ["CUDA_DEVICE_ORDER"] = "PCI_BUS_ID"
os.environ['CUDA_VISIBLE_DEVICES'] = '3'

%external functions that we might need to implement
import models as md
import utils.common_utils as cu
import utils.diffuser_utils as df 
import utils.utils_video as helper

%CELL 2
simulated = False

if simulated == True:
    meas_np, psf_np, mask_np = helper.load_simulated()
else:
    downsampling_factor = 8
    meas_np = helper.load_data('data/single_shot_video/meas_dart.tif', downsampling_factor)
    psf_np = helper.load_data('data/single_shot_video/psf.tif',downsampling_factor)
    mask_np = helper.load_mask('./data/single_shot_video/shutter.mat', meas_np.shape)

plt.figure(figsize=(20,10))    
plt.subplot(1,3,1);plt.title('PSF');plt.imshow(psf_np)
plt.subplot(1,3,2);plt.title('Measurement');plt.imshow(meas_np)
plt.subplot(1,3,3);plt.title('Rolling shutter mask');plt.imshow(mask_np[:,:,20]) 


%CELL 3
DIMS0 = meas_np.shape[0]  # Image Dimensions
DIMS1 = meas_np.shape[1]  # Image Dimensions

py = int((DIMS0)//2)                           # Pad size
px = int((DIMS1)//2)                           # Pad size

def pad(x):
    if len(x.shape) == 2: 
        out = np.pad(x, ([py, py], [px,px]), mode = 'constant')
    elif len(x.shape) == 3:
        out = np.pad(x, ([py, py], [px,px], [0, 0]), mode = 'constant')
    elif len(x.shape) == 4:
        out = np.pad(x, ([py, py], [px,px], [0, 0], [0, 0]), mode = 'constant')
    return out


#meas_np = pad(meas_np)
psf_pad = pad(psf_np)

h_full = np.fft.fft2(np.fft.ifftshift(psf_pad))


%CELL 4
if simulated == True:
    forward = df.Forward_Model_combined(h_full, 
                                    shutter = mask_np, 
                                    imaging_type = 'video')
else:
    forward = df.Forward_Model(np.sum(psf_np, axis=2), mask_np)
    
%CELL 5
# Define network hyperparameters: 
input_depth = mask_np.shape[-1]
INPUT =     'noise'
pad   =     'reflection'
LR = 1e-3

tv_weight = 1e-20
reg_noise_std = 0.05

# Initialize network input 
if simulated == True:
    input_depth = 3
    num_iter = 20000
    net_input = cu.get_noise(input_depth, INPUT, (mask_np.shape[-1], meas_np.shape[0], meas_np.shape[1])).type(dtype).detach()
else:
    num_iter = 10000
    net_input = cu.get_noise(input_depth, INPUT, (meas_np.shape[0]*2, meas_np.shape[1]*2)).type(dtype).detach()
    
net_input_saved = net_input.detach().clone()
noise = net_input.detach().clone()

# initialize netowrk and optimizer

if simulated == True:
    NET_TYPE = 'skip3D' 
    net = md.get_net(input_depth, NET_TYPE, pad, n_channels=3, skip_n33d=128,  skip_n33u=128,  skip_n11=4,  num_scales=5,upsample_mode='trilinear').type(dtype)

else:
    NET_TYPE = 'skip' 
    net = md.get_net(input_depth, NET_TYPE, pad, n_channels=72, skip_n33d=128,  skip_n33u=128,  skip_n11=4,  num_scales=5,upsample_mode='bilinear').type(dtype)

p = [x for x in net.parameters()]
optimizer = torch.optim.Adam(p, lr=LR)

# Losses
mse = torch.nn.MSELoss().type(dtype)

if simulated == True:
    def main():
        global recons
        meas_ts = cu.np_to_ts(meas_np.transpose(2,0,1))
        meas_ts = meas_ts.detach().clone().type(dtype).cuda()
        print(meas_ts.shape, 'meas')
        for i in range(num_iter):
            optimizer.zero_grad()
            net_input = net_input_saved + (noise.normal_() * reg_noise_std)
            recons = net(net_input)
            gen_meas = forward.forward(recons)
            gen_meas = F.normalize(gen_meas, dim=[1,2], p=2)
            loss = mse(gen_meas, meas_ts)
            loss += tv_weight * df.tv_loss(recons)
            loss.backward()
            print('Iteration %05d, loss %.8f '%(i, loss.item()), '\r',  end='')
            if i % 100 == 0:
                helper.plot3d(recons)
                print('Iteration {}, loss {:.8f}'.format(i, loss.item()))
            optimizer.step()
        full_recons= helper.preplot2(recons)
        return full_recons
else:
    def main():
        full_recons = []
        for channel in range (3):
            meas_ts = cu.np_to_ts(meas_np[:,:,channel])
            meas_ts = meas_ts.detach().clone().type(dtype).cuda()

            for i in range(num_iter):
                optimizer.zero_grad()
                net_input = net_input_saved + (noise.normal_() * reg_noise_std)
                recons = net(net_input)
                gen_meas = forward.forward(recons)
                gen_meas = F.normalize(gen_meas, dim=[1,2], p=2)
                loss = mse(gen_meas, meas_ts)
                loss += tv_weight * df.tv_loss(recons)
                loss.backward()
                print('Iteration %05d, loss %.8f '%(i, loss.item()), '\r',  end='')
                if i % 100 == 0:
                    helper.plot(channel, recons)
                    print('Iteration {}, loss {:.8f}'.format(i, loss.item()))
                optimizer.step()
            full_recons.append(helper.preplot(recons))
        full_recons = np.stack(full_recons ,-2)
        return full_recons
        
%CELL 6       
full_recons = main()

%CELL 7
def plot_slider(x):
    plt.title('Reconstruction: frame %d'%(x))
    plt.axis('off')
    plt.imshow(full_recons[:,:,:,x])
    return x

interactive(plot_slider,x=(0,full_recons.shape[-1]-1,1))