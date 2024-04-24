function padded = pad_zeros(h_var)
    [rows, cols] = size(h_var);
    padded = zeros(2 * rows, 2 * cols, 'like', h_var);
    padded(1:rows, 1:cols) = h_var;
end

