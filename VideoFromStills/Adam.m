function [theta, m, v] = Adam(theta_init, lr, grad, m, v, t)
% Define hyperparameters

alpha = lr; % learning rate
beta1 = 0.9; % decay rate for first moment estimate
beta2 = 0.999; % decay rate for second moment estimate
epsilon = 1e-8; % constant to avoid division by zero

    % Update first moment estimate
m = beta1 * m + (1 - beta1) * grad;

    % Update second moment estimate
v = beta2 * v + (1 - beta2) * (grad.^2);

    % Correct bias in first and second moment estimates
m_hat = m / (1 - beta1^t);
v_hat = v / (1 - beta2^t);

    % Compute learning rate for each parameter
learning_rate = alpha ./ (sqrt(v_hat) + epsilon);
    % Save learning rate for current iteration
learning_rates(t) = learning_rate(1); % assuming theta is a column vector
    % Update parameters
theta = theta_init - learning_rate .* m_hat;
end

