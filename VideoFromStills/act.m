function [result] = act(act_fun)
    % Either string defining an activation function or module (e.g. nn.ReLU)
    if ischar(act_fun)
        if strcmp(act_fun, 'LeakyReLU')
            result = leakyrelu(0.2);
        elseif strcmp(act_fun, 'Swish')
            result = swish();
        elseif strcmp(act_fun, 'ELU')
            result = elu();
        elseif strcmp(act_fun, 'none')
            result = sequential();
        else
            error('Invalid activation function');
        end
    else
        result = act_fun();
    end
end

function [result] = leakyrelu(negative_slope)
    if nargin < 1
        negative_slope = 0.2;
    end
    result = reluLayer('Name', 'leakyrelu', 'NegativeSlope', negative_slope);
end

function [result] = swish()
    result = customLayer(@swish_forward, @swish_backward);
end

function [Z, memory] = swish_forward(~, X)
    Z = X ./ (1 + exp(-X));
    memory = Z;
end

function [dLdX] = swish_backward(~, ~, dLdZ, memory)
    Z = memory;
    sigmoid_Z = 1 ./ (1 + exp(-Z));
    dLdX = dLdZ .* (sigmoid_Z + Z .* sigmoid_Z .* (1 - sigmoid_Z));
end

function [result] = elu()
    result = eluLayer('Name', 'elu');
end

function [result] = sequential()
    result = layerGraph();
end



% Original Python code
% def act(act_fun = 'LeakyReLU'):
%     '''
%         Either string defining an activation function or module (e.g. nn.ReLU)
%     '''
%     if isinstance(act_fun, str):
%         if act_fun == 'LeakyReLU':
%             return nn.LeakyReLU(0.2, inplace=True)
%         elif act_fun == 'Swish':
%             return Swish()
%         elif act_fun == 'ELU':
%             return nn.ELU()
%         elif act_fun == 'none':
%             return nn.Sequential()
%         else:
%             assert False
%     else:
%         return act_fun()
