function [outputArg1,outputArg2] = plot(inputArg1,inputArg2)
%PLOT Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

% OG CODE
% def plot(channel, recons):
%     recons = preplot(recons)
%     #n = random.randint(0,recons.shape[-1]-1)
%     #frame = recons[:,:,n]
%     plt.imshow(np.mean(recons,-1), cmap='gray')
%     plt.title('Reconstruction: channel %d mean projection'%(channel))
%     plt.show()