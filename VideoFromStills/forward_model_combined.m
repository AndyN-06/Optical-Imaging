classdef forward_model_combined < handle
    %FORWARD_MODEL_COMBINED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        imaging_type
        DIMS0
        DIMS1
        PAD_SIZE0
        PAD_SIZE1
        H
        shutter
        shutter_var
    end
    
    methods
        function model = forward_model_combined(h_in, imaging_type)
            model.imaging_type = imaging_type;
            model.DIMS0 = size(h_in, 1);
            model.DIMS1 = size(h_in, 2);
            
            model.PAD_SIZE0 = floor(model.DIMS0 / 2);
            model.PAD_SIZE1 = floor(model.DIMS1 / 2);
            
            h = h_in;
            
            model.H = gpuArray(single(h));
            
            model.shutter = permute(shutter, [3, 1, 2]);
            model.shutter_var = gpuArray(single(model.shutter));
        end
        
        function out_r = Hfor(model, x)
            xc = complex(x, zeros(size(x), 'like', x));
            X = fft2(xc);
            HX = model.H .* X;
            out = ifft2(HX);
            out_r = real(out);
        end
        
        function output = forward(model, in_image)
            pad_size = [model.PAD_SIZE, model.PAD_SIZE1];
            
            if (strcmp(model.imaging_type, 'spectral') || strcmp(model.imaging_type, 'video'))
                if ndims(in_image) == 5
                    padded = padarray(in_image, pad_size, 'replicate', 'both');
                    processed = model.Hfor(padded);
                    cropped = processed(pad_size(1) + 1:end - pad_size(1), pad_size(2) + 1:end - pad_size(2), :);
                    output = sum(model.shutter_var .* cropped, 3);
                else
                    padded = padarray(in_image, pad_size, 'replicate', 'both');
                    processed = model.Hfor(padded);
                    cropped = processed(pad_size(1) + 1:end - pad_size(1), pad_size(2) + 1:end - pad_size(2), :);
                    output = sum(model.shutter_var .* cropped, 2);
                end
            elseif strcmp(model.imaging_type, '2D_erasures')
                padded = padarray(in_image, pad_size, 'replicate', 'both');
                processed = model.Hfor(padded);
                cropped = processed(pad_size(1)+1:end-pad_size(1), pad_size(2)+1:end-pad_size(2), :);
                output = model.shutter_var .* cropped;
            elseif strcmp(model.imaging_type, '2D')
                padded = padarray(in_image, pad_size, 'replicate', 'both');
                processed = model.Hfor(padded);
                cropped = processed(pad_size(1)+1:end-pad_size(1), pad_size(2)+1:end-pad_size(2), :);
                output = cropped;
            else
                padded = padarray(in_image, pad_size, 'replicate', 'both');
                processed = obj.Hfor(padded);
                cropped = processed(pad_size(1)+1:end-pad_size(1), pad_size(2)+1:end-pad_size(2), :);
                output = sum(cropped, 1);
            end
        end
    end
end

% ORIGINAL CODE
% class Forward_Model_combined(torch.nn.Module):
%     def __init__(self, h_in, imaging_type = '2D', shutter=0, cuda_device = 0):
%         super(Forward_Model_combined, self).__init__()
% 
%         self.cuda_device = cuda_device
%         self.imaging_type = imaging_type
%          ## Initialize constants 
%         self.DIMS0 = h_in.shape[0]  # Image Dimensions
%         self.DIMS1 = h_in.shape[1]  # Image Dimensions
%         
%         self.PAD_SIZE0 = int((self.DIMS0)//2)                           # Pad size
%         self.PAD_SIZE1 = int((self.DIMS1)//2)                           # Pad size
%         
%         h = h_in
%             
%         self.H = torch.stack((torch.tensor(np.real(h),dtype=torch.float32, device=self.cuda_device), 
%                       torch.tensor(np.imag(h),dtype=torch.float32, device=self.cuda_device)),-1).unsqueeze(0)
%         
%         self.shutter = np.transpose(shutter, (2,0,1))
%         self.shutter_var = torch.tensor(self.shutter, dtype=torch.float32, device=self.cuda_device).unsqueeze(0)
% 
%         
%     def Hfor(self, x):
%         xc = torch.stack((x, torch.zeros_like(x, dtype=torch.float32)), -1)
%         X = torch.fft(xc,2)
%         HX = complex_multiplication(self.H,X)
%         out = torch.ifft(HX,2)
%         out_r, _ = torch.unbind(out,-1)
%         return out_r
%     
%         
%     def forward(self, in_image):
%         
%         if self.imaging_type == 'spectral' or self.imaging_type == 'video':
%             if len(in_image.shape)==5:
%                 output = torch.sum(self.shutter_var.unsqueeze(0) * crop_forward(self,  self.Hfor(my_pad(self, in_image))), 2)
%             else:
%                 output = torch.sum(self.shutter_var * crop_forward(self,  self.Hfor(my_pad(self, in_image))), 1)
%         elif self.imaging_type == '2D_erasures':
%             output = self.shutter_var*crop_forward(self,  self.Hfor(in_image))
%         elif self.imaging_type == '2D':
%             output = crop_forward(self,  self.Hfor(in_image))
%         else:
%             output = torch.sum(crop_forward(self,  self.Hfor(in_image)), 1)
%         return output