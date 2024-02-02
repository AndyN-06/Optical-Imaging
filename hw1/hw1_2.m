x = [-50:1:49];
y =[-50:1:49];

[X, Y] = meshgrid(x, y);

%make f
f = zeros(length(x), length(y));

f(51,51) = 1;
f(56,51) = 1;
f(51,56) = 1;
f(4,51) = 1;
f(51,99) = 1;
f(99,99) = 1;

%plot f
figure;
imagesc(x, y, f);
axis square;
title('f');
xlabel('x');
ylabel('y');

%make h circular function
h = zeros(length(x), length(y));
rad = sqrt(X.^2 + Y.^2);
h(rad <= 7.5) = 1;

%plot h
figure;
imagesc(x, y, h);
axis square;
title('PSF h');
xlabel('x');
ylabel('y');

% a) do direct convolution
g_dir = conv2(f, h, 'full');

%plot g_dir
figure;
imagesc(g_dir);
axis square;
title('g_direct');
xlabel('x');
ylabel('y');

% b) DFT method
F = fftshift(fft2(f));
H = fftshift(fft2(h));
G = F .* H;
g_dft = ifftshift(ifft2(G));

%plot g_dft
figure;
imagesc(abs(g_dft));
axis square;
title('g_dft');
xlabel('u');
ylabel('v');
colorbar;

% d)
F = fft2(f, 256, 256);
H = fft2(h, 256, 256);
G = F .* H;
g_dftpad = ifft2(G);

%plot
figure;
imagesc(abs(g_dftpad));
axis square;
title('g_dft_padding');
xlabel('u');
ylabel('v');
colorbar:

