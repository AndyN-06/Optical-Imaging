function [net_input] = get_noise(input_depth, method, spatial_size, var)
%get_noise returns a tensor (array) of size [1, input_depth, spatial_size(1), spatial_size(2)]
%initialized in a specific way depending on "method"

%Inputs:
%   input_depth: number of channels in the tensor
%   method: 'noise' for filling tensor with noise; 'meshgrid' for meshgrid
%   spatial_size: spatial size of the tensor to initialize
%   noise_type: 'u' for uniform; 'n' for normal
%   var: Scalar for standard deviation of noise

%If spatial size is a single scalar convert to 1x2 array
if isscalar(spatial_size)
    spatial_size = [spatial_size, spatial_size];
end

%Default value for noise type
% if nargin < 4
%     noise_type = 'u';
% end

%Default value for noise variance
if nargin < 5
    var = 1/10;
end

%If method is noise
    %Creates "framework" for the tensor
if numel(spatial_size) == 2
   shape = [1, input_depth, spatial_size(1), spatial_size(2)];
else
   shape = [1, input_depth, spatial_size(1), spatial_size(2), spatial_size(3)];
end

    %Fill with noise  & mult by variance
net_input = randn(shape) * var;

% elseif strcmp(method, 'meshgrid')
%     %Input depth must be 2, throw an error if not
%     assert(input_depth == 2);
%     %Don't 100% understand what this is doing
%     [X, Y] = meshgrid((0:(spatial_size(2)-1))/(spatial_size(2)-1), (0:(spatial_size(1)-1))/(spatial_size(1)-1));
%     mesh_temp = cat(1, X, Y);
%     net_input = reshape(mesh_temp, [1, input_depth, spatial_size]);
% else
%     assert(false); %Throw error if method not on list


end

% ORIGINAL PYTHON CODE

% def get_noise(input_depth, method, spatial_size, noise_type='u', var=1./10):
%     """Returns a pytorch.Tensor of size (1 x `input_depth` x `spatial_size[0]` x `spatial_size[1]`) 
%     initialized in a specific way.
%     Args:
%         input_depth: number of channels in the tensor
%         method: `noise` for fillting tensor with noise; `meshgrid` for np.meshgrid
%         spatial_size: spatial size of the tensor to initialize
%         noise_type: 'u' for uniform; 'n' for normal
%         var: a factor, a noise will be multiplicated by. Basically it is standard deviation scaler. 
%     """
%     if isinstance(spatial_size, int):
%         spatial_size = (spatial_size, spatial_size)
%     if method == 'noise':
%         if len(spatial_size) == 2:
%             shape = [1, input_depth, spatial_size[0], spatial_size[1]]
%         else:
%             shape = [1, input_depth, spatial_size[0], spatial_size[1], spatial_size[2]]
%         net_input = torch.zeros(shape)
%         
%         fill_noise(net_input, noise_type)
%         net_input *= var            
%     elif method == 'meshgrid': 
%         assert input_depth == 2
%         X, Y = np.meshgrid(np.arange(0, spatial_size[1])/float(spatial_size[1]-1), np.arange(0, spatial_size[0])/float(spatial_size[0]-1))
%         meshgrid = np.concatenate([X[None,:], Y[None,:]])
%         net_input=  np_to_torch(meshgrid)
%     else:
%         assert False
%         
%     return net_input
% 
