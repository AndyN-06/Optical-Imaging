function layer = bn(num_features)
    %This does something with batch normalization layers for network
    %training
    %https://www.mathworks.com/help/deeplearning/ref/nnet.cnn.layer.batchnormalizationlayer.html
    layer = batchNormalizationLayer('NumChannels', num_features);


end

% Original Python:
% def bn(num_features):
%     return nn.BatchNorm2d(num_features)
