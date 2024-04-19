classdef forward_model_combined
    %FORWARD_MODEL_COMBINED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = forward_model_combined(inputArg1,inputArg2)
            %FORWARD_MODEL_COMBINED Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
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