x = -2:0.01:1.99;
y = -2:0.01:1.99;

[X, Y] = meshgrid(x, y);

%1a
signal = cos(20 * pi * X);
signal_dft = fftshift(fft2(ifftshift(signal)));

n = length(y);
freq = (-n/2:n/2-1) / (n * 0.01);

figure;
subplot(1, 2, 1);
imagesc(x, y, signal);
title('Original Signal');
xlabel('x');
ylabel('y');
axis square;

subplot(1, 2, 2);
imagesc(freq, freq, log(abs(signal_dft) + 1));
title('DFT');
xlabel('u');
ylabel('v');
axis([-20 20 -30 30]);
colorbar;

%1b
signal = cos(40 * pi * Y);
signal_dft = fftshift(fft2(signal));

n = length(y);
freq = (-n/2:n/2-1) / (n * 0.01);

figure;
subplot(1, 2, 1);
imagesc(x, y, signal);
title('Original Signal');
xlabel('x');
ylabel('y');
axis square;

subplot(1, 2, 2);
imagesc(freq, freq, log(abs(signal_dft) + 1));
title('DFT');
xlabel('u');
ylabel('v');
axis([-20 20 -30 30]);
colorbar;

%1c
signal = cos(20 * pi * X + 40 * pi * Y);
signal_dft = fftshift(fft2(ifftshift(signal)));

n = length(y);
freq = (-n/2:n/2-1) / (n * 0.01);

figure;
subplot(1, 2, 1);
imagesc(x, y, signal);
title('Original Signal');
xlabel('x');
ylabel('y');
axis square;

subplot(1, 2, 2);
imagesc(freq, freq, log(abs(signal_dft) + 1));
title('DFT');
xlabel('u');
ylabel('v');
axis([-20 20 -30 30]);
colorbar;

%1d
signal = cos(40 * pi * Y) + cos(20 * pi * X);
signal_dft = fftshift(fft2(ifftshift(signal)));

n = length(y);
freq = (-n/2:n/2-1) / (n * 0.01);

figure;
subplot(1, 2, 1);
imagesc(x, y, signal);
title('Original Signal');
xlabel('x');
ylabel('y');
axis square;

subplot(1, 2, 2);
imagesc(freq, freq, log(abs(signal_dft) + 1));
title('DFT');
xlabel('u');
ylabel('v');
axis([-20 20 -30 30]);
colorbar;
