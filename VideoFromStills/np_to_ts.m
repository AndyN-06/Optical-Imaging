function ts = np_to_ts(np)
%NP_TO_TM Summary of this function goes here
%   Detailed explanation goes here
ts = permute(np, [ndims(np) + 1, 1:ndims(np)]);
end

% ORIGINAL PYTHON
% def np_to_ts(np):
%     return torch.tensor(np).unsqueeze(0)