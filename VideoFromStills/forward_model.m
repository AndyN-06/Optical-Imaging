classdef forward_model < handle
    properties
        DIMS0
        DIMS1
        PAD_SIZE0
        PAD_SIZE1
        h_var
        h_zeros
        h_complex
        const
        H
        eraser
    end
    
    methods
        function model = forward_model(h, eraser)
           model.DIMS0 = size(h, 1);
           model.DIMS1 = size(h, 2);
           
           model.PAD_SIZE0 = floor(model.DIMS0 / 2);
           model.PAD_SIZE1 = floor(model.DIMS1 / 2);
           
           model.h_var = single(h);
           model.h_zeros = single(zeros(size(model.h_var, 1) * 2, size(model.h_var, 2) * 2));
           model.h_complex = cat(3, pad_zeros(model.h_var), model.h_zeros);
           model.const = single(1 / sqrt(numel(model.h_complex)));
           model.H = fft2(ifftshift(ifftshift(model.h_complex, 1), 2));
           model.eraser = single(permute(eraser, [3, 1, 2]));
        end
        
        function out_r = Hfor(model, x)
            xc = cat(3, x, zeros(size(x), 'like', x));
            X = fft2(xc);
            HX = model.H .* X;
            out = ifft2(HX);
            out_r = real(out);
        end
        
        function cropped = crop(model, in_image)
            [rows, cols] = size(in_image);
            start_row = floor((rows - model.DIMS0) / 2) + 1;
            start_col = floor((cols - model.DIMS1) / 2) + 1;
            end_row = start_row + model.DIMS0 - 1;
            end_col = start_col + model.DIMS1 - 1;
            cropped = in_image(start_row:end_row, start_col:end_col);
        end
        
        function output = forward_zero_pad(model, in_image)
            [rows, cols] = size(in_image);
            padded = zeros(2 * rows, 2 * cols, 'like', image);
            padded(1:rows, 1:cols) = in_image;
            output = model.Hfor(padded);
            output = crop(output) .* model.eraser;
        end
        
        function output = forward(model, in_image)
            output = model.Hfor(in_image);
            output = crop(output) .* model.eraser;
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