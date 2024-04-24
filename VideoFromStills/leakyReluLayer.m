function layer = leakyReluLayer(alpha, name)
    if nargin < 1
        alpha = 0.01;  % Default leakiness
    end
    if nargin < 2
        name = 'leaky_relu';  % Default name
    end
    layer = leakyReluLayer(alpha, 'Name', name);
end


