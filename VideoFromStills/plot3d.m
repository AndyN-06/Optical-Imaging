function [outputArg1,outputArg2] = plot3d(inputArg1,inputArg2)
%PLOT3D Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

%ORIGINAL CODE
% def plot3d(recons):
%     recons = recons[0].detach().cpu().numpy().transpose(2,3,0,1)
%     #n = random.randint(0,recons.shape[-1]-1)
%     #frame = recons[:,:,n]
%     plt.imshow(np.mean(recons,-1))
%     plt.title('Reconstruction: mean projection')
%     plt.show()