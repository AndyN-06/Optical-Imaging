img = imread('building.jpg');
img = rgb2gray(img);

figure;
imshow(img);
title('original');

img = double(img);
freq = 75;
[m, n] = size(img);
[u, v] = meshgrid(-floor(n/2):ceil(n/2)-1, -floor(m/2):ceil(m/2)-1);

%low pass
D = sqrt(u .^ 2 + v .^ 2);
low = double(D <= freq);

%high pass
high = double(D > freq);

F = fftshift(fft2(img));

glow = low .* F;
ghigh = high .* F;

imglow = ifft2(ifftshift(glow));
imghigh = ifft2(ifftshift(ghigh));

figure;
imshow(mat2gray(abs(imglow)));
title('low pass');

figure;
imshow(mat2gray(abs(imghigh)));
title('high pass');