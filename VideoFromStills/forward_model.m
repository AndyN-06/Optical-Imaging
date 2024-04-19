classdef forward_model
    %FORWARD_MODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = forward_model(inputArg1,inputArg2)
            %FORWARD_MODEL Construct an instance of this class
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

%ORIGINAL CODE

% class Forward_Model(nn.Module):
%     def __init__(self, h, eraser=None, cuda_device = 0):
%         super(Forward_Model, self).__init__()
% 
%         self.cuda_device = cuda_device
%          ## Initialize constants 
%         self.DIMS0 = h.shape[0]  # Image Dimensions
%         self.DIMS1 = h.shape[1]  # Image Dimensions
%         
%         self.PAD_SIZE0 = int((self.DIMS0)//2)                           # Pad size
%         self.PAD_SIZE1 = int((self.DIMS1)//2)                           # Pad size
%         
%         self.h_var = torch.nn.Parameter(torch.tensor(h, dtype=torch.float32, device=self.cuda_device),
%                                             requires_grad=False)
%             
%         self.h_zeros = torch.nn.Parameter(torch.zeros(self.DIMS0*2, self.DIMS1*2, dtype=torch.float32, device=self.cuda_device),
%                                           requires_grad=False)
% 
%         self.h_complex = torch.stack((pad_zeros_torch(self, self.h_var), self.h_zeros),2).unsqueeze(0)
%         
%         self.const = torch.tensor(1/np.sqrt(self.DIMS0*2 * self.DIMS1*2), dtype=torch.float32, device=self.cuda_device)
%         
%         self.H = torch.fft(batch_ifftshift2d(self.h_complex).squeeze(), 2)   
%         
%         self.eraser = torch.tensor(eraser.transpose(2,0,1), dtype=torch.float32, device=self.cuda_device).unsqueeze(0)
%         
%     def Hfor(self, x):
%         xc = torch.stack((x, torch.zeros_like(x, dtype=torch.float32)), -1)
%         X = torch.fft(xc,2)
%         HX = complex_multiplication(self.H,X)
%         out = torch.ifft(HX,2)
%         out_r, _ = torch.unbind(out,-1)
%         return out_r
%         
%     def forward_zero_pad(self, in_image):
%         output = self.Hfor(pad_zeros_torch(self,in_image))
%         return crop(self,output)*self.eraser
%     
%     def forward(self, in_image):
%         output = self.Hfor(in_image)
%         return crop(self, output)*self.eraser