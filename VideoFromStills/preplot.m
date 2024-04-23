function recons = preplot(recons)
%preplot reorders the input (image?) array and discards the 1/4 boundary in
%the first two dimensions while keeping the middle 1/2

%Reorder input array
recons = permute(recons, [2, 3, 1]);

%Rescale by dividing with maximum value
recons = recons / max(recons, [], 'all');

%Determine size of array and return middle 1/2 in first two dimensions
[m, n, ~] = size(recons);
recons = recons(floor(m/4) : floor(3*m/4), floor(n/4) : floor(3*n/4), :);

end

%OG CODE

% def preplot(recons):
%     recons = cu.ts_to_np(recons).transpose(1,2,0)
%     recons /= np.max(recons)
%     return recons[recons.shape[0]//4:-recons.shape[0]//4,recons.shape[1]//4:-recons.shape[1]//4]
